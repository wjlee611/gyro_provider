import 'package:flutter_test/flutter_test.dart';
import 'package:gyro_provider/gyro_provider.dart';
import 'package:gyro_provider/gyro_provider_platform_interface.dart';
import 'package:gyro_provider/gyro_provider_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockGyroProviderPlatform
    with MockPlatformInterfaceMixin
    implements GyroProviderPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final GyroProviderPlatform initialPlatform = GyroProviderPlatform.instance;

  test('$MethodChannelGyroProvider is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelGyroProvider>());
  });

  test('getPlatformVersion', () async {
    GyroProvider gyroProviderPlugin = GyroProvider();
    MockGyroProviderPlatform fakePlatform = MockGyroProviderPlatform();
    GyroProviderPlatform.instance = fakePlatform;

    expect(await gyroProviderPlugin.getPlatformVersion(), '42');
  });
}
