# Uncomment the next line to define a global platform for your project
platform :ios, '8.2'
use_frameworks!

target 'BackLogger' do
    pod 'SQLite.swift'
    pod 'SwiftDate'
end

target 'BackLoggerUI' do
    
end

target 'BackLoggerExample' do

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CONFIGURATION_BUILD_DIR'] = '$PODS_CONFIGURATION_BUILD_DIR'
        end
    end
end
