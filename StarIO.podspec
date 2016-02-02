Pod::Spec.new do |s|
  s.name = 'StarIO'
  s.version = '4.1.0'
  s.summary = 'StarMicronics iOS SDK with mPOP support'
  s.license = 'LICENSE'
  s.authors = {"Unknown"=>"unknown@starmicronics.com"}
  s.homepage = 'http://starmicronics.com'
  s.frameworks = 'CoreBluetooth'
  s.requires_arc = true
  s.source = { :git => ".", :tag => "#{s.version}" }
  s.platform = :ios, '7.0'

  s.ios.deployment_target = '7.0'

  s.preserve_paths = 'StarIO.framework'
  s.public_header_files = 'StarIO.framework.framework/Versions/A/Headers/*.h'
  s.vendored_frameworks = 'StarIO.framework'

  s.subspec 'mPOP' do |mpop|
    mpop.preserve_paths = 'StarIO_Extension.framework'
    mpop.public_header_files = 'StarIO_Extension.framework.framework/Versions/A/Headers/*.h'
    mpop.vendored_frameworks = 'StarIO_Extension.framework'
  end

end
