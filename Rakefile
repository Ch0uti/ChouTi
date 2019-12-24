require 'bundler/setup'

XCODE_VERSION="Xcode 11.1"
SWIFT_VERSION="Apple Swift version 5.1"
PROJECT="ChouTi.xcodeproj"
IOS_FRAMEWORK_SCHEME="ChouTi_iOS"
IOS_EXAMPLE_SCHEME="ChouTi Example iOS"
DESTINATION="OS=13.1,name=iPhone 11 Pro"

begin
  xcodebuild_version = `xcodebuild -version`
  raise "Incorrect Xcode version installed. This project uses #{XCODE_VERSION}, current Xcode version: #{xcodebuild_version} " if (xcodebuild_version <=> XCODE_VERSION) != 1

  swift_version = `xcrun swiftc --version`
  raise "Incorrect Swift version installed. This project uses #{SWIFT_VERSION}, current Swift version: #{swift_version}" if (swift_version <=> SWIFT_VERSION) != 1

  tools = `gem which bundler`
  raise "You must have bundler. `gem install bundler`" if $?.exitstatus != 0
end

task :default do
  # Check the build Environment
  `bundle check > /dev/null`
  if $?.exitstatus != 0
    sh "rake setup"
  end
end

#-------------------------------------------------------------------------------
# Update Dependencies
#-------------------------------------------------------------------------------

desc "Update Carthage."
task :update_carthage do
  puts "*** Update Carthage Dependencies ***"
  sh "carthage update --platform ios,tvos"
end

#-------------------------------------------------------------------------------
# Setup Environment
#-------------------------------------------------------------------------------

desc "Generate Xcode project."
task :xcode do
  sh "xcodegen generate --spec .project.yml"
  if ENV['no_open'] != "true"
    sh "open #{PROJECT}"
  end
end

#-------------------------------------------------------------------------------
# Development Tasks
#-------------------------------------------------------------------------------

desc "Build for Debug."
task :build do
  sh "xcodebuild clean build -project '#{PROJECT}' -scheme '#{IOS_FRAMEWORK_SCHEME}' -destination '#{DESTINATION}' -configuration Debug | bundle exec xcpretty"
end

desc "Build for Release."
task :build_release do
  sh "xcodebuild clean build -project '#{PROJECT}' -scheme '#{IOS_FRAMEWORK_SCHEME}' -destination '#{DESTINATION}' -configuration Release | bundle exec xcpretty"
end

desc "Run framework tests."
task :test do
  sh "xcodebuild clean test -project '#{PROJECT}' -scheme '#{IOS_FRAMEWORK_SCHEME}' -destination '#{DESTINATION}' -configuration Debug | bundle exec xcpretty"
end

desc "Format Swift code."
task :format do
  sh "swift run swiftformat ."
end

#-------------------------------------------------------------------------------
# Publish Pod
#-------------------------------------------------------------------------------

desc "Lint pod locally."
task :pod_lib_lint do
  sh "bundle exec pod cache clean --all --verbose"
  sh "bundle exec pod lib lint ./ChouTi.podspec --verbose"
end

desc "Lint pod remotely."
task :pod_spec_lint do
  sh "bundle exec pod cache clean --all --verbose"
  sh "bundle exec pod spec lint ./ChouTi.podspec --verbose"
end

desc "Publish pod."
task :pod_publish do
  sh "bundle exec pod cache clean --all --verbose"
  sh "bundle exec pod trunk push ./ChouTi.podspec --verbose"
end

#-------------------------------------------------------------------------------
# Clean
#-------------------------------------------------------------------------------

desc "Clean Xcodes derived data."
task :clean do
  puts "*** Cleaning Derived Data ***"
  sh "rm -rf ~/Library/Developer/Xcode/DerivedData/ChouTi-*"

  puts "*** Cleaning Module Cache ***"
  sh "rm -rf ~/Library/Developer/Xcode/DerivedData/ModuleCache"
end

#-------------------------------------------------------------------------------
# Doc
#-------------------------------------------------------------------------------

desc "Generate documentations"
task :doc do
  sh "bundle exec jazzy"
end
