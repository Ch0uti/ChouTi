Pod::Spec.new do |s|
  s.name             = 'ChouTi'
  s.version          = '0.5'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.summary          = 'ChouTi (抽屉) - A framework for Swift development.'
  s.description      = <<-DESC
                       ChouTi (抽屉) - A framework for Swift development.

                       This is a project includes extended data structures, classes, extensions.
                       DESC
  s.homepage         = 'https://github.com/Ch0uTi/ChouTi'
  s.author           = { 'Honghao Zhang' => 'zhh358@gmail.com' }
  s.source           = { :git => 'https://github.com/Ch0uTi/ChouTi.git', :tag => s.version.to_s }

  s.requires_arc 	   = true
  s.swift_version    = '5'
  s.ios.deployment_target = '11.0'

  s.subspec 'Foundation' do |ss|
    ss.ios.source_files = 'ChouTi/Sources/**/*.swift'
    ss.ios.exclude_files = [
      'ChouTi/Sources/CodeSnippets',
      'ChouTi/Sources/iOS',
    ]
    ss.ios.resource_bundle = { 'Resources' => 'ChouTi/Resources/**/*.png' }
  end

  s.subspec 'Default' do |ss|
    ss.ios.source_files = 'ChouTi/Sources/**/*.swift'
    ss.ios.exclude_files = [
      'ChouTi/Sources/iOS/UI/LoadingMorphingLabel',
      'ChouTi/Sources/iOS/UI/SlideController',
    ]
    ss.ios.resource_bundle = { 'Resources' => 'ChouTi/Resources/**/*.png' }
  end

  # Not campatible with extensions
  s.subspec 'AppExtensionUnsafe' do |ss|
    ss.ios.source_files = 'ChouTi/Sources/iOS/UI/SlideController'
    ss.ios.dependency 'ChouTi/Default'
  end

  # Components that has third party dependencies
  s.subspec 'LoadingMorphingLabel' do |ss|
    ss.ios.source_files = 'ChouTi/Sources/iOS/UI/LoadingMorphingLabel'
    ss.ios.dependency 'ChouTi/Default'
    ss.ios.dependency 'LTMorphingLabel', '~> 0.7'
  end

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'ChouTi/Tests/*.swift'
    test_spec.dependency 'Quick', '~> 2.1'
    test_spec.dependency 'Nimble', '~> 8.0'
  end

end
