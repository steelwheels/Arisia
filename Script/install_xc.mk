# install_xc.mk

INSTALL_PATH 		?= $(HOME)/local/Frameworks

INSTALL_PATH_MACOS	= $(INSTALL_PATH)/macos
INSTALL_PATH_IOS	= $(INSTALL_PATH)/iphoneos
INSTALL_PATH_IOSSIM	= $(INSTALL_PATH)/iphonesimulator

all: pack_os
	echo "done"

pack_os: install_osx install_ios install_ios_sim
	(cd $(HOME)/Library/Frameworks ; rm -rf $(PROJECT_NAME).xcframework)
	xcodebuild -create-xcframework \
	  -framework $(INSTALL_PATH_MACOS)/$(PROJECT_NAME).framework \
	  -framework $(INSTALL_PATH_IOS)/$(PROJECT_NAME).framework \
	  -framework $(INSTALL_PATH_IOSSIM)/$(PROJECT_NAME).framework \
	  -output $(HOME)/Library/Frameworks/$(PROJECT_NAME).xcframework

install_osx: dummy
	xcodebuild archive \
	  -scheme $(PROJECT_NAME)_macOS \
	  -project $(PROJECT_NAME).xcodeproj \
	  -destination="macOSX" \
	  -configuration Release \
	  -sdk macosx \
	  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
	  INSTALL_PATH=$(INSTALL_PATH_MACOS) \
	  SKIP_INSTALL=NO \
	  DSTROOT=/ \
	  ONLY_ACTIVE_ARCH=NO

install_ios: dummy
	xcodebuild archive \
	  -scheme $(PROJECT_NAME)_iOS \
	  -project $(PROJECT_NAME).xcodeproj \
	  -destination="iOS" \
	  -configuration Release \
	  -sdk iphoneos \
	  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
	  INSTALL_PATH=$(INSTALL_PATH_IOS) \
	  SKIP_INSTALL=NO \
	  DSTROOT=/ \
	  ONLY_ACTIVE_ARCH=NO

install_ios_sim: dummy
	xcodebuild archive \
	  -scheme $(PROJECT_NAME)_iOS \
	  -project $(PROJECT_NAME).xcodeproj \
	  -destination="iOS Simulator" \
	  -configuration Release \
	  -sdk iphonesimulator \
	  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
	  INSTALL_PATH=$(INSTALL_PATH_IOSSIM) \
	  SKIP_INSTALL=NO \
	  DSTROOT=/ \
	  ONLY_ACTIVE_ARCH=NO

dummy:

