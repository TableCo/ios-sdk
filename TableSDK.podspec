
Pod::Spec.new do |spec|

  spec.name         = 'TableSDK'
  spec.version      = '0.5.0'
  spec.summary      = 'TableSDK framework'
  spec.description  = 'An iOS Swift SDK for TABLE.co.'

  spec.homepage     = 'https://github.com/TableCo/ios-sdk'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { 'roman.maiboroda@chisw.com' => 'TableSDK' }
  spec.source       = { :git => 'https://github.com/TableCo/ios-sdk.git', :tag => spec.version.to_s }
  
  spec.source_files = 'TableSDK/Table\ SDK/SDK/**/*.{h,m,swift}'
  spec.ios.deployment_target = '13.0'
  spec.resources    = 'TableSDK/Table\ SDK/SDK/Resources/**/*'
  spec.swift_version = ['5.0', '5.1', '5.2', '5.3']
  spec.dependency 'OpenTok'
  spec.dependency 'JitsiMeetSDK'
  spec.static_framework = true

 # https://github.com/CocoaPods/CocoaPods/issues/10065
  spec.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
  spec.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

end
