#
# Be sure to run `pod lib lint FALEventHub.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FALEventHub'
  s.version          = '0.1.1'
  s.summary          = 'Event manager for decoupling classes'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Event manager for decoupling classes made in Swift 4
                       DESC

  s.homepage         = 'https://bitbucket.org/javiergov/podtesting/overview'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Javier González Ovalle' => 'jagonzalezo@falabella.cl' }
  s.source           = { :git => 'https://javiergov@bitbucket.org/javiergov/podtesting.git', :tag => s.version.to_s }
  s.swift_version    = '4.0'
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'FALEventHub/Classes/**/*'
  
  # s.resource_bundles = {
  #   'FALEventHub' => ['FALEventHub/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
