# Build.
build:
	@swift package update
	@swift build

# Generate Xcode project and open it.
xcode:
	@swift package generate-xcodeproj
	@open ./ChouTi.xcodeproj

# Run swiftformat.
format:
	@swift run swiftformat .

# Cleanup.
clean:
	@echo "Clean build cache."
	@swift package clean
	@rm -f ./Package.resolved
