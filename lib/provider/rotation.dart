import 'package:flutter/services.dart';
import 'package:gyro_provider/models/vector_model.dart';

class Rotation {
  static final Rotation _instance = Rotation._();
  factory Rotation() {
    return _instance;
  }
  Rotation._();

  final EventChannel _eventChannel = const EventChannel('rotate_event_channel');

  Stream<VectorModel> getRotation() {
    return _eventChannel.receiveBroadcastStream().map((event) {
      var sensorRes = event as List<double>;
      return VectorModel(
        sensorRes[0],
        sensorRes[1],
        sensorRes[2],
      );
    });
  }
}
