import 'package:flutter/widgets.dart';
import 'package:gyro_provider/provider/gyroscope.dart';
import 'package:gyro_provider/provider/rotation.dart';

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
    return StreamBuilder(
      stream: _gyroscope.getGyroscope(),
      builder: (context, gyro) => StreamBuilder(
        stream: _rotation.getRotation(),
        builder: (context, rotate) => Column(
          children: [
            const Text('Gyroscope'),
            Text(gyro.data?.x.toString() ?? 'No x data'),
            Text(gyro.data?.y.toString() ?? 'No y data'),
            Text(gyro.data?.z.toString() ?? 'No z data'),
            const Text('Rotation'),
            Text(rotate.data?.x.toString() ?? 'No x data'),
            Text(rotate.data?.y.toString() ?? 'No y data'),
            Text(rotate.data?.z.toString() ?? 'No z data'),
          ],
        ),
      ),
    );
  }
}
