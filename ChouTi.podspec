Pod::Spec.new do |s|
  s.name             = 'ChouTi'
  s.version          = '0.6.2'
  s.summary          = 'ChouTi (抽屉) - A framework for Swift development.'
  s.description      = <<-DESC
                       ChouTi (抽屉) - A framework for Swift development.

                       This is a project includes extended data structures, classes, extensions.
                       DESC
  s.homepage         = 'https://github.com/Ch0uTi/ChouTi'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HongHao Zhang' => 'me@honghaoz.com' }
  s.source           = { :git => 'https://github.com/Ch0uTi/ChouTi.git', :tag => s.version.to_s }

  s.swift_version    = '5.0'
  s.requires_arc     = true
  s.ios.deployment_target = '11.0'
  s.tvos.deployment_target = '11.0'

  s.source_files     = 'Sources/**/*.swift'
  s.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'Tests/**/*.swift'
    test_spec.dependency 'Quick', '~> 2.1'
    test_spec.dependency 'Nimble', '~> 8.0'
  end

end
