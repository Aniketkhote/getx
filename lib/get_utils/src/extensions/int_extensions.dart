/// Extension on [int] to provide convenient duration conversions.
///
/// This extension allows for more readable duration creation from integer values.
/// It's particularly useful when working with time-based operations.
///
/// Example:
/// ```dart
/// final duration = 5.seconds + 100.milliseconds;
/// await Future.delayed(1.seconds);
/// ```
extension DurationExt on int {
  /// Returns a [Duration] representing this number of seconds.
  ///
  /// Example:
  /// ```dart
  /// final duration = 5.seconds; // Duration(seconds: 5)
  /// ```
  Duration get seconds => Duration(seconds: this);

  /// Returns a [Duration] representing this number of days.
  ///
  /// Example:
  /// ```dart
  /// final duration = 2.days; // Duration(days: 2)
  /// ```
  Duration get days => Duration(days: this);

  /// Returns a [Duration] representing this number of hours.
  ///
  /// Example:
  /// ```dart
  /// final duration = 3.hours; // Duration(hours: 3)
  /// ```
  Duration get hours => Duration(hours: this);

  /// Returns a [Duration] representing this number of minutes.
  ///
  /// Example:
  /// ```dart
  /// final duration = 30.minutes; // Duration(minutes: 30)
  /// ```
  Duration get minutes => Duration(minutes: this);

  /// Returns a [Duration] representing this number of milliseconds.
  ///
  /// Example:
  /// ```dart
  /// final duration = 500.milliseconds; // Duration(milliseconds: 500)
  /// ```
  Duration get milliseconds => Duration(milliseconds: this);

  /// Returns a [Duration] representing this number of microseconds.
  ///
  /// Example:
  /// ```dart
  /// final duration = 1000.microseconds; // Duration(microseconds: 1000)
  /// ```
  Duration get microseconds => Duration(microseconds: this);

  /// Alias for [milliseconds].
  ///
  /// Example:
  /// ```dart
  /// final duration = 500.ms; // Same as 500.milliseconds
  /// ```
  Duration get ms => milliseconds;
}
