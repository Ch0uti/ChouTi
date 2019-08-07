bootstrap:
	@echo "Install fastlane..."
	@sudo gem install fastlane
	@Scripts/bootstrap.sh

# Build.
build:
	@swift package update
	@swift build

# Generate Xcode project and open it.
xcode:
	@swift package generate-xcodeproj --enable-code-coverage --output ChouTi-SPM.xcodeproj
	@open ChouTi-SPM.xcodeproj

# Run swiftformat.
format:
	@swift run swiftformat .

doc:
	@bundle exec jazzy

# Cleanup.
clean:
	@echo "Clean build cache."
	@swift package clean
	@rm -f ./Package.resolved