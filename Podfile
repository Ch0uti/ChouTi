platform :ios, '12.0'
use_frameworks!
inhibit_all_warnings!

# Pods

pod 'SwiftLint'

def pods_for_framework
  pod 'LTMorphingLabel', '~> 0.7'
end

def pod_for_testing
  pod 'Quick', '~> 2.1'
  pod 'Nimble', '~> 8.0'
end

# Targets
target 'ChouTi iOS' do
  pods_for_framework
end

target 'ChouTi iOS Tests' do
  pod_for_testing
end

target 'ChouTi Example iOS' do
  pod 'ChouTi', :path => '../'
  pod 'ChouTi/AppExtensionUnsafe', :path => '../'
  pod 'ChouTi/LoadingMorphingLabel', :path => '../'
end

target 'ChouTi Example iOS UITests' do
  pod_for_testing
end
