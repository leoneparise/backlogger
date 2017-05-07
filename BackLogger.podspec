Pod::Spec.new do |s|
  s.name         = 'BackLogger'
  s.version      = '1.0.0'
  s.license      = { :type => 'MIT' }
  s.homepage     = 'https://github.com/leoneparise/BackLogger'
  s.authors      = { 'Tony Million' => 'leone.parise@gmail.com' }
  s.summary      = 'Background Log Manager'
  s.source       = { :git => 'https://github.com/leoneparise/BackLogger.git', :tag => 'v1.0.0' }
  s.default_subspecs = 'Core'
  s.platform = :ios

  s.subspec 'Core' do |core|
    core.source_files = 'BackLogger/**/*.swift'
    core.ios.deployment_target = '8.2'

    core.dependency 'SQLite.swift'
    core.dependency 'SwiftDate'
  end

  s.subspec 'UI' do |ui|    
  	ui.ios.deployment_target = '9.0'
    ui.source_files = 'BackLoggerUI/**/*.swift'    
    ui.resource = ['BackLoggerUI/**/*.xib']

    ui.dependency 'BackLogger/Core'
  end

  s.default_subspec = 'Core'
end