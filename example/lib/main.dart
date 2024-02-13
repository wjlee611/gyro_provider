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
                builder: (context, gyroscope, rotation) => Column(
                  children: [
                    const Text('rotation'),
                    Text(rotation.x.toString()),
                    Text(rotation.y.toString()),
                    Text(rotation.z.toString()),
                  ],
                ),
              ),
              const SizedBox(
                height: 100,
              ),
              GyroWidget.card(
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
