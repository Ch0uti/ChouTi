bootstrap:
	@Scripts/bootstrap.sh

# SPM Build.
build:
	@swift package update
	@swift build

# Generate SPM Xcode project and open it.
xcode:
	@swift package generate-xcodeproj --enable-code-coverage --output ChouTi-SPM.xcodeproj
	@open ChouTi-SPM.xcodeproj

# SPM Cleanup.
clean:
	@echo "Clean build cache."
	@swift package clean
	@rm -f ./Package.resolved
