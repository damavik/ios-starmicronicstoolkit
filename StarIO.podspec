Pod::Spec.new do |s|
  s.name = 'StarIO'
  s.version = '5.4.0'
  s.summary = 'StarMicronics iOS SDK with mPOP support'
  s.license = { :type => 'BSD', :file => 'README.md' }
  s.authors = {"Unknown"=>"unknown@starmicronics.com"}
  s.homepage = 'http://starmicronics.com'
  s.frameworks = [ 'CoreBluetooth', 'ExternalAccessory' ]
  s.requires_arc = true
  s.source = { :git => 'git@github.com:damavik/ios-starmicronicstoolkit.git', :tag => s.version.to_s}
  s.platform = :ios, '8.0'

  s.ios.deployment_target = '8.0'
  s.default_subspec = 'Core'

  s.subspec 'Core' do |ss|
    ss.vendored_frameworks = 'StarIO.framework'
  end

  s.subspec 'mPOP' do |ss|
    ss.vendored_frameworks = [ 'StarIO.framework', 'SMCloudServices.framework', 'StarIO_Extension.framework' ]
  end

end
