import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'gyro_provider_platform_interface.dart';

/// An implementation of [GyroProviderPlatform] that uses method channels.
class MethodChannelGyroProvider extends GyroProviderPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('gyro_provider');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
