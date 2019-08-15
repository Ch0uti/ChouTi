require 'bundler/setup'
require 'colorize'

XCODE_VERSION="Xcode 10.3"
SWIFT_VERSION="Apple Swift version 5.0"
PROJECT="ChouTi.xcodeproj"
IOS_FRAMEWORK_SCHEME="ChouTi_iOS"
IOS_EXAMPLE_SCHEME="ChouTi Example iOS"
DESTINATION="OS=12.4,name=iPhone Xs"

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
# Setup Environment
#-------------------------------------------------------------------------------

desc "Generate Xcode project."
task :xcode do
  sh "xcodegen generate --spec .project.yml"
  if ENV['no_open'] != "true"
    sh "open ChouTi.xcodeproj"
  end
end

#-------------------------------------------------------------------------------
# Development Tasks
#-------------------------------------------------------------------------------

desc "Build for Debug and Release."

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

desc "Lint Swift code."
task :lint do
  sh "swiftlint --path ./Sources"
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
# Update Dependencies
#-------------------------------------------------------------------------------

desc "Update Carthage."
task :update_carthage do
  puts "*** Update Carthage Dependencies ***".colorize(:light_blue)
  sh "carthage update --platform ios,tvos"
end

#-------------------------------------------------------------------------------
# Clean
#-------------------------------------------------------------------------------

desc "Clean Xcodes derived data."
task :clean do
  puts "*** Cleaning Derived Data ***".colorize(:red)
  sh "rm -rf ~/Library/Developer/Xcode/DerivedData/ChouTi-*"

  puts "*** Cleaning Module Cache ***".colorize(:red)
  sh "rm -rf ~/Library/Developer/Xcode/DerivedData/ModuleCache"
end

#-------------------------------------------------------------------------------
# Doc
#-------------------------------------------------------------------------------

desc "Generate documentations"
task :doc do
  sh "bundle exec jazzy"
end
