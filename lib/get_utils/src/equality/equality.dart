library;

import 'dart:collection';

mixin Equality {
  List get props;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        runtimeType == other.runtimeType &&
            other is Equality &&
            const DeepCollectionEquality().equals(props, other.props);
  }

  @override
  int get hashCode {
    return runtimeType.hashCode ^ const DeepCollectionEquality().hash(props);
  }
}

// Using a private extension to encapsulate hash-related functionality
extension on int {
  int get _mixHash {
    var hash = this;
    hash = (hash + (hash << 3)) & 0x7fffffff;
    hash ^= (hash >> 11);
    return (hash + (hash << 15)) & 0x7fffffff;
  }
}

/// A generic equality relation on objects.
abstract class IEquality<E> {
  const factory IEquality() = DefaultEquality<E>;

  /// Compare two elements for being equal.
  ///
  /// This should be a proper equality relation.
  bool equals(E e1, E e2);

  /// Get a hashcode of an element.
  ///
  /// The hashcode should be compatible with [equals], so that if
  /// `equals(a, b)` then `hash(a) == hash(b)`.
  int hash(E e);

  /// Test whether an object is a valid argument to [equals] and [hash].
  ///
  /// Some implementations may be restricted to only work on specific types
  /// of objects.
  bool isValidKey(Object? o);
}

class DefaultEquality<E> implements IEquality<E> {
  const DefaultEquality();
  @override
  bool equals(Object? e1, Object? e2) => e1 == e2;
  @override
  int hash(Object? e) => e.hashCode;
  @override
  bool isValidKey(Object? o) => true;
}

/// Equality of objects that compares only the identity of the objects.
class IdentityEquality<E> implements IEquality<E> {
  const IdentityEquality();
  @override
  bool equals(E e1, E e2) => identical(e1, e2);
  @override
  int hash(E e) => identityHashCode(e);
  @override
  bool isValidKey(Object? o) => true;
}

class DeepCollectionEquality implements IEquality {
  final IEquality _base = const DefaultEquality<Never>();
  final bool _unordered = false;
  const DeepCollectionEquality();

  @override
  bool equals(e1, e2) {
    if (e1 is Set) {
      return e2 is Set && SetEquality(this).equals(e1, e2);
    }
    if (e1 is Map) {
      return e2 is Map && MapEquality(keys: this, values: this).equals(e1, e2);
    }

    if (e1 is List) {
      return e2 is List && ListEquality(this).equals(e1, e2);
    }
    if (e1 is Iterable) {
      return e2 is Iterable && IterableEquality(this).equals(e1, e2);
    }

    return _base.equals(e1, e2);
  }

  @override
  int hash(Object? o) {
    if (o is Set) return SetEquality(this).hash(o);
    if (o is Map) return MapEquality(keys: this, values: this).hash(o);
    if (!_unordered) {
      if (o is List) return ListEquality(this).hash(o);
      if (o is Iterable) return IterableEquality(this).hash(o);
    } else if (o is Iterable) {
      return UnorderedIterableEquality(this).hash(o);
    }
    return _base.hash(o);
  }

  @override
  bool isValidKey(Object? o) =>
      o is Iterable || o is Map || _base.isValidKey(o);
}

/// Equality on lists.
///
/// Two lists are equal if they have the same length and their elements
/// at each index are equal.
class ListEquality<E> implements IEquality<List<E>> {
  final IEquality<E> _elementEquality;
  const ListEquality(
      [IEquality<E> elementEquality = const DefaultEquality<Never>()])
      : _elementEquality = elementEquality;

  @override
  bool equals(List<E>? list1, List<E>? list2) {
    if (identical(list1, list2)) return true;
    if (list1 == null || list2 == null) return false;
    var length = list1.length;
    if (length != list2.length) return false;
    for (var i = 0; i < length; i++) {
      if (!_elementEquality.equals(list1[i], list2[i])) return false;
    }
    return true;
  }

  @override
  int hash(List<E>? list) {
    if (list == null) return null.hashCode;
    var hash = 0;
    for (var i = 0; i < list.length; i++) {
      final c = _elementEquality.hash(list[i]);
      hash = (hash + c) & 0x7fffffff;
      hash = (hash + (hash << 10)) & 0x7fffffff;
      hash ^= (hash >> 6);
    }
    return hash._mixHash;
  }

  @override
  bool isValidKey(Object? o) => o is List<E>;
}

/// Equality on maps.
///
/// Two maps are equal if they have the same number of entries, and if the
/// entries of the two maps are pairwise equal on both key and value.
class MapEquality<K, V> implements IEquality<Map<K, V>> {
  final IEquality<K> _keyEquality;
  final IEquality<V> _valueEquality;
  const MapEquality(
      {IEquality<K> keys = const DefaultEquality<Never>(),
      IEquality<V> values = const DefaultEquality<Never>()})
      : _keyEquality = keys,
        _valueEquality = values;

  @override
  bool equals(Map<K, V>? map1, Map<K, V>? map2) {
    if (identical(map1, map2)) return true;
    if (map1 == null || map2 == null) return false;
    if (map1.length != map2.length) return false;
    
    // Using records for map entries
    final counts = HashMap<(Object?, Object?), int>(
      equals: (a, b) => _mapEntriesEqual(a, b, _keyEquality, _valueEquality),
      hashCode: (e) => _mapEntryHash(e, _keyEquality, _valueEquality),
    );
    
    // Count entries in first map
    for (final entry in map1.entries) {
      final key = (entry.key, entry.value);
      counts[key] = (counts[key] ?? 0) + 1;
    }
    
    // Verify entries in second map
    for (final entry in map2.entries) {
      final key = (entry.key, entry.value);
      final count = counts[key] ?? 0;
      if (count == 0) return false;
      counts[key] = count - 1;
    }
    
    return true;
  }

  @override
  int hash(Map<K, V>? map) {
    if (map == null) return null.hashCode;
    var hash = 0;
    for (final entry in map.entries) {
      final keyHash = _keyEquality.hash(entry.key);
      final valueHash = _valueEquality.hash(entry.value);
      hash = (hash + 3 * keyHash + 7 * valueHash) & 0x7fffffff;
    }
    return hash._mixHash;
  }

  @override
  bool isValidKey(Object? o) => o is Map<K, V>;
}

// Using a record type for map entry comparison
bool _mapEntriesEqual(
  (Object?, Object?) a,
  (Object?, Object?) b,
  IEquality keyEquality,
  IEquality valueEquality,
) {
  return keyEquality.equals(a.$1, b.$1) && valueEquality.equals(a.$2, b.$2);
}

int _mapEntryHash(
  (Object?, Object?) entry,
  IEquality keyEquality,
  IEquality valueEquality,
) {
  return (3 * keyEquality.hash(entry.$1) + 7 * valueEquality.hash(entry.$2)) &
      0x7fffffff;
}

/// Equality on iterables.
///
/// Two iterables are equal if they have the same elements in the same order.
class IterableEquality<E> implements IEquality<Iterable<E>> {
  final IEquality<E?> _elementEquality;
  const IterableEquality(
      [IEquality<E> elementEquality = const DefaultEquality<Never>()])
      : _elementEquality = elementEquality;

  @override
  bool equals(Iterable<E>? elements1, Iterable<E>? elements2) {
    if (identical(elements1, elements2)) return true;
    if (elements1 == null || elements2 == null) return false;
    var it1 = elements1.iterator;
    var it2 = elements2.iterator;
    while (true) {
      var hasNext = it1.moveNext();
      if (hasNext != it2.moveNext()) return false;
      if (!hasNext) return true;
      if (!_elementEquality.equals(it1.current, it2.current)) return false;
    }
  }

  @override
  int hash(Iterable<E>? elements) {
    if (elements == null) return null.hashCode;
    var hash = 0;
    for (final element in elements) {
      final c = _elementEquality.hash(element);
      hash = (hash + c) & 0x7fffffff;
      hash = (hash + (hash << 10)) & 0x7fffffff;
      hash ^= (hash >> 6);
    }
    return hash._mixHash;
  }

  @override
  bool isValidKey(Object? o) => o is Iterable<E>;
}

/// Equality of sets.
///
/// Two sets are considered equal if they have the same number of elements,
/// and the elements of one set can be paired with the elements
/// of the other set, so that each pair are equal.
class SetEquality<E> extends _UnorderedEquality<E, Set<E>> {
  const SetEquality([super.elementEquality = const DefaultEquality<Never>()]);

  @override
  bool isValidKey(Object? o) => o is Set<E>;
}

abstract class _UnorderedEquality<E, T extends Iterable<E>>
    implements IEquality<T> {
  final IEquality<E> _elementEquality;

  const _UnorderedEquality(this._elementEquality);

  @override
  bool equals(T? elements1, T? elements2) {
    if (identical(elements1, elements2)) return true;
    if (elements1 == null || elements2 == null) return false;
    var counts = HashMap<E, int>(
        equals: _elementEquality.equals,
        hashCode: _elementEquality.hash,
        isValidKey: _elementEquality.isValidKey);
    var length = 0;
    for (var e in elements1) {
      var count = counts[e] ?? 0;
      counts[e] = count + 1;
      length++;
    }
    for (var e in elements2) {
      var count = counts[e];
      if (count == null || count == 0) return false;
      counts[e] = count - 1;
      length--;
    }
    return length == 0;
  }

  @override
  int hash(T? elements) {
    if (elements == null) return null.hashCode;
    var hash = 0;
    for (final element in elements) {
      hash = (hash + _elementEquality.hash(element)) & 0x7fffffff;
    }
    return hash._mixHash;
  }
}

/// Equality of the elements of two iterables without considering order.
///
/// Two iterables are considered equal if they have the same number of elements,
/// and the elements of one set can be paired with the elements
/// of the other iterable, so that each pair are equal.
class UnorderedIterableEquality<E> extends _UnorderedEquality<E, Iterable<E>> {
  const UnorderedIterableEquality(
      [super.elementEquality = const DefaultEquality<Never>()]);

  @override
  bool isValidKey(Object? o) => o is Iterable<E>;
}
