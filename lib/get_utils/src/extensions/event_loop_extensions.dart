import 'dart:async';

import '../../../get_core/src/get_interface.dart';

/// Extension on [GetInterface] to provide event loop utilities.
extension LoopEventsExt on GetInterface {
  /// Schedules the [computation] to run at the end of the current event loop tick.
  ///
  /// This is useful when you want to ensure that the current synchronous
  /// execution completes before running the computation.
  ///
  /// Example:
  /// ```dart
  /// Get.toEnd(() => someComputation());
  /// ```
  Future<T> toEnd<T>(FutureOr<T> Function() computation) async {
    await Future<void>.delayed(Duration.zero);
    return computation();
  }

  /// Runs the [computation] as soon as possible, either immediately or
  /// after the current event loop tick if [condition] is not met.
  ///
  /// If [condition] is provided and returns `true`, the computation runs
  /// immediately. Otherwise, it runs after the current event loop tick.
  ///
  /// Example:
  /// ```dart
  /// Get.asap(
  ///   () => someComputation(),
  ///   condition: () => someCondition,
  /// );
  /// ```
  FutureOr<T> asap<T>(
    T Function() computation, {
    bool Function()? condition,
  }) async {
    final shouldDelay = condition?.call() != true;
    if (shouldDelay) {
      await Future<void>.delayed(Duration.zero);
    }
    return computation();
  }
}
