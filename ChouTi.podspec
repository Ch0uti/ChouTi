Pod::Spec.new do |s|
  s.name             = 'ChouTi'
  s.version          = '0.5.0'
  s.summary          = 'ChouTi (抽屉) - A framework for Swift development.'
  s.description      = <<-DESC
                       ChouTi (抽屉) - A framework for Swift development.

                       This is a project includes extended data structures, classes, extensions.
                       DESC
  s.homepage         = 'https://github.com/Ch0uTi/ChouTi'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HongHao Zhang' => 'me@honghaoz.com' }
  s.source           = { :git => 'https://github.com/Ch0uTi/ChouTi.git', :tag => s.version.to_s }

  s.swift_version    = '5'
  s.requires_arc     = true
  s.default_subspec  = 'Core'

  s.subspec 'Core' do |ss|
    ss.source_files = 'Sources/Core/**/*.swift'
    ss.ios.deployment_target = '11.0'
    ss.tvos.deployment_target = "9.0"
    ss.watchos.deployment_target = "2.0"
    ss.osx.deployment_target = "10.12"
  end

  s.subspec 'iOS' do |ss|
    ss.ios.source_files = 'Sources/iOS/**/*.swift'
    ss.ios.exclude_files = [
      'Sources/iOS/UI/LoadingMorphingLabel',
      'Sources/iOS/UI/SlideController',
    ]
    ss.ios.resource_bundle = { 'Resources' => 'Resources/**/*.png' }
    ss.ios.dependency 'ChouTi/Core'
    ss.ios.deployment_target = '11.0'
  end

  # Not campatible with extensions
  s.subspec 'AppExtensionUnsafe' do |ss|
    ss.ios.source_files = 'Sources/iOS/UI/SlideController'
    ss.ios.dependency 'ChouTi/Core'
    ss.ios.deployment_target = '11.0'
  end

  # Components that has third party dependencies
  s.subspec 'LoadingMorphingLabel' do |ss|
    ss.ios.source_files = 'Sources/iOS/UI/LoadingMorphingLabel'
    ss.ios.dependency 'ChouTi/Core'
    ss.ios.dependency 'LTMorphingLabel', '~> 0.7'
    ss.ios.deployment_target = '11.0'
  end

  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Tests/ChouTiTests/**/*.swift'
    test_spec.dependency 'Quick', '~> 2.1'
    test_spec.dependency 'Nimble', '~> 8.0'
  end

end
