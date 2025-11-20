import 'package:flutter/material.dart';

import 'animations.dart';

/// A widget that animates its properties over a period of time.
///
/// The [onComplete] and [onStart] callbacks are optional and will be called
/// when the animation completes or starts respectively.
class GetAnimatedBuilder<T> extends StatefulWidget {
  /// The duration of the animation.
  final Duration duration;
  
  /// The delay before the animation starts.
  final Duration delay;
  
  /// The child widget to animate.
  final Widget child;
  
  /// Optional callback called when the animation completes.
  final ValueSetter<AnimationController>? onComplete;
  
  /// Optional callback called when the animation starts.
  final ValueSetter<AnimationController>? onStart;
  
  /// The tween that defines the range of the animation.
  final Tween<T> tween;
  
  /// The initial value of the animation before it starts.
  final T idleValue;
  
  /// The builder that builds the widget tree based on the current animation value.
  final ValueWidgetBuilder<T> builder;
  
  /// The curve of the animation.
  final Curve curve;

  /// The total duration including the delay.
  Duration get totalDuration => duration + delay;

  /// Creates an animated builder.
  const GetAnimatedBuilder({
    super.key,
    this.curve = Curves.linear,
    this.onComplete,
    this.onStart,
    required this.duration,
    required this.tween,
    required this.idleValue,
    required this.builder,
    required this.child,
    required this.delay,
  })  : assert(duration > Duration.zero, 'Duration must be greater than zero'),
       assert(delay >= Duration.zero, 'Delay cannot be negative');
  @override
  GetAnimatedBuilderState<T> createState() => GetAnimatedBuilderState<T>();
}

class GetAnimatedBuilderState<T> extends State<GetAnimatedBuilder<T>>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<T> _animation;
  bool _wasStarted = false;
  T? _idleValue;
  bool _willResetOnDispose = false;

  /// The current idle value, falls back to widget's idleValue if null.
  T get _safeIdleValue => _idleValue ?? widget.idleValue;

  /// Whether the animation will reset when disposed.
  bool get willResetOnDispose => _willResetOnDispose;

  void _listener(AnimationStatus status) => switch (status) {
        AnimationStatus.completed => _handleCompleted(),
        AnimationStatus.forward => widget.onStart?.call(_controller),
        AnimationStatus.dismissed || AnimationStatus.reverse => null,
      };

  void _handleCompleted() {
    widget.onComplete?.call(_controller);
    if (_willResetOnDispose) {
      _controller.reset();
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget is OpacityAnimation) {
      final current = context.findRootAncestorStateOfType<GetAnimatedBuilderState>();
      final isLast = current == null;

      if (widget is FadeInAnimation) {
        _idleValue = (T == double ? 1.0 : widget.idleValue) as T;
      } else {
        _willResetOnDispose = !isLast;
        _idleValue = widget.idleValue;
      }
    } else {
      _idleValue = widget.idleValue;
    }

    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _controller.addStatusListener(_listener);

    _animation = widget.tween.animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    Future.delayed(widget.delay, () {
      if (!mounted) return;
      setState(() {
        _wasStarted = true;
        _controller.forward();
      });
    });
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_listener)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          assert(child != null, 'Child widget must not be null');
          final value = _wasStarted ? _animation.value : _safeIdleValue;
          return widget.builder(context, value, child!);
        },
        child: widget.child,
      );
}
