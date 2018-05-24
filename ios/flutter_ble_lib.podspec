#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'flutter_ble_lib'
  s.version          = '0.0.1'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
A new flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.requires_arc = ['Classes/BleClientManager/*', 'Classes/Converter.m', 'Classes/FlutterBleLibPlugin.m', 'Classes/Methods.m', 'Classes/Namespace.m']
  s.dependency 'Flutter'
  s.dependency 'RxBluetoothKit', '4.0.2'
  s.dependency 'Protobuf', '3.5.0'
  s.swift_version = '4.1.0'

  s.ios.deployment_target = '8.0'
  s.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS=1' }
end

