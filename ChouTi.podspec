Pod::Spec.new do |s|
  s.name             = "ChouTi"
  s.version          = "1.0"
  s.summary          = "Chou Ti (抽屉) - My personal toolkit for iOS/OSX development."
  s.description      = <<-DESC
                       Chou Ti (抽屉) - My personal toolkit for iOS/OSX development.
                       It contains common classes, extensions used in multiple projects

                       DESC
  s.homepage         = "https://github.com/honghaoz/ChouTi"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Honghao Zhang" => "zhh358@gmail.com" }
  s.source           = { :git => "https://github.com/honghaoz/ChouTi.git", :tag => s.version.to_s }

  s.platform     	 = :ios, '8.0'
  s.requires_arc 	 = true

  s.public_header_files = 'Source/**/**/*.h'
  s.source_files 	 = 'Source/iOS/**/'

  s.default_subspecs = 'UIChouTi'

  s.subspec "UIChouTi" do |ss|
    ss.summary		 = "A set of common UI views & utilities."

    ss.dependency 'ChouTi/Extensions'

  end

  s.subspec "Extensions" do |ss|
    ss.summary      = "Extensions of UIKit"

    ss.source_files = 'Source/iOS/Extensions/*.*'
    ss.frameworks   = 'UIKit'

  end

end
