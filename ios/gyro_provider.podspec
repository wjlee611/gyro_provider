#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint gyro_provider.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'gyro_provider'
  s.version          = '0.0.1'
  s.summary          = 'Flutter Gyroscope'
  s.description      = <<-DESC
  A plugin that provides data from gyroscopes and rotation sensors and related handy widgets.
                       DESC
  s.homepage         = 'https://wjlee611.github.io/'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'devWoong' => 'wjlee611@gmail.com' }
  s.source           = { :http => 'https://github.com/wjlee611/gyro_provider' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  s.resource_bundles = {'gyro_provider_privacy' => ['PrivacyInfo.xcprivacy']}
end
