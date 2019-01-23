build:
	@swift package update
	@swift build

xcode:
	@swift package generate-xcodeproj
	@open ./ChouTi.xcodeproj