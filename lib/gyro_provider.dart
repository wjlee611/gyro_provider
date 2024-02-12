import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:gyro_provider/models/vector_model.dart';
import 'package:gyro_provider/provider/gyroscope.dart';
import 'package:gyro_provider/provider/rotation.dart';

typedef GyroscopeCallback = Function(VectorModel vector);
typedef RotationCallback = Function(VectorModel vector);

class GyroProvider extends StatefulWidget {
  final GyroscopeCallback? gyroscope;
  final RotationCallback? rotation;
  final Widget? child;

  const GyroProvider({
    super.key,
    this.gyroscope,
    this.rotation,
    this.child,
  });

  @override
  State<GyroProvider> createState() => _GyroProviderState();
}

class _GyroProviderState extends State<GyroProvider>
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
  Widget build(BuildContext context) => widget.child ?? Container();
}
