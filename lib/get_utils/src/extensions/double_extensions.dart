import 'dart:math' show pow;

/// Extension methods for [double] to provide additional functionality.
extension DoubleExt on double {
  /// Rounds this double to the specified number of decimal places.
  ///
  /// Example:
  /// ```dart
  /// final d = 12.3456;
  /// print(d.toPrecision(2)); // 12.35
  /// ```
  double toPrecision(int fractionDigits) {
    assert(fractionDigits >= 0, 'Fraction digits must be non-negative');
    final mod = pow(10, fractionDigits).toDouble();
    return (this * mod).roundToDouble() / mod;
  }

  /// Returns a [Duration] representing this number of milliseconds.
  Duration get milliseconds => Duration(microseconds: (this * 1000).round());

  /// Alias for [milliseconds].
  Duration get ms => milliseconds;

  /// Returns a [Duration] representing this number of seconds.
  Duration get seconds => Duration(milliseconds: (this * 1000).round());

  /// Returns a [Duration] representing this number of minutes.
  Duration get minutes => Duration(
        seconds: (this * Duration.secondsPerMinute).round(),
      );

  /// Returns a [Duration] representing this number of hours.
  Duration get hours => Duration(
        minutes: (this * Duration.minutesPerHour).round(),
      );

  /// Returns a [Duration] representing this number of days.
  Duration get days => Duration(
        hours: (this * Duration.hoursPerDay).round(),
      );
}
