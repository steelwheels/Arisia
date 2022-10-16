# install_xc.mk

install_app: install_macos_app install_ios_app

install_macos_app: dummy
	xcodebuild install \
	  -scheme $(PROJECT_NAME) \
	  -project $(PROJECT_NAME).xcodeproj \
	  -destination="macOSX" \
	  -configuration Release \
	  -sdk macosx \
	  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
	  INSTALL_PATH=$(BIN_PATH) \
	  SKIP_INSTALL=NO \
	  DSTROOT=/ \
	  ONLY_ACTIVE_ARCH=NO

install_ios_app: dummy
	xcodebuild install \
	  -scheme $(PROJECT_NAME)_iOS \
	  -project $(PROJECT_NAME).xcodeproj \
	  -destination="generic/platform=iOS" \
	  -configuration Release \
	  -sdk iphoneos \
	  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
	  INSTALL_PATH=$(BIN_PATH) \
	  SKIP_INSTALL=NO \
	  DSTROOT=/ \
	  ONLY_ACTIVE_ARCH=NO

dummy:

