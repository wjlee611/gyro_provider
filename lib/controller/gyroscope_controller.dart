import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gyro_provider/models/vector_model.dart';

/// ### [GyroscopeController]
class GyroscopeController with WidgetsBindingObserver, ChangeNotifier {
  factory GyroscopeController() {
    return _instance;
  }

  /// Private constructor of GyroscopeController
  GyroscopeController._() {
    WidgetsBinding.instance.addObserver(this);

    _eventChannel.receiveBroadcastStream().listen((event) {
      var sensorRes = event as List<double>;
      final vectorModel = VectorModel(
        sensorRes[0],
        sensorRes[1],
        sensorRes[2],
      );
      _gyroscope = vectorModel;
      if (_isForeground) {
        notifyListeners();
      }
    });
  }

  ///
  static final GyroscopeController _instance = GyroscopeController._();

  ///
  final EventChannel _eventChannel = const EventChannel('gyro_event_channel');

  ///
  VectorModel _gyroscope = VectorModel(0, 0, 0);

  ///
  VectorModel get value => _gyroscope;

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
