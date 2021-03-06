#
# Be sure to run `pod lib lint FALEventHub.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FALEventHub'
  s.version          = '0.2.2'
  s.summary          = 'Event manager for decoupling classes'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
'Event manager for decoupling classes made in Swift 4.
'An instance of a Class subscribes to a specific message and delivers a desired function to be called when an event is triggered.
'Functions can also be called on a background thread.
                       DESC

  s.homepage         = 'https://github.com/javiergov/FALEventHub'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Javier González Ovalle' => 'javiergov+dev@gmail.com' }
  s.source           = { :git => 'https://github.com/javiergov/FALEventHub.git', :tag => s.version.to_s }
  s.swift_version    = '5.0'
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'FALEventHub/Classes/**/*'
  
  # s.resource_bundles = {
  #   'FALEventHub' => ['FALEventHub/Assets/*.png']
  # }

  s.public_header_files = 'FALEventHub/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
