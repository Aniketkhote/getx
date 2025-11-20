import '../get_utils/get_utils.dart';

/// Extension methods for dynamic types to provide additional utility methods.
extension GetDynamicUtils on dynamic {
  /// Returns true if the value is null or an empty string.
  bool? get isBlank => GetUtils.isBlank(this);

  /// Prints an error message with optional information.
  ///
  /// [info] - Additional information to include in the log.
  /// [logFunction] - Custom logging function to use (defaults to [GetUtils.printFunction]).
  void printError({
    String info = '',
    void Function(String, dynamic, String, {bool isError})? logFunction,
  }) {
    (logFunction ?? GetUtils.printFunction)(
      'Error: $runtimeType',
      this,
      info,
      isError: true,
    );
  }

  /// Prints an informational message with optional information.
  ///
  /// [info] - Additional information to include in the log.
  /// [printFunction] - Custom printing function to use (defaults to [GetUtils.printFunction]).
  void printInfo({
    String info = '',
    void Function(String, dynamic, String, {bool isError})? printFunction,
  }) {
    (printFunction ?? GetUtils.printFunction)(
      'Info: $runtimeType',
      this,
      info,
      isError: false,
    );
  }
}
