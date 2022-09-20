# install_all.mk

build_mk = ../../Script/build.mk
tool_mk  = ../../Script/build_tool.mk

all: lib components tools

lib: dummy
	(cd ArisiaLibrary/Project && make -f $(build_mk))

components: dummy
	#(cd ArisiaComponents/Project && make -f $(build_mk))

tools: dummy
	(cd ArisiaTools/Project && make -f $(tool_mk))

dummy:

