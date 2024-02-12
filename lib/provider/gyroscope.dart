import 'package:flutter/services.dart';
import 'package:gyro_provider/models/vector_model.dart';

class Gyroscope {
  static final Gyroscope _instance = Gyroscope._();
  factory Gyroscope() {
    return _instance;
  }
  Gyroscope._();

  final EventChannel _eventChannel = const EventChannel('gyro_event_channel');

  Stream<VectorModel> getGyroscope() {
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
