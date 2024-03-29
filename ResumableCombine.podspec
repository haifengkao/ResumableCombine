#
# Be sure to run `pod lib lint ResumableCombine.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ResumableCombine'
  s.version          = '0.21.0'
  s.summary          = 'Handle backpressure in Swift Combine gracefully'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Swift Combine lacks of support for proper backpressure handling. Many of its operators just send request(.unlimited) for the first demand request. It renders the Combine's pull mechanism utterly uselesss. This project aims to fix this problem.on of the pod here.
                       DESC

  s.homepage         = 'https://github.com/haifengkao/ResumableCombine'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Hai Feng Kao' => 'haifeng@cocoaspice.in' }
  s.source           = { :git => 'https://github.com/haifengkao/ResumableCombine.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  s.osx.deployment_target = '10.15'

  s.swift_version = '5'

  s.source_files = 'Sources/**/*'

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Tests/ResumableCombineTests/**/*.{swift}'
    test_spec.dependency 'Quick' # This dependency will only be linked with your tests.
    test_spec.dependency 'Nimble' # This dependency will only be linked with your tests.
  end

# s.resource_bundles = {
  #   'ResumableCombine' => ['ResumableCombine/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'CResumableCombineHelpers', >= '0.1.0' # provides recrusive lock
end
