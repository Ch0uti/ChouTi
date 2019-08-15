bootstrap:
	@echo "Install fastlane..."
	@sudo gem install fastlane
	@sudo brew install carthage
	@sudo brew install xcodegen
	@Scripts/bootstrap.sh

carthage:
	@carthage update --platform ios,tvos

xcodegen:
	@xcodegen generate --spec .project.yml
	@open ChouTi.xcodeproj

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
