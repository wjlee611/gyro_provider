import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'gyro_provider_method_channel.dart';

abstract class GyroProviderPlatform extends PlatformInterface {
  /// Constructs a GyroProviderPlatform.
  GyroProviderPlatform() : super(token: _token);

  static final Object _token = Object();

  static GyroProviderPlatform _instance = MethodChannelGyroProvider();

  /// The default instance of [GyroProviderPlatform] to use.
  ///
  /// Defaults to [MethodChannelGyroProvider].
  static GyroProviderPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [GyroProviderPlatform] when
  /// they register themselves.
  static set instance(GyroProviderPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
