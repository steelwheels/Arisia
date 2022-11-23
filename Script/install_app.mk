# install_xc.mk

PROJECT_NAME ?= ArisiaCard
INSTALL_PATH ?= /Applications

install_app: macos ios

macos: dummy
	xcodebuild install \
	  -scheme $(PROJECT_NAME) \
	  -project $(PROJECT_NAME).xcodeproj \
	  -destination="macOSX" \
	  -configuration Release \
	  -sdk macosx \
	  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
	  SKIP_INSTALL=NO \
	  DSTROOT=/ \
	  ONLY_ACTIVE_ARCH=NO

ios: dummy
	xcodebuild install \
	  -scheme $(PROJECT_NAME)_iOS \
	  -project $(PROJECT_NAME).xcodeproj \
	  -destination="generic/platform=iOS" \
	  -configuration Release \
	  -sdk iphoneos \
	  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
	  SKIP_INSTALL=NO \
	  DSTROOT=/ \
	  ONLY_ACTIVE_ARCH=NO

dummy:

