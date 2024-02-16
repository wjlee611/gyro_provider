import 'dart:math';
import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final size = min(width, height) * 0.5;

    const textStyle = TextStyle(
      color: Colors.white,
      fontSize: 10,
    );

    return Container(
      width: size,
      height: size * 16 / 7,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Colors.purpleAccent,
            Colors.cyan,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            blurRadius: 20,
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Padding(
        padding: EdgeInsets.all(10),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                'gyro_provider',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Applied parameter - skew',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    '''
                    verticalLock: true
                    resetLock: true
                    shift: 20
                    sensitivity: 0.0002,
                    reverse: true,
                    ''',
                    style: textStyle,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'gyro_provider example widget',
                    style: textStyle,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
