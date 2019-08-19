Pod::Spec.new do |s|
  s.name             = 'PhotonIMSDK'
  s.version          = '0.0.1'
  s.summary          = 'A short description of PhotonIMSDK.'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/cosmos33/PhotonIMSDK-iOS'
  s.author           = { 'cosmos33' => 'cosmossaas@gmail.com' }
  s.source           = { :git => 'http://say-public.oss-cn-beijing.aliyuncs.com/cosmos/PhotonIMSDK-iOS.zip', :tag => s.version.to_s }
  s.platform         = :ios, '10.0'
  s.ios.deployment_target = '10.0'
  s.static_framework = true

  s.subspec 'PhotonIMSDK' do |im|
  im.name        = 'PhotonIMSDK'
  im.framework   = 'Foundation'
  im.framework = 'SystemConfiguration'
  im.framework = 'CoreTelephony'
  im.vendored_frameworks = 'Products/PhotonIMSDK.framework','Products/MDAudioKit.framework'
  im.vendored_libraries = 'Products/libprotobuf.a'
  im.resources = 'Products/PhotonImResource.bundle'
  im.libraries    = 'z','resolv','stdc++','sqlite3'
  end
  s.ios.libraries = 'c++','z','resolv','stdc++','sqlite3'
end
