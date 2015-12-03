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

  s.xcconfig         = { 'OTHER_SWIFT_FLAGS' => '-D DEBUG' }

  s.default_subspecs = "All"

  s.resource_bundle = { 'Resources' => 'Resources/*/*.png' }

  ############ Summary Subspec ############

  s.subspec "All" do |ss|
    ss.summary       = "App extension API not compatible"

    ss.dependency "ChouTi/ChouTi"
    ss.dependency "ChouTi/UI"

    ss.dependency "ChouTi/App-Extension-API-Unsafe"
    ss.dependency "ChouTi/UI-App-Extension-API-Unsafe"

  end

  s.subspec "Safe" do |ss|
    ss.summary       = "App extension API compatible"
    ss.dependency "ChouTi/ChouTi"
    ss.dependency "ChouTi/UI"
  end



  ############ Individual Subspec ############

  s.subspec "ChouTi" do |ss|
    ss.summary		 = "Bag of everything."
    ss.source_files = 'Source/iOS/*.swift'

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
      sss.summary      = "UICollectionView Layouts"
      sss.source_files = 'Source/iOS/CollectionViewLayouts/*/*.*'
      sss.frameworks   = 'UIKit'
    end

    ss.subspec "Animators" do |sss|
      sss.summary      = "A set of customized view controller transition animators"
      sss.source_files = 'Source/iOS/Animators/*.*'
      sss.frameworks   = 'UIKit'
    end

    ss.subspec "Utilities" do |sss|
      sss.summary      = "Handy utility functions/constants"
      sss.source_files = 'Source/iOS/Utilities/*.*'

      sss.subspec "TableViewSectionRow" do |ssss|
        ssss.summary      = "Table view sections/rows utility"
        ssss.source_files = 'Source/iOS/Utilities/TableViewSectionRow/*.*'
      end

    end

    ss.subspec "CodeSnippets" do |sss|
      sss.summary      = "Some useful and handy code snippets"
      sss.source_files = 'Source/iOS/CodeSnippets/*.*'
    end

  end



  s.subspec "App-Extension-API-Unsafe" do |ss|
    ss.summary     = "Components which are not app extension compatible"

    # To be added

  end



  s.subspec "UI" do |ss|
    ss.summary     = "UI Views & ViewControllers"

    ss.source_files = 'Source/iOS/UI/*.*'

    ss.subspec "AutoLinesLabel" do |sss|
      sss.summary      = "UILabel with contentInset and probide auto lines on iOS7"
      sss.source_files = 'Source/iOS/UI/AutoLinesLabel/*.*'
      sss.frameworks   = 'UIKit'
    end

    ss.subspec "TableViewCells" do |sss|
      sss.summary      = "Customized UITableViewCells"
      sss.source_files = 'Source/iOS/UI/TableViewCells/*.*'
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

    ss.subspec "LoadingMorphingLabel" do |sss|
      sss.summary      = "Showing a list of text in loop"
      sss.source_files = 'Source/iOS/UI/LoadingMorphingLabel/*.*'
      sss.frameworks   = 'UIKit'
      sss.dependency 'LTMorphingLabel', '~> 0.0.8'
    end

    ss.subspec "DropDownMenu" do |sss|
      sss.summary      = "A drop down menu presented in full screen with blur background"
      sss.source_files = 'Source/iOS/UI/DropDownMenu/*.*'
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



  ############ ChouTi for Third Party Subspec ############

  s.subspec "Parse" do |ss|
    
    ss.summary     = "Utilities for Parse"
    ss.source_files = 'Source/iOS/ThirdParty/Parse/*.*'
    ss.dependency 'Parse'
    ss.vendored_frameworks = 'Parse'
    
  end
  
end
