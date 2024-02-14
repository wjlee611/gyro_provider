import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:gyro_provider/models/vector_model.dart';
import 'package:gyro_provider/controller/gyroscope_controller.dart';
import 'package:gyro_provider/controller/rotation_controller.dart';

///
enum _GyroWidgetMode {
  provide,
  card,
  // parallel,
}

class GyroProvider extends StatefulWidget {
  final _GyroWidgetMode _mode;

  /// ### GyroProvider
  const GyroProvider({
    super.key,
    this.gyroscope,
    this.rotation,
    this.builder,
  })  : _mode = _GyroWidgetMode.provide,
        child = null;

  /// Callback function, which is returns the gyroscope value of the device.
  final Function(VectorModel vector)? gyroscope;

  /// Callback function, which is returns the rotation value of the device.
  ///
  /// (without magnitude)
  final Function(VectorModel vector)? rotation;

  final Widget Function(
    BuildContext context,
    VectorModel gyroscope,
    VectorModel rotation,
  )? builder;

  /// ### GyroProvider - Card
  const GyroProvider.card({
    super.key,
    required this.child,
  })  : _mode = _GyroWidgetMode.card,
        gyroscope = null,
        rotation = null,
        builder = null;

  ///
  final Widget? child;

  /// TODO: add options
  /// 1. horizontal/vertical lock
  /// 2. center lock
  /// 3. center reset time
  /// 4. sensitivity
  /// 5. reverse

  @override
  State<GyroProvider> createState() => _GyroProviderState();
}

class _GyroProviderState extends State<GyroProvider>
    with SingleTickerProviderStateMixin {
  //
  late final GyroscopeController _gyroscopeController;
  late final RotationController _rotationController;

  //
  final ValueNotifier<VectorModel> _gyroData =
      ValueNotifier(VectorModel(0, 0, 0));
  final ValueNotifier<VectorModel> _rotateData =
      ValueNotifier(VectorModel(0, 0, 0));

  //
  late final AnimationController _animationController;

  //
  late Animation<double> _xAnimation;
  late Animation<double> _yAnimation;

  //
  double _xTarget = 0;
  double _yTarget = 0;

  //
  bool _onCenter = false;

  //
  Timer? _resetTimer;

  late final CurvedAnimation _linearCurve;
  late final CurvedAnimation _easeCurve;

  @override
  void initState() {
    super.initState();
    _rotationController = RotationController();
    // Add stream subscription listener

    _gyroscopeController.addListener(_gyroListener);
    _rotationController.addListener(_rotateListener);

    // Initialize animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
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
    _gyroscopeController.removeListener(_gyroListener);
    _rotationController.removeListener(_rotateListener);

    _animationController.reset();
    _animationController.removeListener(_animationListener);
    _animationController.removeStatusListener(_animationStatusListener);
    _animationController.dispose();
    super.dispose();
  }

  //
  void _gyroListener() {
    var value = _gyroscopeController.value;
    _gyroData.value = value;
    widget.gyroscope?.call(value);

    if (widget._mode != _GyroWidgetMode.provide) {
      if (value.y.abs() < 0.1) {
        _resetTimer ??= Timer(const Duration(seconds: 1), () {
          _xTarget = 0;
          _yTarget = 0;
          _resetTimer = null;
          _onCenter = true;
          _animation(curve: _easeCurve);
        });
      } else {
        _xTarget += value.x;
        _yTarget += value.y;
        _resetTimer?.cancel();
        _resetTimer = null;
      }
      if (!_onCenter) {
        _animation(curve: _linearCurve);
      }
    }
  }

  //
  void _rotateListener() {
    var value = _rotationController.value;
    _rotateData.value = value;
    widget.rotation?.call(value);
  }

  //
  void _animationListener() {
    if (_animationController.status == AnimationStatus.forward) {
      setState(() {});
    }
  }

  void _animationStatusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _onCenter = false;
    }
  }

  //
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
    //
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

    //
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 0, -_yAnimation.value * 0.002)
        ..setEntry(3, 1, -_xAnimation.value * 0.002)
        ..setEntry(0, 3, _yAnimation.value * 10)
        ..setEntry(1, 3, _xAnimation.value * 10),
      child: widget.child,
    );
  }
}
