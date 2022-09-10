# install_all.mk

build_mk = ../../Script/build.mk
tool_mk  = ../../Script/build_tool.mk

all: lib tools

lib: dummy
	(cd ArisiaLibrary/Project && make -f $(build_mk))

tools:
	(cd ArisiaTools/OSX && make -f $(tool_mk))

dummy:

