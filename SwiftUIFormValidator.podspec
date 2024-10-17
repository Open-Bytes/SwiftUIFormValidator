Pod::Spec.new do |s|
  s.name             = 'SwiftUIFormValidator'
  s.version          = '1.1.0'
  s.summary          = 'A declarative form validation for SwiftUI'
  s.description      = <<-DESC
A declarative form validation for SwiftUI. Clean, simple, and customizable.
DESC

  s.homepage         = 'https://github.com/Open-Bytes/SwiftUIFormValidator'
  s.license          = { :type => 'Apache 2.0', :file => 'LICENSE' }
  s.author           = { 'MalekKamel' => 'sha.kamel.eng@gmail.com' }
  s.source           = { :git => 'https://github.com/Open-Bytes/SwiftUIFormValidator.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/MalekKamel'

  s.swift_version = '5'
  s.ios.deployment_target = '13.0'
  s.source_files  = "Sources/**/*"
  s.exclude_files  = "Sources/Supporting Files/**/*"
  s.framework  = "Foundation"
end
