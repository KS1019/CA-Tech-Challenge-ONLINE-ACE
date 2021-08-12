# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'ace-c-ios' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ace-c-ios

  target 'ace-c-iosTests' do
    inherit! :search_paths
  pod 'OHHTTPStubs'
  pod 'OHHTTPStubs/Swift'
  end

  target 'ace-c-iosUITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
    end
  end
end
