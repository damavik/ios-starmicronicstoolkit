Pod::Spec.new do |s|
  s.name = 'StarIO'
  s.version = '4.1.1'
  s.summary = 'StarMicronics iOS SDK with mPOP support'
  s.license = { :type => 'BSD', :file => 'README.md' }
  s.authors = {"Unknown"=>"unknown@starmicronics.com"}
  s.homepage = 'http://starmicronics.com'
  s.frameworks = 'CoreBluetooth'
  s.requires_arc = true
  s.source = { :git => 'https://bitbucket.org/Fiverun/ios-starmicronicstoolkit.git', :tag => s.version.to_s}
  s.platform = :ios, '7.0'

  s.ios.deployment_target = '7.0'

  s.subspec 'Core' do |ss|
    ss.vendored_frameworks = 'StarIO.framework'
  end

  s.subspec 'mPOP' do |ss|
    ss.vendored_frameworks = 'StarIO_Extension.framework'
  end

end
