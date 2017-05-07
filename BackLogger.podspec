Pod::Spec.new do |s|
  s.name         = 'BackLogger'
  s.version      = '1.0.0'
  s.license      = { :type => 'MIT' }
  s.homepage     = 'https://github.com/leoneparise/BackLogger'
  s.authors      = { 'Tony Million' => 'leone.parise@gmail.com' }
  s.summary      = 'Background Log Manager'
  s.source       = { :git => 'https://github.com/leoneparise/BackLogger.git', :tag => s.version }
  s.platform     = :ios
  s.default_subspec = 'Core'
  s.ios.deployment_target = '8.2'

  s.subspec 'Core' do |core|
    core.source_files = 'BackLogger/*.swift'

    core.dependency 'SQLite.swift'
    core.dependency 'SwiftDate'
    core.framework  = "Foundation"
  end

  s.subspec 'UI' do |ui|    
  	ui.ios.deployment_target = '9.0'
    ui.source_files = 'BackLoggerUI/*.swift'    
    ui.resource = ['BackLoggerUI/**/*.xib']
    ui.framework  = "UIKit"

    ui.dependency 'BackLogger/Core'
  end  
end