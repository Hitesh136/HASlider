#
# Be sure to run `pod lib lint HASlider.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HASlider'
  s.version          = '0.1.0'
  s.summary          = 'A short description of HASlider.'

  s.description      = 'Desc' 

  s.homepage         = 'https://github.com/Hitesh136/HASlider'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Hitesh136' => 'agarwal.hitesh94@gmail.com' }
  s.source           = { :git => 'https://github.com/Hitesh136/HASlider.git', :branch => 'master',  :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'HASlider/Classes/**/*'
end
