Pod::Spec.new do |s|
  s.name             = "ChouTi"
  s.version          = "0.1"
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

  s.ios.deployment_target = "8.0"
  # s.osx.deployment_target = "10.9"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  # s.public_header_files = 'Source/**/**/*.h'
  # s.source_files 	   = 'Source/iOS/**/'

  # s.xcconfig         = { 'OTHER_SWIFT_FLAGS' => '-D DEBUG' }

  s.default_subspecs = "Unsafe"

  s.resource_bundle = { 'Resources' => 'Resources/*/*.png' }

  ############ Summary Subspec ############

  s.subspec "All" do |ss|
    ss.dependency "ChouTi/ChouTi"
    ss.dependency "ChouTi/UI"
    
    # ss.dependency "ChouTi/App-Extension-API-Unsafe"
    ss.dependency "ChouTi/UI-App-Extension-API-Unsafe"

    ss.dependency "ChouTi/ChouTi-Extra"
    ss.dependency "ChouTi/UI-Extra"
  end

  s.subspec "Unsafe" do |ss|
    # 'App extension API not compatible'

    ss.dependency "ChouTi/ChouTi"
    ss.dependency "ChouTi/UI"

    # ss.dependency "ChouTi/App-Extension-API-Unsafe"
    ss.dependency "ChouTi/UI-App-Extension-API-Unsafe"
  end

  s.subspec "Safe" do |ss|
    # "App extension API compatible"

    ss.dependency "ChouTi/ChouTi"
    ss.dependency "ChouTi/UI"
  end

  s.subspec "Deprecated" do |ss|
    ss.dependency "ChouTi/Parse"
  end


  ############ Individual Subspec ############

  s.subspec "ChouTi" do |ss|
    # "Bag of everything."
    ss.source_files = 'Source/iOS/*.swift'

    ss.subspec "Extensions" do |sss|
      sss.source_files = 'Source/iOS/Extensions/**/*.*'
      sss.frameworks   = 'UIKit'
    end

    ss.subspec "Protocols" do |sss|
      sss.source_files = 'Source/iOS/Protocols/**/*.*'
      sss.frameworks   = 'UIKit'
    end

    ss.subspec "CollectionViewLayouts" do |sss|
      # "UICollectionView Layouts"
      sss.source_files = 'Source/iOS/CollectionViewLayouts/**/*.*'
      sss.frameworks   = 'UIKit'
    end

    ss.subspec "Animators" do |sss|
      # "A set of customized view controller transition animators"
      sss.source_files = 'Source/iOS/Animators/**/*.*'
      sss.frameworks   = 'UIKit'
    end

    ss.subspec "Utilities" do |sss|
      # "Handy utility functions/constants"
      sss.source_files = 'Source/iOS/Utilities/**/*.*'

      sss.subspec "TableView+SectionRowExtensions" do |ssss|
        # "Table view sections/rows utility"
        ssss.source_files = 'Source/iOS/Utilities/TableView+SectionRowExtensions/**/*.*'
      end

    end

    ss.subspec "CodeSnippets" do |sss|
      # "Some useful and handy code snippets"
      sss.source_files = 'Source/iOS/CodeSnippets/**/*.*'
    end

  end



  # s.subspec "App-Extension-API-Unsafe" do |ss|
  #  # "Components which are not app extension compatible"
  #
  #  # To be added
  #
  # end



  s.subspec "UI" do |ss|
    # "UI Views & ViewControllers"
    ss.source_files = 'Source/iOS/UI/*.*'

    ss.subspec "AutoLinesLabel" do |sss|
      # "UILabel with contentInset and probide auto lines on iOS7"
      sss.source_files = 'Source/iOS/UI/AutoLinesLabel/*.*'
      sss.frameworks   = 'UIKit'
    end

    ss.subspec "TableViewCells" do |sss|
      # "Customized UITableViewCells"
      sss.source_files = 'Source/iOS/UI/TableViewCells/**/*.*'
      sss.frameworks   = 'UIKit'
    end

    ss.subspec "CollectionViewCells" do |sss|
      # "Customized UICollectionViewCells"
      sss.source_files = 'Source/iOS/UI/CollectionViewCells/*.*'
      sss.frameworks   = 'UIKit'
    end

    ss.subspec "SegmentedControl" do |sss|
      # "Customized Segmented Control, with underscore bars"
      sss.source_files = 'Source/iOS/UI/SegmentedControl/*.*'
      sss.frameworks   = 'UIKit'
    end

    ss.subspec "MenuPageViewController" do |sss|
      # "PageViewController with header titles"
      sss.source_files = 'Source/iOS/UI/MenuPageViewController/*.*'
      sss.frameworks   = 'UIKit'
    end

    ss.subspec "DropDownMenu" do |sss|
      # "A drop down menu presented in full screen with blur background"
      sss.source_files = 'Source/iOS/UI/DropDownMenu/*.*'
      sss.frameworks   = 'UIKit'
    end

    ss.subspec "DatePickerViewController" do |sss|
      # "A slide up date picker view controller"
      sss.source_files = 'Source/iOS/UI/DatePickerViewController/*.*'
      sss.frameworks   = 'UIKit'
    end

    ss.subspec "NavigationBarStatusBar" do |sss|
      # "A drop down status bar under navigation bar"
      sss.source_files = 'Source/iOS/UI/NavigationBarStatusBar/*.*'
      sss.frameworks   = 'UIKit'
    end

  end



  s.subspec "UI-App-Extension-API-Unsafe" do |ss|
    # "UI components which are not app extension compatible"

    ss.subspec "SlideController" do |sss|
      # "A left/right slide container view controller"
      sss.source_files = 'Source/iOS/UI/SlideController/*.*'
      sss.frameworks   = 'UIKit'
    end
    
  end


  ############ Components require Third Party Subspec ############

  s.subspec "ChouTi-Extra" do |ss|

    ss.subspec "Utilities" do |sss|

      sss.subspec "Operations" do |ssss|
        # "NSOperations with Join functionality"
        ssss.source_files = 'Source/iOS/Utilities/Operations/*.*'
        ssss.dependency 'Operations'
      end

    end

  end


  ############ UI Components require Third Party Subspec ############

  s.subspec "UI-Extra" do |ss|
    # "UI Components require Third Party supports"

    ss.subspec "LoadingMorphingLabel" do |sss|
      # "Showing a list of text in loop"
      sss.source_files = 'Source/iOS/UI/LoadingMorphingLabel/*.*'
      sss.frameworks   = 'UIKit'
      sss.dependency 'LTMorphingLabel', '~> 0.0.8'
    end
    
  end



  ############ ChouTi for Third Party Subspec ############

  s.subspec "Parse" do |ss|
    # "Utilities for Parse"

    ss.source_files = 'Source/iOS/ThirdParty/Parse/*.*'
    ss.dependency 'Parse'
    ss.vendored_frameworks = 'Parse'
    
  end
  
end
