import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:gyro_provider/models/vector_model.dart';
import 'package:gyro_provider/controller/gyroscope_controller.dart';
import 'package:gyro_provider/controller/rotation_controller.dart';

/// [_GyroWidgetMode] is an enum for specifying the mode of the [GyroProvider] widget.
enum _GyroWidgetMode {
  provide,
  skew,
  // parallel, // Scalable to multiple modes, such as parallel.
}

class GyroProvider extends StatefulWidget {
  final _GyroWidgetMode _mode;

  /// ## [GyroProvider]
  /// [GyroProvider] provides the values of the device's gyroscope sensor
  /// and position sensors (rotation only, without geomagnetic).
  ///
  /// ---
  ///
  /// - [gyroscope] \
  ///   Callback function, which is returns the gyroscope value of the device.
  ///
  /// - [rotation] \
  ///   Callback function, which is returns the rotation value of the device.
  ///
  /// - [builder] \
  ///   Builder function, which provides a BuildContext, a gyroscope value,
  ///   and a rotation value.
  const GyroProvider({
    super.key,
    this.gyroscope,
    this.rotation,
    this.builder,
  })  : _mode = _GyroWidgetMode.provide,
        child = null,
        horizontalLock = false,
        verticalLock = false,
        centerLock = false,
        resetTime = const Duration(seconds: 1),
        sensitivity = 0.002,
        shift = 10.0,
        animationDuration = const Duration(milliseconds: 500),
        reverse = false;

  /// Callback function, which is returns the gyroscope value of the device.
  ///
  /// ---
  ///
  /// ### Example
  /// ```dart
  /// GyroProvider(
  ///   gyroscope: (vector) {
  ///     // using vector
  ///   }
  /// )
  /// ```
  final Function(VectorModel vector)? gyroscope;

  /// Callback function, which is returns the rotation value of the device. \
  /// (without geomagnetic)
  ///
  /// ---
  ///
  /// ### Example
  /// ```dart
  /// GyroProvider(
  ///   rotation: (vector) {
  ///     // using vector
  ///   }
  /// )
  /// ```
  final Function(VectorModel vector)? rotation;

  /// Builder function, which provides a BuildContext, a gyroscope value,
  /// and a rotation value.
  ///
  /// ---
  ///
  /// ### Example
  /// ```dart
  /// GyroProvider(
  ///   builder: (context, gyroscope, rotation) => Column(
  ///     children: [
  ///       const Text('gyroscope'),
  ///       Text(gyroscope.x.toString()),
  ///       Text(gyroscope.y.toString()),
  ///       Text(gyroscope.z.toString()),
  ///     ],
  ///   ),
  /// )
  /// ```
  final Widget Function(
    BuildContext context,
    VectorModel gyroscope,
    VectorModel rotation,
  )? builder;

  /// ## [GyroProvider.skew]
  /// [GyroProvider.skew], which allows you to conveniently build **skew transformations**
  /// of [child] widgets using gyroscope sensor values.
  /// It performs a [Matrix4] transformation of the widget based on the device tilt,
  /// with [Animation] to help it move smoothly.
  ///
  /// ---
  ///
  /// ### Modifiers
  ///
  /// - child
  /// - horizontalLock
  /// - verticalLock
  /// - centerLock
  /// - resetTime
  /// - sensitivity
  /// - shift
  /// - animationDuration
  /// - reverse
  ///
  /// <br />
  ///
  /// ### Example
  /// ```dart
  /// GyroProvider.skew(
  ///   verticalLock: true,
  ///   resetTime: const Duration(seconds: 2),
  ///   shift: 12,
  ///   reverse: true,
  ///   child: ChildWidget(),
  /// )
  /// ```
  const GyroProvider.skew({
    super.key,
    required this.child,
    this.horizontalLock = false,
    this.verticalLock = false,
    this.centerLock = false,
    this.resetTime = const Duration(seconds: 1),
    this.sensitivity = 0.002,
    this.shift = 10.0,
    this.animationDuration = const Duration(milliseconds: 500),
    this.reverse = false,
  })  : _mode = _GyroWidgetMode.skew,
        gyroscope = null,
        rotation = null,
        builder = null;

  /// Widget that you want to transform.
  final Widget? child;

  /// You can locked the horizontal transform of a widget
  /// when the device is rotated in the horizontal direction.
  ///
  /// ---
  ///
  /// The default value is `false`.
  final bool horizontalLock;

  /// You can locked the vertical transform of a widget
  /// when the device is rotated in the vertical direction.
  ///
  /// ---
  ///
  /// The default value is `false`.
  final bool verticalLock;

  /// You can locked the ability to reset the reference point (center).
  ///
  /// _**Notice**_
  /// - The orientation the device is facing at the time the widget is first built
  ///   is set as the reference point (center).
  /// - Because it rotates with the amount of change in the gyroscope sensor,
  ///   the reference point (center) may shift depending on
  ///   the rotation speed of the device.
  ///
  /// ---
  ///
  /// The default value is `false`.
  final bool centerLock;

  /// Specifies the amount of time to wait before resetting
  /// the reference point (center).
  ///
  /// ---
  ///
  /// The default value is `Duration(seconds: 1)`.
  final Duration resetTime;

  /// Specifies the sensitivity of the widget based on the gyroscope sensor value.
  ///
  /// ---
  ///
  /// The default value is `0.002`.
  final double sensitivity;

  /// Specifies how much the widget's position changes based on
  /// the gyroscope sensor value.
  ///
  /// ---
  ///
  /// The default value is `10.0`.
  final double shift;

  /// Specifies the speed of the transformation animation.
  ///
  /// _**Notice**_
  /// - We don't recommend making any changes.
  /// - Suggested values range from `300` to `700 milliseconds`.
  ///
  /// ---
  ///
  /// The default value is `Duration(milliseconds: 500)`.
  final Duration animationDuration;

  /// You can set the transform/translation direction of the widget
  /// to be the opposite of the device's rotation direction.
  ///
  /// ---
  ///
  /// The default value is `false`.
  final bool reverse;

  @override
  State<GyroProvider> createState() => _GyroProviderState();
}

class _GyroProviderState extends State<GyroProvider>
    with SingleTickerProviderStateMixin {
  // Controller object that provides sensor data provided via an EventChannel.
  final GyroscopeController _gyroscopeController = GyroscopeController();
  final RotationController _rotationController = RotationController();

  // ValueNotifier object that holds the data to be passed to the callback function.
  final ValueNotifier<VectorModel> _gyroData =
      ValueNotifier(VectorModel(0, 0, 0));
  final ValueNotifier<VectorModel> _rotateData =
      ValueNotifier(VectorModel(0, 0, 0));

  // AnimationController object for smoothing out the gaps between sensor events.
  late final AnimationController _animationController;

  // Animation object that holds x, y-axis rotation angle data.
  late Animation<double> _xAnimation;
  late Animation<double> _yAnimation;

  // CurvedAnimation object that stores the widget's animation curve.
  late final CurvedAnimation _linearCurve;
  late final CurvedAnimation _easeCurve;

  // Variable that stores the target rotation angle for animations
  // that operate between sensor events.
  double _xTarget = 0;
  double _yTarget = 0;

  // A boolean value indicating the status of whether the sensor is moving
  // toward the reference point (aka. center).
  bool _onCenter = false;

  // A timer object that prevents the widget from being set to the reference point
  // for a certain number of seconds after the device stops rotating.
  Timer? _resetTimer;

  @override
  void initState() {
    super.initState();
    // Add stream subscription listener
    _gyroscopeController.addListener(_gyroListener);
    _rotationController.addListener(_rotateListener);

    // Initialize animation
    _animationController = AnimationController(
      vsync: this,
      duration: widget.animationDuration,
    )
      ..addListener(_animationListener)
      ..addStatusListener(_animationStatusListener);

    _linearCurve = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear,
    );
    _easeCurve = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _xAnimation = Tween<double>(
      begin: 0,
      end: _xTarget,
    ).animate(_linearCurve);
    _yAnimation = Tween<double>(
      begin: 0,
      end: _yTarget,
    ).animate(_linearCurve);
    _animationController.forward();
  }

  @override
  void dispose() {
    // Stop _resetTimer
    _resetTimer?.cancel();

    // Dispose sensorController
    _gyroscopeController.removeListener(_gyroListener);
    _gyroscopeController.dispose();
    _rotationController.removeListener(_rotateListener);
    _rotationController.dispose();

    // Stop animation
    _animationController.stop();
    _animationController.removeListener(_animationListener);
    _animationController.removeStatusListener(_animationStatusListener);
    _animationController.dispose();
    super.dispose();
  }

  // Define what to do when listening to the gyroscope sensor value.
  // - Callback the sensor value.
  // - Process animations.
  void _gyroListener() {
    var value = _gyroscopeController.value;
    _gyroData.value = value;
    widget.gyroscope?.call(value);

    if (widget._mode != _GyroWidgetMode.provide) {
      // If the change in sensor value is consistently small over a period of time,
      // reset the reference point and animate it to move toward the center.
      if (value.x.abs() < 0.1 && value.y.abs() < 0.1 && !widget.centerLock) {
        _resetTimer ??= Timer(widget.resetTime, () {
          _xTarget = 0;
          _yTarget = 0;
          _resetTimer = null;
          _onCenter = true;
          _animation(curve: _easeCurve);
        });
      }
      // Change the target rotation angle by the amount the sensor value changes
      // and animate toward that value.
      else {
        _xTarget += value.x;
        _yTarget += value.y;
        _resetTimer?.cancel();
        _resetTimer = null;
      }
      // The animation only changes when the widget is not being moved to the center.
      if (!_onCenter) {
        _animation(curve: _linearCurve);
      }
    }
  }

  // Define what to do when listening to the position sensor (rotation) value.
  // - Callback the sensor value.
  void _rotateListener() {
    var value = _rotationController.value;
    _rotateData.value = value;
    widget.rotation?.call(value);
  }

  // A function that is called every tick of the animation, re-rendering the screen
  // only when the animation is in motion.
  void _animationListener() {
    if (_animationController.status == AnimationStatus.forward) {
      setState(() {});
    }
  }

  // A function that is called when the animation state changes,
  // changing it(_onCenter) to a non-centered(false) state
  // when the animation action is complete.
  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _onCenter = false;
    }
  }

  // Performs actions that modify and run animations only when mounted.
  // The injected curve will animate from the current rotation angle
  // to the target rotation angle.
  void _animation({required CurvedAnimation curve}) {
    if (!mounted) return;

    var xCurr = _xAnimation.value;
    var yCurr = _yAnimation.value;
    _animationController.reset();
    _xAnimation = Tween<double>(
      begin: xCurr,
      end: _xTarget,
    ).animate(curve);
    _yAnimation = Tween<double>(
      begin: yCurr,
      end: _yTarget,
    ).animate(curve);
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // The widget that is built on a call to [GyroProvider].
    if (widget._mode == _GyroWidgetMode.provide) {
      return ValueListenableBuilder(
        valueListenable: _gyroData,
        builder: (context, gyroValue, _) => ValueListenableBuilder(
          valueListenable: _rotateData,
          builder: (context, rotateValue, _) =>
              widget.builder?.call(context, gyroValue, rotateValue) ??
              const SizedBox(),
        ),
      );
    }

    // The widget that is built on a call to [GyroProvider.skew].
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(
          3,
          0,
          -_yAnimation.value *
              widget.sensitivity *
              (widget.horizontalLock ? 0 : 1) *
              (widget.reverse ? -1 : 1),
        )
        ..setEntry(
          3,
          1,
          -_xAnimation.value *
              widget.sensitivity *
              (widget.verticalLock ? 0 : 1) *
              (widget.reverse ? -1 : 1),
        )
        ..setEntry(
          0,
          3,
          _yAnimation.value *
              widget.shift *
              (widget.horizontalLock ? 0 : 1) *
              (widget.reverse ? -1 : 1),
        )
        ..setEntry(
          1,
          3,
          _xAnimation.value *
              widget.shift *
              (widget.verticalLock ? 0 : 1) *
              (widget.reverse ? -1 : 1),
        ),
      child: widget.child,
    );
  }
}
