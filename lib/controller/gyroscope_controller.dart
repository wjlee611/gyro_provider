import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gyro_provider/models/vector_model.dart';

/// ## [GyroscopeController]
/// The [GyroscopeController] provides the values of the device's gyro sensor.
///
/// ---
///
/// ### How to use?
/// 1. Initialize [GyroscopeController]
/// 2. Add listener
/// 3. Get data inside listener using `_gyroscopeController.value`
///
/// <br />
///
/// ### Example
/// ```dart
/// class _WidgetState extends State<Widget> {
///   final GyroscopeController _gyroscopeController = GyroscopeController();
///
///   @override
///   void initState() {
///     super.initState();
///     _gyroscopeController.addListener(_gyroListener);
///   }
///
///   @override
///   void dispose() {
///     _gyroscopeController.removeListener(_gyroListener);
///     _gyroscopeController.dispose();
///     super.dispose();
///   }
///
///   void _gyroListener() {
///     var value = _gyroscopeController.value;
///     // using value
///   }
/// ```
///
/// <br />
///
/// ### Need to know
/// - You can only listen while the app is in Foreground.
class GyroscopeController with WidgetsBindingObserver, ChangeNotifier {
  factory GyroscopeController() {
    return _instance;
  }

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

  static final GyroscopeController _instance = GyroscopeController._();

  final EventChannel _eventChannel = const EventChannel('gyro_event_channel');

  VectorModel _gyroscope = VectorModel(0, 0, 0);

  VectorModel get value => _gyroscope;

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
