import 'package:flutter/widgets.dart';
import 'package:gyro_provider/models/vector_model.dart';
import 'package:gyro_provider/provider/gyroscope_provider.dart';
import 'package:gyro_provider/provider/rotation_provider.dart';

/// Interface to the builder function of the [GyroProvider].
typedef GyroscopeWidgetBuilder = Widget Function(
  BuildContext context,
  VectorModel gyroscope,
  VectorModel rotation,
);

enum _GyroWidgetMode {
  provide,
  card,
  // parallel,
  // glow,
}

/// [_GyroProviderBase] has interfaces to the required functionality
/// provided by the [GyroProvider].
///
///  1. [gyroscope] callback function, which is returns the gyroscope
///     value of the device.
///  2. [rotation] callback function, which is returns the rotation
///     value of the device. (without magnitude)
///  3. [build] function, which is interface to get widget or builder
///     for child classes.
///
/// See Also:
///
///  * [GyroProvider], which provides values for gyroscope and rotation sensor data,
///    and provides a builder that uses those values.
///  * [_GyroWidgetBase], which is an interface for providing a number of simple
///    to use widgets that utilize sensor data.
abstract class _GyroProviderBase extends StatefulWidget {
  const _GyroProviderBase({
    super.key,
    this.gyroscope,
    this.rotation,
    this.mode = _GyroWidgetMode.provide,
  });

  /// Callback function, which is returns the gyroscope value of the device.
  final Function(VectorModel vector)? gyroscope;

  /// Callback function, which is returns the rotation value of the device.
  /// (without magnitude)
  final Function(VectorModel vector)? rotation;

  ///
  final _GyroWidgetMode mode;

  /// Build function, which is interface to get widget or builder for child classes.
  Widget build(
    BuildContext context,
    VectorModel gyroscope,
    VectorModel rotation,
  );

  @override
  State<_GyroProviderBase> createState() => _GyroProviderBaseState();
}

class _GyroProviderBaseState extends State<_GyroProviderBase>
    with WidgetsBindingObserver {
  final ValueNotifier<VectorModel> _gyroData =
      ValueNotifier(VectorModel(0, 0, 0));
  final ValueNotifier<VectorModel> _rotateData =
      ValueNotifier(VectorModel(0, 0, 0));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    GyroscopeProvider().gyroStream.listen((event) {
      _gyroData.value = event;
      widget.gyroscope?.call(event);
    });
    RotationProvider().rotateStream.listen((event) {
      _rotateData.value = event;
      widget.rotation?.call(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    ///
    if (widget.mode == _GyroWidgetMode.provide) {
      return ValueListenableBuilder(
        valueListenable: _gyroData,
        builder: (context, gyroValue, _) => ValueListenableBuilder(
          valueListenable: _rotateData,
          builder: (context, rotateValue, _) =>
              widget.build(context, gyroValue, rotateValue),
        ),
      );
    }

    ///
    return ValueListenableBuilder(
      valueListenable: _gyroData,
      builder: (context, gyroValue, _) => ValueListenableBuilder(
        valueListenable: _rotateData,
        builder: (context, rotateValue, _) => AnimatedContainer(
          curve: Curves.easeInOut,
          duration: const Duration(milliseconds: 1),
          transform: Matrix4(
            1,
            0,
            0,
            (rotateValue.y) * 0.01,
            0,
            1,
            0,
            (rotateValue.x) * 0.01,
            0,
            0,
            1,
            0,
            0,
            0,
            0,
            1,
          ),
          transformAlignment: Alignment.center,
          child: widget.build(context, gyroValue, rotateValue),
        ),
      ),
    );
  }
}

class GyroProvider extends _GyroProviderBase {
  const GyroProvider({
    super.key,
    super.gyroscope,
    super.rotation,
    required this.builder,
  });

  final GyroscopeWidgetBuilder builder;

  @override
  Widget build(
    BuildContext context,
    VectorModel gyroscope,
    VectorModel rotation,
  ) =>
      builder(context, gyroscope, rotation);
}

class _GyroWidgetBase extends _GyroProviderBase {
  const _GyroWidgetBase({
    super.key,
    required this.child,
    super.mode,
  });

  final Widget child;

  @override
  Widget build(
    BuildContext context,
    VectorModel gyroscope,
    VectorModel rotation,
  ) =>
      child;
}

class GyroWidget extends _GyroWidgetBase {
  const GyroWidget({
    super.key,
    required super.child,
  }) : super(mode: _GyroWidgetMode.card);

  const GyroWidget.card({
    super.key,
    required super.child,
  }) : super(mode: _GyroWidgetMode.card);

  // TODO: add modes
  // const GyroWidget.parallel({
  //   super.key,
  //   required super.child,
  // }) : super(mode: _GyroWidgetMode.parallel);

  // const GyroWidget.glow({
  //   super.key,
  //   required super.child,
  // }) : super(mode: _GyroWidgetMode.glow);
}
