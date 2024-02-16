import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:gyro_provider/models/vector_model.dart';

/// ## [RotationController]
/// The [RotationController] provides the values of the device's position sensor. \
/// (Rotation only, without geomagnetic)
///
/// ---
///
/// ### How to use?
/// 1. Initialize [RotationController]
/// 2. Add listener
/// 3. Get data inside listener using `_rotationController.value`
///
/// <br />
///
/// ### Example
/// ```dart
/// class _WidgetState extends State<Widget> {
///   final RotationController _rotationController = RotationController();
///
///   @override
///   void initState() {
///     super.initState();
///     _rotationController.addListener(_rotateListener);
///   }
///
///   @override
///   void dispose() {
///     _rotationController.removeListener(_rotateListener);
///     _rotationController.dispose();
///     super.dispose();
///   }
///
///   void _rotateListener() {
///     var value = _rotationController.value;
///     // using value
///   }
/// ```
///
/// <br />
///
/// ### Need to know
/// - You can only listen while the app is in Foreground.
class RotationController with WidgetsBindingObserver, ChangeNotifier {
  /// ## [RotationController]
  /// The [RotationController] provides the values of the device's position sensor. \
  /// (Rotation only, without geomagnetic)
  ///
  /// _**Notice**_
  /// - Sensor data is sent only in the [AppLifecycleState.resumed] state.
  /// - Constructor implemented in the singleton pattern.
  /// - Because it is implemented in a singleton pattern, the `dispose` method
  ///   of the controller is implemented to not work.
  /// - For performance, please call `removeListener`, `dispose (option)`
  ///   when deleting a widget.
  factory RotationController() {
    return _instance;
  }

  /// Private constructor of [RotationController]
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

  static final RotationController _instance = RotationController._();

  final EventChannel _eventChannel =
      const EventChannel('com.gmail.wjlee611.rotate_event_channel');

  VectorModel _rotation = VectorModel(0, 0, 0);

  /// Returns the value of the position sensor data as a [VectorModel].
  ///
  /// ---
  ///
  /// See Also:
  /// - [VectorModel]
  VectorModel get value => _rotation;

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

  @override
  // ignore: must_call_super
  void dispose() {
    // ignore super.dispose(); cause it is singleton.
  }
}
