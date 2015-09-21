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
    ss.dependency 'ChouTi/Protocols'
    ss.dependency 'ChouTi/CollectionViewLayouts'
    ss.dependency 'ChouTi/Animators'

    ss.dependency 'ChouTi/SlideController'
    ss.dependency 'ChouTi/AutoLinesLabel'
    ss.dependency 'ChouTi/SegmentedControl'

  end

  s.subspec "Extensions" do |ss|
    ss.summary      = "Extensions of UIKit"

    ss.source_files = 'Source/iOS/Extensions/*.*'
    ss.frameworks   = 'UIKit'

  end

  s.subspec "Protocols" do |ss|
    ss.summary      = "Protocols"

    ss.source_files = 'Source/iOS/Protocols/*.*'
    ss.frameworks   = 'UIKit'

  end

  s.subspec "Animators" do |ss|
    ss.summary      = "A set of customized view controller transition animators"

    ss.source_files = 'Source/iOS/Animators/*.*'
    ss.frameworks   = 'UIKit'

  end

  s.subspec "CollectionViewLayouts" do |ss|
    ss.summary      = "A collection of UICollectionView Layouts"

    ss.source_files = 'Source/iOS/CollectionViewLayouts/*/*.*'
    ss.frameworks   = 'UIKit'

  end

  s.subspec "SlideController" do |ss|
    ss.summary      = "A left/right slide container view controller"

    ss.source_files = 'Source/iOS/SlideController/*.*'
    ss.frameworks   = 'UIKit'

  end

  s.subspec "AutoLinesLabel" do |ss|
    ss.summary      = "UILabel with contentInset and probide auto lines on iOS7"

    ss.source_files = 'Source/iOS/AutoLinesLabel/*.*'
    ss.frameworks   = 'UIKit'

  end

  s.subspec "SegmentedControl" do |ss|
    ss.summary      = "Customized Segmented Control, with underscore bars"

    ss.source_files = 'Source/iOS/SegmentedControl/*.*'
    ss.frameworks   = 'UIKit'

  end

end
