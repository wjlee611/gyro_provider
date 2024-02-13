import 'dart:async';
import 'package:flutter/services.dart';
import 'package:gyro_provider/models/vector_model.dart';

class RotationProvider {
  static final RotationProvider _instance = RotationProvider._();
  factory RotationProvider() {
    return _instance;
  }
  RotationProvider._() {
    _eventChannel.receiveBroadcastStream().listen((event) {
      var sensorRes = event as List<double>;
      final vectorModel = VectorModel(
        sensorRes[0],
        sensorRes[1],
        sensorRes[2],
      );
      _rotateStreamController.add(vectorModel);
    });
  }

  final EventChannel _eventChannel = const EventChannel('rotate_event_channel');

  final StreamController<VectorModel> _rotateStreamController =
      StreamController<VectorModel>.broadcast();

  Stream<VectorModel> get rotateStream => _rotateStreamController.stream;
}
