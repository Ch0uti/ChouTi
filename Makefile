# Build.
build:
	@swift package update
	@swift build

# Generate Xcode project and open it.
xcode:
	@osascript -e "tell app \"iPhone Simulator\" to quit"
	@osascript -e "tell app \"Xcode\" to quit"
	@swift package generate-xcodeproj --enable-code-coverage
	@open ./*.xcodeproj

# Run swiftformat.
format:
	@swift run swiftformat .

# Cleanup.
clean:
	@echo "Clean build cache."
	@swift package clean
	@rm -f ./Package.resolved
