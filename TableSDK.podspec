
Pod::Spec.new do |spec|

  spec.name         = 'TableSDK'
  spec.version      = '1.0.0'
  spec.summary      = 'TableSDK framework'
  spec.description  = 'An iOS Swift SDK for TABLE.co.'

  spec.homepage     = 'https://github.com/TableCo/ios-sdk'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { 'roma.maiboroda@gmail.com' => 'MyTestSDK' }
  spec.source       = { :git => 'https://github.com/TableCo/ios-sdk', :tag => spec.version.to_s }
  
  spec.source_files = 'TableSDK/Table\ SDK/SDK/**/*.{h,m,swift}'
  spec.ios.deployment_target = '13.0'
  spec.resources    = 'TableSDK/Table\ SDK/SDK/Resources/**/*'
  spec.dependency 'OpenTok'
  spec.static_framework = true
end
