part of '../rx_types.dart';

/// A reactive set that notifies listeners when modified.
///
/// This class extends [SetMixin] and [RxObjectMixin] to provide
/// reactive capabilities to a standard Dart [Set].
class RxSet<E> extends GetListenable<Set<E>>
    with SetMixin<E>, RxObjectMixin<Set<E>> {
  RxSet([super.initial = const {}]);

  /// Adds all elements from another set and returns this [RxSet].
  ///
  /// This is a convenience operator that allows using the + operator
  /// to add multiple elements in a chainable way.
  @pragma('vm:prefer-inline')
  RxSet<E> operator +(Set<E> val) {
    addAll(val);
    return this;
  }

  /// Updates the set by applying the given function to the current value.
  ///
  /// The function receives the current set value and should modify it directly.
  /// The changes will be automatically reflected and listeners will be notified.
  void update(void Function(Set<E> value) fn) {
    fn(value);
    refresh();
  }

  // @override
  // @protected
  // Set<E> get value {
  //   return subject.value;
  //   // RxInterface.proxy?.addListener(subject);
  //   // return _value;
  // }

  // @override
  // @protected
  // set value(Set<E> val) {
  //   if (value == val) return;
  //   value = val;
  //   refresh();
  // }

  @override
  @pragma('vm:prefer-inline')
  bool add(E value) {
    final hasAdded = this.value.add(value);
    if (hasAdded) refresh();
    return hasAdded;
  }

  @override
  bool contains(Object? element) {
    return value.contains(element);
  }

  @override
  Iterator<E> get iterator => value.iterator;

  @override
  int get length => value.length;

  @override
  E? lookup(Object? element) {
    return value.lookup(element);
  }

  @override
  @pragma('vm:prefer-inline')
  bool remove(Object? value) {
    final hasRemoved = this.value.remove(value);
    if (hasRemoved) refresh();
    return hasRemoved;
  }

  @override
  Set<E> toSet() {
    return value.toSet();
  }

  @override
  void addAll(Iterable<E> elements) {
    value.addAll(elements);
    refresh();
  }

  @override
  void clear() {
    value.clear();
    refresh();
  }

  @override
  void removeAll(Iterable<Object?> elements) {
    value.removeAll(elements);
    refresh();
  }

  @override
  void retainAll(Iterable<Object?> elements) {
    value.retainAll(elements);
    refresh();
  }

  @override
  void retainWhere(bool Function(E) test) {
    value.retainWhere(test);
    refresh();
  }
}

/// Extension methods for [Set] that add reactive capabilities.
extension SetExtension<E> on Set<E> {
  RxSet<E> get obs {
    return RxSet<E>(<E>{})..addAll(this);
  }

  // /// Add [item] to [List<E>] only if [item] is not null.
  // void addNonNull(E item) {
  //   if (item != null) add(item);
  // }

  // /// Add [Iterable<E>] to [List<E>] only if [Iterable<E>] is not null.
  // void addAllNonNull(Iterable<E> item) {
  //   if (item != null) addAll(item);
  // }

  /// Adds [item] to this set if [condition] is true.
  ///
  /// If [condition] is a [Condition] instance, it will be evaluated.
  void addIf(dynamic condition, E item) {
    final shouldAdd = condition is Condition ? condition() : condition;
    if (shouldAdd == true) add(item);
  }

  /// Adds all elements from [items] to this set if [condition] is true.
  ///
  /// If [condition] is a [Condition] instance, it will be evaluated.
  void addAllIf(dynamic condition, Iterable<E> items) {
    final shouldAdd = condition is Condition ? condition() : condition;
    if (shouldAdd == true) addAll(items);
  }

  /// Replaces all existing items in this set with a single [item].
  ///
  /// If this is an [RxSet], it will properly handle the reactive updates.
  void assign(E item) {
    if (this is RxSet<E>) {
      final set = this as RxSet<E>;
      set.value.clear();
      set.add(item);
    } else {
      clear();
      add(item);
    }
  }

  /// Replaces all existing items in this set with [items].
  ///
  /// If this is an [RxSet], it will properly handle the reactive updates.
  void assignAll(Iterable<E> items) {
    if (this is RxSet<E>) {
      final set = this as RxSet<E>;
      set.value.clear();
      set.addAll(items);
    } else {
      clear();
      addAll(items);
    }
  }
}
