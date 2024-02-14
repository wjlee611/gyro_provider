import 'package:flutter/material.dart';
import 'package:gyro_provider/gyro_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              GyroProvider(
                gyroscope: (vector) {
                  print(vector);
                },
                builder: (context, gyroscope, rotation) => Column(
                  children: [
                    const Text('gyroscope'),
                    Text(gyroscope.x.toString()),
                    Text(gyroscope.y.toString()),
                    Text(gyroscope.z.toString()),
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              GyroProvider.skew(
                verticalLock: true,
                child: Container(
                  color: Colors.red,
                  width: 100,
                  height: 100,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
