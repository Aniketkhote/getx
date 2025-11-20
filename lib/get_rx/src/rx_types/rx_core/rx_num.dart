part of '../rx_types.dart';

/// Extension for numeric reactive values.
extension RxNumExt<T extends num> on Rx<T> {
  /// Addition operator that updates the reactive value.
  Rx<T> operator +(num other) {
    value = (value + other) as T;
    return this;
  }

  /// Subtraction operator that updates the reactive value.
  Rx<T> operator -(num other) {
    value = (value - other) as T;
    return this;
  }

  /// Multiplication operator that updates the reactive value.
  Rx<T> operator *(num other) {
    value = (value * other) as T;
    return this;
  }

  /// Division operator that updates the reactive value.
  Rx<double> operator /(num other) {
    return (value / other).obs;
  }

  /// Integer division operator that updates the reactive value.
  Rx<int> operator ~/(num other) {
    return (value ~/ other).obs;
  }

  /// Returns the absolute value of this number.
  Rx<num> abs() => value.abs().obs;

  /// The sign of this number.
  ///
  /// Returns -1.0 if this number is less than 0,
  /// +1.0 if this number is greater than 0,
  /// and 0 if this number is equal to 0.
  /// Returns NaN if this number is NaN.
  num get sign => value.sign;

  /// Whether this number is negative.
  bool get isNegative => value.isNegative;

  /// Whether this number is not a number (NaN).
  bool get isNaN => value.isNaN;

  /// Whether this number is positive infinity or negative infinity.
  bool get isInfinite => value.isInfinite;

  /// Whether this number is finite.
  bool get isFinite => value.isFinite;

  /// Returns this [num] clamped to be in the range [lowerLimit]-[upperLimit].
  Rx<num> clamp(num lowerLimit, num upperLimit) =>
      value.clamp(lowerLimit, upperLimit).obs;

  /// Converts this number to an integer.
  Rx<int> toInt() => value.toInt().obs;

  /// Converts this number to a double.
  Rx<double> toDouble() => value.toDouble().obs;
}

/// Extension for nullable numeric reactive values.
extension RxnNumExt<T extends num> on Rx<T?> {
  /// Addition operator that updates the reactive value if not null.
  Rx<T?> operator +(num other) {
    if (value != null) {
      value = (value! + other) as T;
    }
    return this;
  }

  /// Subtraction operator that updates the reactive value if not null.
  Rx<T?> operator -(num other) {
    if (value != null) {
      value = (value! - other) as T;
    }
    return this;
  }

  /// Multiplication operator that updates the reactive value if not null.
  Rx<T?> operator *(num other) {
    if (value != null) {
      value = (value! * other) as T;
    }
    return this;
  }

  /// Division operator that returns a new reactive double if not null.
  Rx<double?> operator /(num other) {
    if (value != null) {
      return (value! / other).obs;
    }
    return Rx<double?>(null);
  }

  /// Integer division operator that returns a new reactive int if not null.
  Rx<int?> operator ~/(num other) {
    if (value != null) {
      return (value! ~/ other).obs;
    }
    return Rx<int?>(null);
  }

  /// Returns the absolute value of this number if not null.
  Rx<num?> abs() => value?.abs().obs ?? Rx<num?>(null);

  /// The sign of this number if not null.
  num? get sign => value?.sign;

  /// Whether this number is negative if not null.
  bool? get isNegative => value?.isNegative;

  /// Whether this number is not a number (NaN) if not null.
  bool? get isNaN => value?.isNaN;

  /// Whether this number is positive infinity or negative infinity if not null.
  bool? get isInfinite => value?.isInfinite;

  /// Whether this number is finite if not null.
  bool? get isFinite => value?.isFinite;

  /// Returns this [num] clamped to be in the range [lowerLimit]-[upperLimit] if not null.
  Rx<num?> clamp(num lowerLimit, num upperLimit) =>
      value?.clamp(lowerLimit, upperLimit).obs ?? Rx<num?>(null);

  /// Converts this number to an integer if not null.
  /// Converts this number to a double if not null.
  Rx<double?> toDouble() => value?.toDouble().obs ?? Rx<double?>(null);
}

/// A reactive [num] value.
///
/// This class is a thin wrapper around [Rx<num>] for backward compatibility.
class RxNum extends Rx<num> {
  /// Creates a reactive [num] with the provided [initial] value.
  RxNum(super.initial);

  /// Creates a reactive [num] with an initial value of 0.
  RxNum.zero() : super(0);
}

/// A reactive nullable [num] value.
///
/// This class is a thin wrapper around [Rx<num?>] for backward compatibility.
class RxnNum extends Rx<num?> {
  /// Creates a reactive nullable [num] with the provided optional [initial] value.
  RxnNum([super.initial]);

  /// Creates a reactive nullable [num] with an initial value of null.
  RxnNum.nullValue() : super(null);
}

/// Extension for reactive double values.
extension RxDoubleExt on Rx<double> {
  /// Addition operator that updates the reactive value.
  Rx<double> operator +(num other) {
    value += other;
    return this;
  }

  /// Subtraction operator that updates the reactive value.
  Rx<double> operator -(num other) {
    value -= other;
    return this;
  }

  /// Multiplication operator that updates the reactive value.
  Rx<double> operator *(num other) {
    value *= other;
    return this;
  }

  /// Division operator that returns a new reactive double.
  Rx<double> operator /(num other) => (value / other).obs;

  /// Integer division operator that returns a new reactive int.
  Rx<int> operator ~/(num other) => (value ~/ other).obs;

  /// Returns the absolute value of this double.
  Rx<double> abs() => value.abs().obs;

  /// The sign of this double's value.
  ///
  /// Returns -1.0 if the value is less than zero,
  /// +1.0 if the value is greater than zero,
  /// and the value itself if it is -0.0, 0.0 or NaN.
  double get sign => value.sign;

  /// Whether this number is negative.
  bool get isNegative => value.isNegative;

  /// Whether this number is not a number (NaN).
  bool get isNaN => value.isNaN;

  /// Whether this number is positive infinity or negative infinity.
  bool get isInfinite => value.isInfinite;

  /// Whether this number is finite.
  bool get isFinite => value.isFinite;

  /// Rounds this number to the nearest integer.
  Rx<int> round() => value.round().obs;

  /// Returns the greatest integer no greater than this number.
  Rx<int> floor() => value.floor().obs;

  /// Returns the least integer no smaller than this number.
  Rx<int> ceil() => value.ceil().obs;

  /// Returns the integer obtained by discarding any fractional digits.
  Rx<int> truncate() => value.truncate().obs;

  /// Rounds this number to the nearest integer as a double.
  Rx<double> roundToDouble() => value.roundToDouble().obs;

  /// Returns the greatest integer no greater than this number as a double.
  Rx<double> floorToDouble() => value.floorToDouble().obs;

  /// Returns the least integer no smaller than this number as a double.
  Rx<double> ceilToDouble() => value.ceilToDouble().obs;

  /// Returns the integer obtained by discarding any fractional digits as a double.
  Rx<double> truncateToDouble() => value.truncateToDouble().obs;
}

/// Extension for reactive nullable double values.
extension RxnDoubleExt on Rx<double?> {
  /// Addition operator that updates the reactive value if not null.
  Rx<double?> operator +(num other) {
    if (value != null) {
      value = value! + other;
    }
    return this;
  }

  /// Subtraction operator that updates the reactive value if not null.
  Rx<double?> operator -(num other) {
    if (value != null) {
      value = value! - other;
    }
    return this;
  }

  /// Multiplication operator that updates the reactive value if not null.
  Rx<double?> operator *(num other) {
    if (value != null) {
      value = value! * other;
    }
    return this;
  }

  /// Division operator that returns a new reactive double if not null.
  Rx<double?> operator /(num other) {
    if (value != null) {
      return (value! / other).obs;
    }
    return Rx<double?>(null);
  }

  /// Integer division operator that returns a new reactive int if not null.
  Rx<int?> operator ~/(num other) {
    if (value != null) {
      return (value! ~/ other).obs;
    }
    return Rx<int?>(null);
  }

  /// Returns the absolute value of this double if not null.
  Rx<double?> abs() => value?.abs().obs ?? Rx<double?>(null);

  /// The sign of this double's value if not null.
  double? get sign => value?.sign;

  /// Whether this number is negative if not null.
  bool? get isNegative => value?.isNegative;

  /// Whether this number is not a number (NaN) if not null.
  bool? get isNaN => value?.isNaN;

  /// Whether this number is positive infinity or negative infinity if not null.
  bool? get isInfinite => value?.isInfinite;

  /// Whether this number is finite if not null.
  bool? get isFinite => value?.isFinite;

  /// Rounds this number to the nearest integer if not null.
  Rx<int?> round() => value?.round().obs ?? Rx<int?>(null);

  /// Returns the greatest integer no greater than this number if not null.
  Rx<int?> floor() => value?.floor().obs ?? Rx<int?>(null);

  /// Returns the least integer no smaller than this number if not null.
  Rx<int?> ceil() => value?.ceil().obs ?? Rx<int?>(null);

  /// Returns the integer obtained by discarding any fractional digits if not null.
  Rx<int?> truncate() => value?.truncate().obs ?? Rx<int?>(null);

  /// Rounds this number to the nearest integer as a double if not null.
  Rx<double?> roundToDouble() => value?.roundToDouble().obs ?? Rx<double?>(null);

  /// Returns the greatest integer no greater than this number as a double if not null.
  Rx<double?> floorToDouble() => value?.floorToDouble().obs ?? Rx<double?>(null);

  /// Returns the least integer no smaller than this number as a double if not null.
  Rx<double?> ceilToDouble() => value?.ceilToDouble().obs ?? Rx<double?>(null);

  /// Returns the integer obtained by discarding any fractional digits as a double if not null.
  Rx<double?> truncateToDouble() => value?.truncateToDouble().obs ?? Rx<double?>(null);
}

/// A reactive [double] value.
///
/// This class is a thin wrapper around [Rx<double>] for backward compatibility.
class RxDouble extends Rx<double> {
  /// Creates a reactive [double] with the provided [initial] value.
  RxDouble(super.initial);

  /// Creates a reactive [double] with an initial value of 0.0.
  RxDouble.zero() : super(0.0);
}

/// A reactive nullable [double] value.
///
/// This class is a thin wrapper around [Rx<double?>] for backward compatibility.
class RxnDouble extends Rx<double?> {
  /// Creates a reactive nullable [double] with the provided optional [initial] value.
  RxnDouble([super.initial]);

  /// Creates a reactive nullable [double] with an initial value of null.
  RxnDouble.nullValue() : super(null);
}

/// A reactive [int] value.
///
/// This class is a thin wrapper around [Rx<int>] for backward compatibility.
class RxInt extends Rx<int> {
  /// Creates a reactive [int] with the provided [initial] value.
  RxInt(super.initial);

  /// Creates a reactive [int] with an initial value of 0.
  RxInt.zero() : super(0);

  /// Increments the value by 1.
  void increment() => value++;

  /// Decrements the value by 1.
  void decrement() => value--;
}

/// A reactive nullable [int] value.
///
/// This class is a thin wrapper around [Rx<int?>] for backward compatibility.
class RxnInt extends Rx<int?> {
  /// Creates a reactive nullable [int] with the provided optional [initial] value.
  RxnInt([super.initial]);

  /// Creates a reactive nullable [int] with an initial value of null.
  RxnInt.nullValue() : super(null);

  /// Increments the value by 1 if not null.
  void increment() {
    if (value != null) value = value! + 1;
  }

  /// Decrements the value by 1 if not null.
  void decrement() {
    if (value != null) value = value! - 1;
  }
}

extension RxIntExt on Rx<int> {
  /// Bit-wise and operator.
  ///
  /// Treating both `this` and [other] as sufficiently large two's component
  /// integers, the result is a number with only the bits set that are set in
  /// both `this` and [other]
  ///
  /// If both operands are negative, the result is negative, otherwise
  /// the result is non-negative.
  int operator &(int other) => value & other;

  /// Bit-wise or operator.
  ///
  /// Treating both `this` and [other] as sufficiently large two's component
  /// integers, the result is a number with the bits set that are set in either
  /// of `this` and [other]
  ///
  /// If both operands are non-negative, the result is non-negative,
  /// otherwise the result is negative.
  int operator |(int other) => value | other;

  /// Bit-wise exclusive-or operator.
  ///
  /// Treating both `this` and [other] as sufficiently large two's component
  /// integers, the result is a number with the bits set that are set in one,
  /// but not both, of `this` and [other]
  ///
  /// If the operands have the same sign, the result is non-negative,
  /// otherwise the result is negative.
  int operator ^(int other) => value ^ other;

  /// The bit-wise negate operator.
  ///
  /// Treating `this` as a sufficiently large two's component integer,
  /// the result is a number with the opposite bits set.
  ///
  /// This maps any integer `x` to `-x - 1`.
  int operator ~() => ~value;

  /// Shift the bits of this integer to the left by [shiftAmount].
  ///
  /// Shifting to the left makes the number larger, effectively multiplying
  /// the number by `pow(2, shiftIndex)`.
  ///
  /// There is no limit on the size of the result. It may be relevant to
  /// limit intermediate values by using the "and" operator with a suitable
  /// mask.
  ///
  /// It is an error if [shiftAmount] is negative.
  int operator <<(int shiftAmount) => value << shiftAmount;

  /// Shift the bits of this integer to the right by [shiftAmount].
  ///
  /// Shifting to the right makes the number smaller and drops the least
  /// significant bits, effectively doing an integer division by
  ///`pow(2, shiftIndex)`.
  ///
  /// It is an error if [shiftAmount] is negative.
  int operator >>(int shiftAmount) => value >> shiftAmount;

  /// Returns this integer to the power of [exponent] modulo [modulus].
  ///
  /// The [exponent] must be non-negative and [modulus] must be
  /// positive.
  int modPow(int exponent, int modulus) => value.modPow(exponent, modulus);

  /// Returns the modular multiplicative inverse of this integer
  /// modulo [modulus].
  ///
  /// The [modulus] must be positive.
  ///
  /// It is an error if no modular inverse exists.
  int modInverse(int modulus) => value.modInverse(modulus);

  /// Returns the greatest common divisor of this integer and [other].
  ///
  /// If either number is non-zero, the result is the numerically greatest
  /// integer dividing both `this` and `other`.
  ///
  /// The greatest common divisor is independent of the order,
  /// so `x.gcd(y)` is  always the same as `y.gcd(x)`.
  ///
  /// For any integer `x`, `x.gcd(x)` is `x.abs()`.
  ///
  /// If both `this` and `other` is zero, the result is also zero.
  int gcd(int other) => value.gcd(other);

  /// Returns true if and only if this integer is even.
  bool get isEven => value.isEven;

  /// Returns true if and only if this integer is odd.
  bool get isOdd => value.isOdd;

  /// Returns the minimum number of bits required to store this integer.
  ///
  /// The number of bits excludes the sign bit, which gives the natural length
  /// for non-negative (unsigned) values.  Negative values are complemented to
  /// return the bit position of the first bit that differs from the sign bit.
  ///
  /// To find the number of bits needed to store the value as a signed value,
  /// add one, i.e. use `x.bitLength + 1`.
  /// ```
  /// x.bitLength == (-x-1).bitLength
  ///
  /// 3.bitLength == 2;     // 00000011
  /// 2.bitLength == 2;     // 00000010
  /// 1.bitLength == 1;     // 00000001
  /// 0.bitLength == 0;     // 00000000
  /// (-1).bitLength == 0;  // 11111111
  /// (-2).bitLength == 1;  // 11111110
  /// (-3).bitLength == 2;  // 11111101
  /// (-4).bitLength == 2;  // 11111100
  /// ```
  int get bitLength => value.bitLength;

  /// Returns the least significant [width] bits of this integer as a
  /// non-negative number (i.e. unsigned representation).  The returned value
  /// has zeros in all bit positions higher than [width].
  /// ```
  /// (-1).toUnsigned(5) == 31   // 11111111  ->  00011111
  /// ```
  /// This operation can be used to simulate arithmetic from low level
  /// languages.
  /// For example, to increment an 8 bit quantity:
  /// ```
  /// q = (q + 1).toUnsigned(8);
  /// ```
  /// `q` will count from `0` up to `255` and then wrap around to `0`.
  ///
  /// If the input fits in [width] bits without truncation, the result is the
  /// same as the input.  The minimum width needed to avoid truncation of `x` is
  /// given by `x.bitLength`, i.e.
  /// ```
  /// x == x.toUnsigned(x.bitLength);
  /// ```
  int toUnsigned(int width) => value.toUnsigned(width);

  /// Returns the least significant [width] bits of this integer, extending the
  /// highest retained bit to the sign.  This is the same as truncating the
  /// value to fit in [width] bits using an signed 2-s complement
  /// representation.
  /// The returned value has the same bit value in all positions higher than
  /// [width].
  ///
  /// ```
  ///                                V--sign bit-V
  /// 16.toSigned(5) == -16   //  00010000 -> 11110000
  /// 239.toSigned(5) == 15   //  11101111 -> 00001111
  ///                                ^           ^
  /// ```
  /// This operation can be used to simulate arithmetic from low level
  /// languages.
  /// For example, to increment an 8 bit signed quantity:
  /// ```
  /// q = (q + 1).toSigned(8);
  /// ```
  /// `q` will count from `0` up to `127`, wrap to `-128` and count back up to
  /// `127`.
  ///
  /// If the input value fits in [width] bits without truncation, the result is
  /// the same as the input.  The minimum width needed to avoid truncation
  /// of `x` is `x.bitLength + 1`, i.e.
  /// ```
  /// x == x.toSigned(x.bitLength + 1);
  /// ```
  int toSigned(int width) => value.toSigned(width);

  /// Return the negative value of this integer.
  ///
  /// The result of negating an integer always has the opposite sign, except
  /// for zero, which is its own negation.
  int operator -() => -value;

  /// Returns the absolute value of this integer.
  ///
  /// For any integer `x`, the result is the same as `x < 0 ? -x : x`.
  int abs() => value.abs();

  /// Returns the sign of this integer.
  ///
  /// Returns 0 for zero, -1 for values less than zero and
  /// +1 for values greater than zero.
  int get sign => value.sign;

  /// Returns `this`.
  int round() => value.round();

  /// Returns `this`.
  int floor() => value.floor();

  /// Returns `this`.
  int ceil() => value.ceil();

  /// Returns `this`.
  int truncate() => value.truncate();

  /// Returns `this.toDouble()`.
  double roundToDouble() => value.roundToDouble();

  /// Returns `this.toDouble()`.
  double floorToDouble() => value.floorToDouble();

  /// Returns `this.toDouble()`.
  double ceilToDouble() => value.ceilToDouble();

  /// Returns `this.toDouble()`.
  double truncateToDouble() => value.truncateToDouble();
}

extension RxnIntExt on Rx<int?> {
  /// Bit-wise and operator.
  ///
  /// Treating both `this` and [other] as sufficiently large two's component
  /// integers, the result is a number with only the bits set that are set in
  /// both `this` and [other]
  ///
  /// If both operands are negative, the result is negative, otherwise
  /// the result is non-negative.
  int? operator &(int other) {
    if (value != null) {
      return value! & other;
    }
    return null;
  }

  /// Bit-wise or operator.
  ///
  /// Treating both `this` and [other] as sufficiently large two's component
  /// integers, the result is a number with the bits set that are set in either
  /// of `this` and [other]
  ///
  /// If both operands are non-negative, the result is non-negative,
  /// otherwise the result is negative.
  int? operator |(int other) {
    if (value != null) {
      return value! | other;
    }
    return null;
  }

  /// Bit-wise exclusive-or operator.
  ///
  /// Treating both `this` and [other] as sufficiently large two's component
  /// integers, the result is a number with the bits set that are set in one,
  /// but not both, of `this` and [other]
  ///
  /// If the operands have the same sign, the result is non-negative,
  /// otherwise the result is negative.
  int? operator ^(int other) {
    if (value != null) {
      return value! ^ other;
    }
    return null;
  }

  /// The bit-wise negate operator.
  ///
  /// Treating `this` as a sufficiently large two's component integer,
  /// the result is a number with the opposite bits set.
  ///
  /// This maps any integer `x` to `-x - 1`.
  int? operator ~() {
    if (value != null) {
      return ~value!;
    }
    return null;
  }

  /// Shift the bits of this integer to the left by [shiftAmount].
  ///
  /// Shifting to the left makes the number larger, effectively multiplying
  /// the number by `pow(2, shiftIndex)`.
  ///
  /// There is no limit on the size of the result. It may be relevant to
  /// limit intermediate values by using the "and" operator with a suitable
  /// mask.
  ///
  /// It is an error if [shiftAmount] is negative.
  int? operator <<(int shiftAmount) {
    if (value != null) {
      return value! << shiftAmount;
    }
    return null;
  }

  /// Shift the bits of this integer to the right by [shiftAmount].
  ///
  /// Shifting to the right makes the number smaller and drops the least
  /// significant bits, effectively doing an integer division by
  ///`pow(2, shiftIndex)`.
  ///
  /// It is an error if [shiftAmount] is negative.
  int? operator >>(int shiftAmount) {
    if (value != null) {
      return value! >> shiftAmount;
    }
    return null;
  }

  /// Returns this integer to the power of [exponent] modulo [modulus].
  ///
  /// The [exponent] must be non-negative and [modulus] must be
  /// positive.
  int? modPow(int exponent, int modulus) => value?.modPow(exponent, modulus);

  /// Returns the modular multiplicative inverse of this integer
  /// modulo [modulus].
  ///
  /// The [modulus] must be positive.
  ///
  /// It is an error if no modular inverse exists.
  int? modInverse(int modulus) => value?.modInverse(modulus);

  /// Returns the greatest common divisor of this integer and [other].
  ///
  /// If either number is non-zero, the result is the numerically greatest
  /// integer dividing both `this` and `other`.
  ///
  /// The greatest common divisor is independent of the order,
  /// so `x.gcd(y)` is  always the same as `y.gcd(x)`.
  ///
  /// For any integer `x`, `x.gcd(x)` is `x.abs()`.
  ///
  /// If both `this` and `other` is zero, the result is also zero.
  int? gcd(int other) => value?.gcd(other);

  /// Returns true if and only if this integer is even.
  bool? get isEven => value?.isEven;

  /// Returns true if and only if this integer is odd.
  bool? get isOdd => value?.isOdd;

  /// Returns the minimum number of bits required to store this integer.
  ///
  /// The number of bits excludes the sign bit, which gives the natural length
  /// for non-negative (unsigned) values.  Negative values are complemented to
  /// return the bit position of the first bit that differs from the sign bit.
  ///
  /// To find the number of bits needed to store the value as a signed value,
  /// add one, i.e. use `x.bitLength + 1`.
  /// ```
  /// x.bitLength == (-x-1).bitLength
  ///
  /// 3.bitLength == 2;     // 00000011
  /// 2.bitLength == 2;     // 00000010
  /// 1.bitLength == 1;     // 00000001
  /// 0.bitLength == 0;     // 00000000
  /// (-1).bitLength == 0;  // 11111111
  /// (-2).bitLength == 1;  // 11111110
  /// (-3).bitLength == 2;  // 11111101
  /// (-4).bitLength == 2;  // 11111100
  /// ```
  int? get bitLength => value?.bitLength;

  /// Returns the least significant [width] bits of this integer as a
  /// non-negative number (i.e. unsigned representation).  The returned value
  /// has zeros in all bit positions higher than [width].
  /// ```
  /// (-1).toUnsigned(5) == 31   // 11111111  ->  00011111
  /// ```
  /// This operation can be used to simulate arithmetic from low level
  /// languages.
  /// For example, to increment an 8 bit quantity:
  /// ```
  /// q = (q + 1).toUnsigned(8);
  /// ```
  /// `q` will count from `0` up to `255` and then wrap around to `0`.
  ///
  /// If the input fits in [width] bits without truncation, the result is the
  /// same as the input.  The minimum width needed to avoid truncation of `x` is
  /// given by `x.bitLength`, i.e.
  /// ```
  /// x == x.toUnsigned(x.bitLength);
  /// ```
  int? toUnsigned(int width) => value?.toUnsigned(width);

  /// Returns the least significant [width] bits of this integer, extending the
  /// highest retained bit to the sign.  This is the same as truncating the
  /// value to fit in [width] bits using an signed 2-s complement
  /// representation.
  /// The returned value has the same bit value in all positions higher than
  /// [width].
  ///
  /// ```
  ///                                V--sign bit-V
  /// 16.toSigned(5) == -16   //  00010000 -> 11110000
  /// 239.toSigned(5) == 15   //  11101111 -> 00001111
  ///                                ^           ^
  /// ```
  /// This operation can be used to simulate arithmetic from low level
  /// languages.
  /// For example, to increment an 8 bit signed quantity:
  /// ```
  /// q = (q + 1).toSigned(8);
  /// ```
  /// `q` will count from `0` up to `127`, wrap to `-128` and count back up to
  /// `127`.
  ///
  /// If the input value fits in [width] bits without truncation, the result is
  /// the same as the input.  The minimum width needed to avoid truncation
  /// of `x` is `x.bitLength + 1`, i.e.
  /// ```
  /// x == x.toSigned(x.bitLength + 1);
  /// ```
  int? toSigned(int width) => value?.toSigned(width);

  /// Return the negative value of this integer.
  ///
  /// The result of negating an integer always has the opposite sign, except
  /// for zero, which is its own negation.
  int? operator -() {
    if (value != null) {
      return -value!;
    }
    return null;
  }

  /// Returns the absolute value of this integer.
  ///
  /// For any integer `x`, the result is the same as `x < 0 ? -x : x`.
  int? abs() => value?.abs();

  /// Returns the sign of this integer.
  ///
  /// Returns 0 for zero, -1 for values less than zero and
  /// +1 for values greater than zero.
  int? get sign => value?.sign;

  /// Returns `this`.
  int? round() => value?.round();

  /// Returns `this`.
  int? floor() => value?.floor();

  /// Returns `this`.
  int? ceil() => value?.ceil();

  /// Returns `this`.
  int? truncate() => value?.truncate();

  /// Returns `this.toDouble()`.
  double? roundToDouble() => value?.roundToDouble();

  /// Returns `this.toDouble()`.
  double? floorToDouble() => value?.floorToDouble();

  /// Returns `this.toDouble()`.
  double? ceilToDouble() => value?.ceilToDouble();

  /// Returns `this.toDouble()`.
  double? truncateToDouble() => value?.truncateToDouble();
}
