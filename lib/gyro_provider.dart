
import 'gyro_provider_platform_interface.dart';

class GyroProvider {
  Future<String?> getPlatformVersion() {
    return GyroProviderPlatform.instance.getPlatformVersion();
  }
}
