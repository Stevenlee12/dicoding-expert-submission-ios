# Uncomment the next line to define a global platform for your project
# platform :ios, '14.0'

target 'GameCenter' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'SnapKit'
  pod 'SteviaLayout'
  pod 'Kingfisher'
  pod 'Alamofire', '~> 5.5'
  pod 'SteviaLayout'
  pod 'SwiftLint'
  pod 'lottie-ios'
  pod 'Swinject'
  
  # Pods for GameCenter
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      end
    end
  end
  
  target 'GameCenterTests' do
     inherit! :search_paths  # This will allow the test target to inherit the dependencies of the main target
     # Add test-specific dependencies here if needed
   end

end
