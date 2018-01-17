#
# Be sure to run `pod lib lint ProcessLoadingView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ProcessLoadingView'
  s.version          = '0.1.1'
  s.summary          = '`ProcessLoadingView` is a CABasicAnimation based loading animation inspired from https://dribbble.com/shots/1118077-Proces-animation'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ProcessLoadingView is useful for apps which would like to show the progress of a certin process.
It's fully customizable and easy to use.
                       DESC

  s.homepage         = 'https://github.com/ayman-ibrahim/ProcessLoadingView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'ayman.ibrahim.alim@gmail.com' => 'ayman.ibrahim.alim@gmail.com' }
  s.source           = { :git => 'https://github.com/ayman-ibrahim/ProcessLoadingView.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'ProcessLoadingViewDemo/processView/*'
  
  # s.resource_bundles = {

  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit
end
