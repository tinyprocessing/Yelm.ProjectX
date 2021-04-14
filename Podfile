# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Yelm.ProjectX' do
  # Comment the next line if you don't want to use dynamic frameworks
  platform :ios, '13.1'
  use_frameworks!

  pod 'YandexMapKit', '3.5'
  pod 'YandexMapKitSearch', '3.5' 

  post_install do |installer|
  installer.pods_project.targets.each do |target|
	target.build_configurations.each do |config|
    	config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
			end
		end
	end

  # Pods for Yelm.ProjectX

end
