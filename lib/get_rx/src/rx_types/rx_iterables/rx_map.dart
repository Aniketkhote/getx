part of '../rx_types.dart';

/// A reactive map that notifies listeners when modified.
///
/// This class extends [MapMixin] and [RxObjectMixin] to provide
/// reactive capabilities to a standard Dart [Map].
class RxMap<K, V> extends GetListenable<Map<K, V>>
    with MapMixin<K, V>, RxObjectMixin<Map<K, V>> {
  RxMap([super.initial = const {}]);

  factory RxMap.from(Map<K, V> other) {
    return RxMap(Map.from(other));
  }

  /// Creates a [LinkedHashMap] with the same keys and values as [other].
  factory RxMap.of(Map<K, V> other) {
    return RxMap(Map.of(other));
  }

  ///Creates an unmodifiable hash based map containing the entries of [other].
  factory RxMap.unmodifiable(Map<dynamic, dynamic> other) {
    return RxMap(Map.unmodifiable(other));
  }

  /// Creates an identity map with the default implementation, [LinkedHashMap].
  factory RxMap.identity() {
    return RxMap(Map.identity());
  }

  @override
  V? operator [](Object? key) {
    return value[key as K];
  }

  @override
  @pragma('vm:prefer-inline')
  void operator []=(K key, V value) {
    this.value[key] = value;
    refresh();
  }

  @override
  void clear() {
    value.clear();
    refresh();
  }

  @override
  Iterable<K> get keys => value.keys;

  @override
  V? remove(Object? key) {
    final val = value.remove(key);
    if (val != null) refresh();
    return val;
  }

}

/// Extension methods for [Map] that add reactive capabilities.
extension MapExtension<K, V> on Map<K, V> {
  RxMap<K, V> get obs {
    return RxMap<K, V>(this);
  }

  /// Adds the [key]/[value] pair to the map if [condition] is true.
  ///
  /// If [condition] is a [Condition] instance, it will be evaluated.
  void addIf(dynamic condition, K key, V value) {
    final shouldAdd = condition is Condition ? condition() : condition;
    if (shouldAdd == true) {
      this[key] = value;
    }
  }

  /// Adds all key/value pairs from [values] to this map if [condition] is true.
  ///
  /// If [condition] is a [Condition] instance, it will be evaluated.
  void addAllIf(dynamic condition, Map<K, V> values) {
    final shouldAdd = condition is Condition ? condition() : condition;
    if (shouldAdd == true) {
      addAll(values);
    }
  }

  /// Replaces all existing entries with a single [key]/[val] pair.
  ///
  /// If this is an [RxMap], it will properly handle the reactive updates.
  void assign(K key, V val) {
    if (this is RxMap<K, V>) {
      final map = this as RxMap<K, V>;
      map.value.clear();
      this[key] = val;
    } else {
      clear();
      this[key] = val;
    }
  }

  /// Replaces all existing entries with the entries from [val].
  ///
  /// If this is an [RxMap], it will properly handle the reactive updates.
  void assignAll(Map<K, V> val) {
    // Early return if assigning to self
    if (identical(this, val)) return;

    if (this is RxMap<K, V>) {
      final map = this as RxMap<K, V>;
      // Skip if the underlying values are the same
      if (identical(map.value, val)) return;
      
      if (val is RxMap<K, V>) {
        // Skip if both are RxMaps with the same value
        if (identical(map.value, val.value)) return;
      }
      
      map.value = Map<K, V>.from(val);
      // The value setter already handles the refresh
    } else {
      clear();
      addAll(val);
    }
  }
}
