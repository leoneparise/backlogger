# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
use_frameworks!

target 'BackLoggerExample' do
    pod 'BackLogger', :path => '.'
    pod 'BackLogger/UI', :path => '.'
end

# Enable to preview @IBDesignables inside BackLogger Pod
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
        end
    end
end
