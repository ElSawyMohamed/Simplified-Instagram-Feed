# Uncomment the next line to define a global platform for your project
platform :ios, '14.1'
minimum_ios_version = '14.1'

target 'SimplifiedInstagramFeed' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for GentleMan2024
    pod 'RxSwift'
    pod 'RxCocoa'
    pod 'SwiftEntryKit'
    pod 'SDWebImage'
    pod 'ViewAnimator'
    pod 'Hero'
    pod 'Kingfisher', '~> 7.0'

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # Set minimum deployment target for all pods
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = minimum_ios_version
      
      # Fix any warnings about deprecated APIs
      config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = 'NO'
      
      # Ensure proper code signing for test targets
      if target.name.include?('Tests') || target.name.include?('UITests')
        config.build_settings['CODE_SIGN_IDENTITY'] = ''
        config.build_settings['CODE_SIGNING_REQUIRED'] = 'NO'
      end
    end
  end
end
