#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint document_detector.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_caf_document_detector'
  s.version          = '1.0.0'
  s.summary          = 'A Flutter plugin for Caf.io solution for document detection.'
  s.description      = <<-DESC
A Flutter plugin for Caf.io solution for document detection. It uses advanced computer vision algorithms to identify and extract documents from photos or camera frames.
                       DESC
  s.homepage         = 'https://www.caf.io/'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Caf.io' => 'services@caf.io' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.platform = :ios, '13.0'
  
  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.swift_version = '5.3.2'
  s.static_framework = true
  s.dependency 'Flutter'
  s.dependency 'DocumentDetector', '16.0.3'
end
