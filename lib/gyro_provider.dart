import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:gyro_provider/models/vector_model.dart';
import 'package:gyro_provider/provider/gyroscope.dart';
import 'package:gyro_provider/provider/rotation.dart';

typedef GyroscopeWidgetBuilder = Widget Function(
  BuildContext context,
  VectorModel gyroscope,
  VectorModel rotation,
);

abstract class _GyroProviderBase extends StatefulWidget {
  final Function(VectorModel vector)? gyroscope;
  final Function(VectorModel vector)? rotation;

  const _GyroProviderBase({
    super.key,
    this.gyroscope,
    this.rotation,
  });

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
  final Gyroscope _gyroscope = Gyroscope();
  final Rotation _rotation = Rotation();

  StreamSubscription<VectorModel>? _gyroStreamSubscription;
  StreamSubscription<VectorModel>? _rotateStreamSubscription;

  VectorModel _gyroData = VectorModel(0, 0, 0);
  VectorModel _rotateData = VectorModel(0, 0, 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _subscribe();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _subscribe();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _unsubscribe();
        break;
    }
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    _gyroStreamSubscription = _gyroscope.getGyroscope().listen((event) {
      setState(() {
        _gyroData = event;
        widget.gyroscope?.call(_gyroData);
      });
    });

    _rotateStreamSubscription = _rotation.getRotation().listen((event) {
      setState(() {
        _rotateData = event;
        widget.rotation?.call(_rotateData);
      });
    });
  }

  void _unsubscribe() {
    _gyroStreamSubscription?.cancel();
    _rotateStreamSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) => widget.build(
        context,
        _gyroData,
        _rotateData,
      );
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

enum _GyroWidgetMode {
  card,
  parallel,
  glow,
}

class _GyroWidgetBase extends _GyroProviderBase {
  const _GyroWidgetBase({
    super.key,
    required this.child,
    this.mode = _GyroWidgetMode.card,
  });

  final _GyroWidgetMode mode;
  final Widget child;

  @override
  Widget build(
    BuildContext context,
    VectorModel gyroscope,
    VectorModel rotation,
  ) =>
      // TODO: build different animation with mode
      Container(
        child: child,
      );
}

class GyroWidget extends _GyroWidgetBase {
  const GyroWidget({
    super.key,
    required super.child,
  });

  const GyroWidget.card({
    super.key,
    required super.child,
  }) : super(mode: _GyroWidgetMode.card);

  const GyroWidget.parallel({
    super.key,
    required super.child,
  }) : super(mode: _GyroWidgetMode.parallel);

  const GyroWidget.glow({
    super.key,
    required super.child,
  }) : super(mode: _GyroWidgetMode.glow);
}
