Pod::Spec.new do |s|
  s.name             = "ChouTi"
  s.version          = "0.2"
  s.summary          = "Chou Ti (抽屉) - A toolkit for iOS/OSX development."
  s.description      = <<-DESC
                       Chou Ti (抽屉) - My personal toolkit for iOS/OSX development.
                       It contains common classes, extensions used in multiple projects

                       DESC
  s.homepage         = "https://github.com/honghaoz/ChouTi"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Honghao Zhang" => "zhh358@gmail.com" }
  s.source           = { :git => "https://github.com/honghaoz/ChouTi.git", :tag => s.version.to_s }

  s.platform     	   = :ios, '9.0'
  s.requires_arc 	   = true

  s.ios.deployment_target = "9.0"


  # s.pod_target_xcconfig = {
  #   'OTHER_SWIFT_FLAGS[config=Debug]' => '-D DEBUG'
  # }

  s.default_subspecs = [
    "Core",
    "Animators",
    "CollectionViewLayouts",
    "UI",
    "Utilities"
  ]

  s.subspec "All" do |ss|
    ss.dependency "ChouTi/Core"
    ss.dependency "ChouTi/Animators"
    ss.dependency "ChouTi/CollectionViewLayouts"
    ss.dependency "ChouTi/UI"
    ss.dependency "ChouTi/Utilities"

    # Not compatible with extensions
    ss.dependency "ChouTi/UI-App-Extension-API-Unsafe"

    # Requires third party dependencies
    ss.dependency "ChouTi/ThirdParty"
  end

  s.subspec "Core" do |ss|

    ss.subspec "CodeSnippets" do |sss|
      sss.source_files = 'ChouTi/Source/iOS/Core/CodeSnippets/**/*.*'
    end

    ss.subspec "DataStructure" do |sss|
      sss.source_files = 'ChouTi/Source/iOS/Core/DataStructure/**/*.*'
    end

    ss.subspec "Extensions" do |sss|
      sss.source_files = 'ChouTi/Source/iOS/Core/Extensions/**/*.*'
    end

    ss.subspec "Miscellaneous" do |sss|
      sss.source_files = 'ChouTi/Source/iOS/Core/Miscellaneous/**/*.*'
    end

    ss.subspec "Protocols" do |sss|
      sss.source_files = 'ChouTi/Source/iOS/Core/Protocols/**/*.*'
    end

    ss.subspec "UI" do |sss|
      sss.source_files = [
        'ChouTi/Source/iOS/Core/UI/*.*',
        'ChouTi/Source/iOS/Core/DataStructure/**/*.*',
        'ChouTi/Source/iOS/Core/Extensions/**/*.*',
        'ChouTi/Source/iOS/Core/Miscellaneous/**/*.*',
        'ChouTi/Source/iOS/Core/Protocols/**/*.*'
      ]

      sss.subspec "TableViewCells" do |ssss|
        ssss.source_files = [
          'ChouTi/Source/iOS/Core/UI/TableViewCells/**/*.*',
          'ChouTi/Source/iOS/Core/UI/*.*',
          'ChouTi/Source/iOS/Core/DataStructure/**/*.*',
          'ChouTi/Source/iOS/Core/Extensions/**/*.*',
          'ChouTi/Source/iOS/Core/Miscellaneous/**/*.*',
          'ChouTi/Source/iOS/Core/Protocols/**/*.*'
        ]
      end

      sss.subspec "CollectionViewCells" do |ssss|
        ssss.source_files = [
          'ChouTi/Source/iOS/Core/UI/CollectionViewCells/**/*.*',
          'ChouTi/Source/iOS/Core/UI/*.*',
          'ChouTi/Source/iOS/Core/DataStructure/**/*.*',
          'ChouTi/Source/iOS/Core/Extensions/**/*.*',
          'ChouTi/Source/iOS/Core/Miscellaneous/**/*.*',
          'ChouTi/Source/iOS/Core/Protocols/**/*.*'
        ]
      end
    end
  end

  s.subspec "Animators" do |ss|
    # "A set of customized view controller transition animators"
    ss.source_files = 'ChouTi/Source/iOS/Animators/*.*'
    ss.dependency "ChouTi/Core"

    ss.subspec "DropPresentingAnimator" do |sss|
      sss.source_files = [
        'ChouTi/Source/iOS/Animators/DropPresentingAnimator/**/*.*',
        'ChouTi/Source/iOS/Animators/*.*'
      ]
    end
  end

  s.subspec "CollectionViewLayouts" do |ss|
    # "UICollectionView Layouts"
    # ss.source_files = 'ChouTi/Source/iOS/CollectionViewLayouts/*.*'
    ss.dependency "ChouTi/Core"

    ss.subspec "TableLayout" do |sss|
      # "Grid Layout, like Excel/Number"
      sss.source_files = 'ChouTi/Source/iOS/CollectionViewLayouts/**/*.*'
    end
  end

  s.subspec "UI" do |ss|
    # "UI Views & ViewControllers"
    ss.source_files = 'ChouTi/Source/iOS/UI/*.*'
    ss.resource_bundle = { 'Resources' => 'Resources/**/*.png' }
    ss.dependency "ChouTi/Core"

    ss.subspec "AlertView" do |sss|
      # "Mimic UIAlertController's view"
      sss.source_files = 'ChouTi/Source/iOS/UI/AlertView/*.swift'
      ss.dependency "ChouTi/Animators"
    end

    ss.subspec "AutoLinesLabel" do |sss|
      # "UILabel with contentInset and probide auto lines on iOS7"
      sss.source_files = 'ChouTi/Source/iOS/UI/AutoLinesLabel/*.*'
    end

    ss.subspec "CollectionViewCells" do |sss|
      # "Customized UICollectionViewCells"
      # sss.source_files = 'ChouTi/Source/iOS/UI/CollectionViewCells/*.*'
    end

    ss.subspec "DatePickerViewController" do |sss|
      # "A slide up date picker view controller"
      sss.source_files = 'ChouTi/Source/iOS/UI/DatePickerViewController/*.*'
      ss.dependency "ChouTi/Animators"
    end

    ss.subspec "DropDownMenu" do |sss|
      # "A drop down menu presented in full screen with blur background"
      sss.source_files = 'ChouTi/Source/iOS/UI/DropDownMenu/*.*'
      ss.dependency "ChouTi/Animators"
    end

    ss.subspec "MenuPageViewController" do |sss|
      # "PageViewController with header titles"
      sss.source_files = 'ChouTi/Source/iOS/UI/MenuPageViewController/*.*'
    end

    ss.subspec "NavigationBarStatusBar" do |sss|
      # "A drop down status bar under navigation bar"
      sss.source_files = 'ChouTi/Source/iOS/UI/NavigationBarStatusBar/*.*'
    end

    ss.subspec "SegmentedControl" do |sss|
      # "Customized Segmented Control, with underscore bars"
      sss.source_files = 'ChouTi/Source/iOS/UI/SegmentedControl/*.*'
    end

    ss.subspec "TableViewCells" do |sss|
      # "Customized UITableViewCells"
      sss.source_files = 'ChouTi/Source/iOS/UI/TableViewCells/**/*.*'
    end
  end

  s.subspec "UI-App-Extension-API-Unsafe" do |ss|
    # "UI components which are not app extension compatible"
    ss.dependency "ChouTi/Core"

    ss.subspec "SlideController" do |sss|
      # "A left/right slide container view controller"
      sss.source_files = 'ChouTi/Source/iOS/UI/SlideController/*.*'
    end
  end

  s.subspec "Utilities" do |ss|
    ss.dependency "ChouTi/Core"

    ss.subspec "TableView+SectionRowExtensions" do |sss|
      sss.source_files = 'ChouTi/Source/iOS/Utilities/TableView+SectionRowExtensions/*.*'
    end
  end

  s.subspec "ThirdParty" do |ss|
    # "Code for third party"

    ss.subspec "Parse" do |sss|
      # "Extensions on Parse"
      sss.source_files = 'ChouTi/Source/iOS/ThirdParty/Parse/*.*'
      sss.dependency 'Parse'
    end

    ss.subspec "LoadingMorphingLabel" do |sss|
      # "Showing a list of text in loop"
      sss.source_files = 'ChouTi/Source/iOS/ThirdParty/LoadingMorphingLabel/*.*'
      sss.dependency 'LTMorphingLabel'
    end
  end

end
