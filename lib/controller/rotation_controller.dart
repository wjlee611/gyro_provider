import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gyro_provider/models/vector_model.dart';

/// ### [RotationController]
class RotationController with WidgetsBindingObserver, ChangeNotifier {
  factory RotationController() {
    return _instance;
  }

  /// Private constructor of RotationController
  RotationController._() {
    WidgetsBinding.instance.addObserver(this);

    _eventChannel.receiveBroadcastStream().listen((event) {
      var sensorRes = event as List<double>;
      final vectorModel = VectorModel(
        sensorRes[0],
        sensorRes[1],
        sensorRes[2],
      );
      _rotation = vectorModel;
      if (_isForeground) {
        notifyListeners();
      }
    });
  }

  ///
  static final RotationController _instance = RotationController._();

  ///
  final EventChannel _eventChannel = const EventChannel('rotate_event_channel');

  ///
  VectorModel _rotation = VectorModel(0, 0, 0);

  ///
  VectorModel get value => _rotation;

  ///
  bool _isForeground = true;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        _isForeground = true;
        break;
      default:
        _isForeground = false;
        break;
    }
  }
}
