import 'dart:async';
import 'package:flutter/services.dart';
import 'package:gyro_provider/models/vector_model.dart';

class GyroscopeProvider {
  static final GyroscopeProvider _instance = GyroscopeProvider._();
  factory GyroscopeProvider() {
    return _instance;
  }
  GyroscopeProvider._() {
    _eventChannel.receiveBroadcastStream().listen((event) {
      var sensorRes = event as List<double>;
      final vectorModel = VectorModel(
        sensorRes[0],
        sensorRes[1],
        sensorRes[2],
      );
      _gyroStreamController.add(vectorModel);
    });
  }

  final EventChannel _eventChannel = const EventChannel('gyro_event_channel');

  final StreamController<VectorModel> _gyroStreamController =
      StreamController<VectorModel>.broadcast();

  Stream<VectorModel> get gyroStream => _gyroStreamController.stream;
}
