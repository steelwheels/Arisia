# install_xc.mk

BUNDLE_PATH	= $(HOME)/tools/bundles
BIN_PATH	= $(HOME)/tools/bin

all: dummy
	echo "usage: make install_bundle or make install_tool"

install_bundle: dummy
	xcodebuild install \
	  -scheme $(PROJECT_NAME)Bundle \
	  -project $(PROJECT_NAME).xcodeproj \
	  -destination="macOSX" \
	  -configuration Release \
	  -sdk macosx \
	  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
	  INSTALL_PATH=$(BUNDLE_PATH) \
	  SKIP_INSTALL=NO \
	  DSTROOT=/ \
	  ONLY_ACTIVE_ARCH=NO

install_tools: install_asc install_adecl

install_asc: dummy
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

install_adecl: dummy
	xcodebuild install \
	  -scheme adecl \
	  -project $(PROJECT_NAME).xcodeproj \
	  -destination="macOSX" \
	  -configuration Release \
	  -sdk macosx \
	  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
	  INSTALL_PATH=$(BIN_PATH) \
	  SKIP_INSTALL=NO \
	  DSTROOT=/ \
	  ONLY_ACTIVE_ARCH=NO

dummy:

