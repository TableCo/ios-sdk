
Pod::Spec.new do |spec|

  spec.name         = 'TableSDK'
  spec.version      = '1.0.0'
  spec.summary      = 'TableSDK framework'
  spec.description  = 'An iOS Swift SDK for TABLE.co.'

  spec.homepage     = 'https://github.com/TableCo/ios-sdk.git'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { 'roma.maiboroda@chisw.com' => 'MyTestSDK' }
  spec.source       = { :git => 'https://github.com/TableCo/ios-sdk.git', :tag => spec.version.to_s }
  
  spec.source_files = 'Sources/TableSDK/**/*.{h,m,swift}'
  spec.ios.deployment_target = '13.0'
  spec.resources    = 'Resources/**/*'
  spec.dependency 'OpenTok'
  spec.static_framework = true
end
