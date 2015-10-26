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

  s.platform     	   = :ios, '8.0'
  s.requires_arc 	   = true

  s.public_header_files = 'Source/**/**/*.h'
  s.source_files 	   = 'Source/iOS/**/'


  s.default_subspecs = 'ChouTi', 'UI', 'App-Extension-API-Unsafe', 'UI-App-Extension-API-Unsafe'



  s.subspec "ChouTi" do |ss|
    ss.summary		 = "A Set of Common UI Utilities."

    ss.subspec "Extensions" do |sss|
      sss.summary      = "Extensions"
      sss.source_files = 'Source/iOS/Extensions/*.*'
      sss.frameworks   = 'UIKit'
    end

    ss.subspec "Protocols" do |sss|
      sss.summary      = "Protocols"
      sss.source_files = 'Source/iOS/Protocols/*.*'
      sss.frameworks   = 'UIKit'
    end

    ss.subspec "CollectionViewLayouts" do |sss|
      sss.summary      = "A collection of UICollectionView Layouts"
      sss.source_files = 'Source/iOS/CollectionViewLayouts/*/*.*'
      sss.frameworks   = 'UIKit'
    end

    ss.subspec "Animators" do |sss|
      sss.summary      = "A set of customized view controller transition animators"
      sss.source_files = 'Source/iOS/Animators/*.*'
      sss.frameworks   = 'UIKit'
    end

    ss.subspec "Utility" do |sss|
      sss.summary      = "Handy utility functions"
      sss.source_files = 'Source/iOS/Utility/*.*'
      sss.frameworks   = 'UIKit'
    end

  end



  s.subspec "App-Extension-API-Unsafe" do |ss|
    ss.summary     = "Components which are not app extension compatible"

    # To be added

  end



  s.subspec "UI" do |ss|
    ss.summary     = "UI Views & ViewControllers"

    ss.subspec "AutoLinesLabel" do |sss|
      sss.summary      = "UILabel with contentInset and probide auto lines on iOS7"
      sss.source_files = 'Source/iOS/UI/AutoLinesLabel/*.*'
      sss.frameworks   = 'UIKit'
    end

    ss.subspec "SegmentedControl" do |sss|
      sss.summary      = "Customized Segmented Control, with underscore bars"
      sss.source_files = 'Source/iOS/UI/SegmentedControl/*.*'
      sss.frameworks   = 'UIKit'
    end

    ss.subspec "MenuPageViewController" do |sss|
      sss.summary      = "PageViewController with header titles"
      sss.source_files = 'Source/iOS/UI/MenuPageViewController/*.*'
      sss.frameworks   = 'UIKit'
    end

  end



  s.subspec "UI-App-Extension-API-Unsafe" do |ss|
    ss.summary     = "UI components which are not app extension compatible"

    ss.subspec "SlideController" do |sss|
      sss.summary      = "A left/right slide container view controller"
      sss.source_files = 'Source/iOS/UI/SlideController/*.*'
      sss.frameworks   = 'UIKit'
    end
    
  end

end
