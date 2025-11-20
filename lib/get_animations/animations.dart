import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/widgets.dart';

import 'get_animated_builder.dart';

/// Signature for building an [Offset] based on the animation value.
typedef OffsetBuilder = Offset Function(BuildContext context, double value);

/// A fade-in animation that transitions a widget's opacity from 0 to 1.
class FadeInAnimation extends OpacityAnimation {
  /// Creates a fade-in animation.
  FadeInAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    super.begin = 0,
    super.end = 1,
    super.idleValue = 0,
  });
}

/// A fade-out animation that transitions a widget's opacity from 1 to 0.
class FadeOutAnimation extends OpacityAnimation {
  /// Creates a fade-out animation.
  FadeOutAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    super.begin = 1,
    super.end = 0,
    super.idleValue = 1,
  });
}

/// A base class for opacity-based animations.
class OpacityAnimation extends GetAnimatedBuilder<double> {
  /// Creates an opacity animation.
  OpacityAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    required super.onComplete,
    required double begin,
    required double end,
    required super.idleValue,
  }) : super(
          tween: Tween<double>(begin: begin, end: end),
          builder: (BuildContext context, double value, Widget? child) {
            assert(child != null, 'Child widget must not be null');
            return Opacity(
              opacity: value,
              child: child!,
            );
          },
        );
}

/// A rotation animation that rotates a widget around its center.
class RotateAnimation extends GetAnimatedBuilder<double> {
  /// Creates a rotation animation.
  RotateAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required double begin,
    required double end,
    super.idleValue = 0,
  }) : super(
          builder: (BuildContext context, double value, Widget? child) => 
              Transform.rotate(
                angle: 2 * math.pi * value,
                child: child,
              ),
          tween: Tween<double>(begin: begin, end: end),
        );
}

/// A scale animation that changes the size of a widget.
class ScaleAnimation extends GetAnimatedBuilder<double> {
  /// Creates a scale animation.
  ScaleAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required double begin,
    required double end,
    super.idleValue = 0,
  }) : super(
          builder: (BuildContext context, double value, Widget? child) => 
              Transform.scale(
                scale: value,
                child: child,
              ),
          tween: Tween<double>(begin: begin, end: end),
        );
}

// class SlideAnimation extends GetAnimatedBuilder<Offset> {
//   SlideAnimation({
//     super.key,
//     required super.duration,
//     required super.delay,
//     required super.child,
//     super.onComplete,
//     required Offset begin,
//     required Offset end,
//     super.idleValue = const Offset(0, 0),
//   }) : super(
//           builder: (context, value, child) => Transform.translate(
//             offset: value,
//             child: child,
//           ),
//           tween: Tween(begin: begin, end: end),
//         );
// }

class BounceAnimation extends GetAnimatedBuilder<double> {
  BounceAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    super.curve = Curves.bounceOut,
    required double begin,
    required double end,
    super.idleValue = 0,
  }) : super(
          builder: (context, value, child) => Transform.scale(
            scale: 1 + value.abs(),
            child: child,
          ),
          tween: Tween<double>(begin: begin, end: end),
        );
}

class SpinAnimation extends GetAnimatedBuilder<double> {
  SpinAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    super.idleValue = 0,
  }) : super(
          builder: (context, value, child) => Transform.rotate(
            angle: value * math.pi / 180.0,
            child: child,
          ),
          tween: Tween<double>(begin: 0, end: 360),
        );
}

class SizeAnimation extends GetAnimatedBuilder<double> {
  SizeAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    super.idleValue = 0,
    required double begin,
    required double end,
  }) : super(
          builder: (context, value, child) => Transform.scale(
            scale: value,
            child: child,
          ),
          tween: Tween<double>(begin: begin, end: end),
        );
}

class BlurAnimation extends GetAnimatedBuilder<double> {
  BlurAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required double begin,
    required double end,
    super.idleValue = 0,
  }) : super(
          builder: (context, value, child) => BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: value,
              sigmaY: value,
            ),
            child: child,
          ),
          tween: Tween<double>(begin: begin, end: end),
        );
}

class FlipAnimation extends GetAnimatedBuilder<double> {
  FlipAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required double begin,
    required double end,
    super.idleValue = 0,
  }) : super(
          builder: (context, value, child) {
            final radians = value * math.pi;
            return Transform(
              transform: Matrix4.rotationY(radians),
              alignment: Alignment.center,
              child: child,
            );
          },
          tween: Tween<double>(begin: begin, end: end),
        );
}

class WaveAnimation extends GetAnimatedBuilder<double> {
  WaveAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required double begin,
    required double end,
    super.idleValue = 0,
  }) : super(
          builder: (context, value, child) => Transform(
            transform: Matrix4.translationValues(
              0.0,
              20.0 * math.sin(value * math.pi * 2),
              0.0,
            ),
            child: child,
          ),
          tween: Tween<double>(begin: begin, end: end),
        );
}

class WobbleAnimation extends GetAnimatedBuilder<double> {
  WobbleAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required double begin,
    required double end,
    super.idleValue = 0,
  }) : super(
          builder: (context, value, child) => Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateZ(math.sin(value * math.pi * 2) * 0.1),
            alignment: Alignment.center,
            child: child,
          ),
          tween: Tween<double>(begin: begin, end: end),
        );
}

class SlideInLeftAnimation extends SlideAnimation {
  SlideInLeftAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required super.begin,
    required super.end,
    super.idleValue = 0,
  }) : super(
          offsetBuild: (context, value) =>
              Offset(value * MediaQuery.of(context).size.width, 0),
        );
}

class SlideInRightAnimation extends SlideAnimation {
  SlideInRightAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required super.begin,
    required super.end,
    super.idleValue = 0,
  }) : super(
          offsetBuild: (context, value) =>
              Offset((1 - value) * MediaQuery.of(context).size.width, 0),
        );
}

class SlideInUpAnimation extends SlideAnimation {
  SlideInUpAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required super.begin,
    required super.end,
    super.idleValue = 0,
  }) : super(
          offsetBuild: (context, value) =>
              Offset(0, value * MediaQuery.of(context).size.height),
        );
}

class SlideInDownAnimation extends SlideAnimation {
  SlideInDownAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required super.begin,
    required super.end,
    super.idleValue = 0,
  }) : super(
          offsetBuild: (context, value) =>
              Offset(0, (1 - value) * MediaQuery.of(context).size.height),
        );
}

class SlideAnimation extends GetAnimatedBuilder<double> {
  SlideAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    required double begin,
    required double end,
    required OffsetBuilder offsetBuild,
    super.onComplete,
    super.idleValue = 0,
  }) : super(
          builder: (context, value, child) => Transform.translate(
            offset: offsetBuild(context, value),
            child: child,
          ),
          tween: Tween<double>(begin: begin, end: end),
        );
}

// class ZoomAnimation extends GetAnimatedBuilder<double> {
//   ZoomAnimation({
//     super.key,
//     required super.duration,
//     required super.delay,
//     required super.child,
//     super.onComplete,
//     required double begin,
//     required double end,
//     super.idleValue = 0,
//   }) : super(
//           builder: (context, value, child) => Transform.scale(
//             scale: lerpDouble(1, end, value)!,
//             child: child,
//           ),
//           tween: Tween<double>(begin: begin, end: end),
//         );
// }

class ColorAnimation extends GetAnimatedBuilder<Color?> {
  ColorAnimation({
    super.key,
    required super.duration,
    required super.delay,
    required super.child,
    super.onComplete,
    required Color begin,
    required Color end,
    Color? idleColor,
  }) : super(
          builder: (context, value, child) => ColorFiltered(
            colorFilter: ColorFilter.mode(
              Color.lerp(begin, end, value!.a.toDouble())!,
              BlendMode.srcIn,
            ),
            child: child,
          ),
          idleValue: idleColor ?? begin,
          tween: ColorTween(begin: begin, end: end),
        );
}
