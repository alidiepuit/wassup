platform :ios, '8.0'
use_frameworks!

target 'wassup' do
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  pod 'Fusuma'
  pod 'SKPhotoBrowser'
  pod 'Fabric'
  pod 'Crashlytics'
  pod 'MWPhotoBrowser'
  pod 'AlamofireImage', '2.0'
  pod 'IQKeyboardManagerSwift', '4.0.5'
  pod 'DKImagePickerController', '3.3.5'
  pod 'ALCameraViewController'
  
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end
