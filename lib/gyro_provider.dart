import 'package:flutter/widgets.dart';
import 'package:gyro_provider/provider/gyroscope.dart';
import 'package:gyro_provider/provider/rotation.dart';
import 'package:gyro_provider/widgets/multi_stream_builder.dart';

class GyroProvider extends StatefulWidget {
  const GyroProvider({super.key});

  @override
  State<GyroProvider> createState() => _GyroProviderState();
}

class _GyroProviderState extends State<GyroProvider> {
  late final Gyroscope _gyroscope;
  late final Rotation _rotation;

  @override
  void initState() {
    super.initState();
    _gyroscope = Gyroscope();
    _rotation = Rotation();
  }

  @override
  Widget build(BuildContext context) {
    return MultiStreamBuilder(
      streams: [
        _gyroscope.getGyroscope(),
        _rotation.getRotation(),
      ],
      builder: (context, snapshots) => Column(
        children: [
          const Text('Gyro'),
          Text(snapshots[0].x.toString()),
          Text(snapshots[0].y.toString()),
          Text(snapshots[0].z.toString()),
          const Text('Rotate'),
          Text(snapshots[1].x.toString()),
          Text(snapshots[1].y.toString()),
          Text(snapshots[1].z.toString()),
        ],
      ),
    );
  }
}
