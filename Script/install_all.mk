# install_all.mk

build_mk = ../../Script/build.mk

all:
	(cd ArisiaLibrary/Project && make -f $(build_mk))

