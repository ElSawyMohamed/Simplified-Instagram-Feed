# Uncomment the next line to define a global platform for your project
platform :ios, '12.1'
minimum_ios_version = '12.1'

target 'GentleMan2024' do
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

  target 'GentleMan2024Tests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'GentleMan2024UITests' do
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = minimum_ios_version
    end
  end
end
