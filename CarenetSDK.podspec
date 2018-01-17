#
# Be sure to run `pod lib lint CarenetSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CarenetSDK'
  s.version          = '0.1.0'
  s.summary          = 'A short description of CarenetSDK.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/renatocarvalhan1/SDK'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'renatocarvalhan1' => 'rcarvalhan@gmail.com' }
  s.source           = { :git => 'https://github.com/renatocarvalhan1/SDK.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  s.ios.deployment_target = '9.0'
  s.platform = :ios
  s.ios.framework = 'UIKit'
  s.requires_arc = true
  s.default_subspecs = 'All'
  s.ios.vendored_frameworks = 'FirebaseUIFrameworks/*/Frameworks/*.framework'

  s.subspec 'All' do |all|
    all.platform = :ios, '9.0'
    all.dependency "FirebaseUI"
    all.dependency "JVFloatLabeledTextField"
    all.dependency "VisualEffectView"
    all.dependency "SDWebImage"
  end

  s.source_files = 'CarenetSDK/Classes/**/*'
  
  s.resource_bundles = {
    'CarenetSDK' => ['CarenetSDK/Assets/**/*']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
    
end
