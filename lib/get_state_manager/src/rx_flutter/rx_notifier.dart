import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../get_rx/src/rx_types/rx_types.dart';
import '../../../instance_manager.dart';
import '../../get_state_manager.dart';
import '../simple/list_notifier.dart';

extension _Empty on Object {
  bool _isEmpty() {
    final val = this;
    // if (val == null) return true;
    var result = false;
    if (val is Iterable) {
      result = val.isEmpty;
    } else if (val is String) {
      result = val.trim().isEmpty;
    } else if (val is Map) {
      result = val.isEmpty;
    }
    return result;
  }
}

mixin StateMixin<T> on ListNotifier {
  T? _value;
  GetStatus<T> _status = GetStatus.loading();

  void _fillInitialStatus() {
    _status = (_value == null || _value!._isEmpty())
        ? GetStatus<T>.loading()
        : GetStatus<T>.success(_value as T);
  }

  GetStatus<T> get status {
    reportRead();
    return _status;
  }

  T get state => value;

  set status(GetStatus<T> newStatus) {
    if (newStatus == status) return;
    _status = newStatus;
    if (newStatus is SuccessStatus<T>) {
      _value = newStatus.data;
    }
    refresh();
  }

  @protected
  T get value {
    reportRead();
    final value = _value;
    if (value == null) {
      throw StateError('Value not initialized. Call setSuccess() first.');
    }
    return value;
  }

  @protected
  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    refresh();
  }

  @protected
  void change(GetStatus<T> status) {
    if (status != this.status) {
      this.status = status;
    }
  }

  void setSuccess(T data) {
    change(GetStatus<T>.success(data));
  }

  void setError(Object error) {
    change(GetStatus<T>.error(error));
  }

  void setLoading() {
    change(GetStatus<T>.loading());
  }

  void setEmpty() {
    change(GetStatus<T>.empty());
  }

  Future<void> futurize(
    Future<T> Function() body, {
    T? initialData,
    String? errorMessage,
    bool useEmpty = true,
  }) async {
    _value ??= initialData;
    status = GetStatus<T>.loading();

    try {
      final newValue = await body();
      if ((newValue == null || newValue._isEmpty()) && useEmpty) {
        status = GetStatus<T>.empty();
      } else {
        status = GetStatus<T>.success(newValue);
      }
    } catch (err) {
      final error = err is Exception ? err : Exception(errorMessage ?? err.toString());
      status = GetStatus<T>.error(error);
    }
  }
}

typedef FuturizeCallback<T> = Future<T> Function(VoidCallback fn);

typedef VoidCallback = void Function();

class GetListenable<T> extends ListNotifierSingle implements RxInterface<T> {
  GetListenable(T val) : _value = val;

  StreamController<T>? _controller;

  StreamController<T> get subject {
    if (_controller == null) {
      _controller =
          StreamController<T>.broadcast(onCancel: addListener(_streamListener));
      _controller?.add(_value);
    }
    return _controller!;
  }

  void _streamListener() {
    _controller?.add(_value);
  }

  @override
  @mustCallSuper
  void close() {
    removeListener(_streamListener);
    _controller?.close();
    dispose();
  }

  Stream<T> get stream {
    return subject.stream;
  }

  T _value;

  @override
  T get value {
    reportRead();
    return _value;
  }

  void _notify() {
    refresh();
  }

  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    _notify();
  }

  T? call([T? v]) {
    if (v != null) {
      value = v;
    }
    return value;
  }

  @override
  StreamSubscription<T> listen(
    void Function(T)? onData, {
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) =>
      stream.listen(
        onData,
        onError: onError,
        onDone: onDone,
        cancelOnError: cancelOnError ?? false,
      );

  @override
  String toString() => value.toString();
}

class Value<T> extends ListNotifier
    with StateMixin<T>
    implements ValueListenable<T?> {
  Value(T val) {
    _value = val;
    _fillInitialStatus();
  }

  @override
  T get value {
    reportRead();
    return _value as T;
  }

  @override
  set value(T newValue) {
    if (_value == newValue) return;
    _value = newValue;
    refresh();
  }

  T? call([T? v]) {
    if (v != null) {
      value = v;
    }
    return value;
  }

  void update(T Function(T? value) fn) {
    value = fn(value);
    // refresh();
  }

  @override
  String toString() => value.toString();

  dynamic toJson() => (value as dynamic)?.toJson();
}

/// GetNotifier has a native status and state implementation, with the
/// Get Lifecycle
abstract class GetNotifier<T> extends Value<T> with GetLifeCycleMixin {
  GetNotifier(super.initial);
}

extension StateExt<T> on StateMixin<T> {
  Widget obx(
    NotifierBuilder<T> widget, {
    Widget Function(String? error)? onError,
    Widget? onLoading,
    Widget? onEmpty,
    WidgetBuilder? onCustom,
  }) {
    return Observer(builder: (context) {
      return status.when(
        loading: () =>
            onLoading ?? const Center(child: CircularProgressIndicator()),
        success: (data) => widget(data),
        error: (error) =>
            onError?.call(error.toString()) ??
            Center(child: Text('An error occurred: $error')),
        empty: () => onEmpty ?? const SizedBox.shrink(),
        custom: onCustom != null ? () => onCustom(context) : null,
      );
    });
  }
}

typedef NotifierBuilder<T> = Widget Function(T state);

sealed class GetStatus<T> {
  const GetStatus();

  factory GetStatus.loading() => LoadingStatus<T>();

  factory GetStatus.error(Object message) => ErrorStatus<T, Object>(message);

  factory GetStatus.empty() => EmptyStatus<T>();

  factory GetStatus.success(T data) => SuccessStatus<T>(data);

  factory GetStatus.custom() => CustomStatus<T>();
}

class CustomStatus<T> extends GetStatus<T> {
  const CustomStatus();
}

class LoadingStatus<T> extends GetStatus<T> {
  const LoadingStatus();
}

class SuccessStatus<T> extends GetStatus<T> {
  final T data;
  const SuccessStatus(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is SuccessStatus<T> && other.data == data;

  @override
  int get hashCode => data.hashCode;
}

class ErrorStatus<T, S> extends GetStatus<T> {
  final S? error;

  const ErrorStatus([this.error]);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ErrorStatus<T, S> && other.error == error;

  @override
  int get hashCode => error.hashCode;
  
  @override
  String toString() => 'ErrorStatus($error)';
}

class EmptyStatus<T> extends GetStatus<T> {
  const EmptyStatus();
}

extension StatusDataExt<T> on GetStatus<T> {
  bool get isLoading => this is LoadingStatus;

  bool get isSuccess => this is SuccessStatus;

  bool get isError => this is ErrorStatus;

  bool get isEmpty => this is EmptyStatus;

  bool get isCustom => !isLoading && !isSuccess && !isError && !isEmpty;

  Object? get error {
    if (this case ErrorStatus(error: final error?)) {
      return error is Exception ? error : Exception(error.toString());
    }
    return null;
  }

  String get errorMessage {
    final isError = this is ErrorStatus;
    if (isError) {
      final err = this as ErrorStatus;
      if (err.error != null) {
        if (err.error is String) {
          return err.error as String;
        }
        return err.error.toString();
      }
    }

    return '';
  }

  T? get data {
    if (this is SuccessStatus<T>) {
      final success = this as SuccessStatus<T>;
      return success.data;
    }
    return null;
  }
}

/// Pattern matching for [GetStatus] states.
///
/// Example:
/// ```dart
/// final result = status.when(
///   loading: () => 'Loading...',
///   success: (data) => 'Data: $data',
///   error: (error) => 'Error: $error',
///   empty: () => 'No data',
///   custom: () => 'Custom state',
/// );
/// ```
extension StatusExtensions<T> on GetStatus<T> {
  R when<R>({
    required R Function() loading,
    required R Function(T data) success,
    required R Function(Object error) error,
    required R Function() empty,
    R Function()? custom,
  }) {
    return switch (this) {
      LoadingStatus() => loading(),
      SuccessStatus(data: final data) => success(data),
      ErrorStatus(error: final e) =>
        error(e is Exception ? e : Exception(e.toString())),
      EmptyStatus() => empty(),
      CustomStatus() => custom?.call() ?? empty(),
      _ => throw StateError('Unknown status type: $this'),
    };
  }
}
