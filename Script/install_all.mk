# install_all.mk

build_mk = ../../Script/build.mk
tool_mk  = ../../Script/build_tool.mk

lib_res_dir  =  ArisiaLibrary/Resource/Library/types
comp_res_dir =  ArisiaComponents/Resource/Library/types

all: lib components tools

lib: dummy
	(pushd ArisiaLibrary/Project && make -f $(build_mk) && popd)
	(pushd ArisiaLibrary/Resource && make && popd)

components: $(comp_res_dir)/ArisiaLibrary.d.ts dummy
	(pushd ArisiaComponents/Project && make -f $(build_mk) && popd)
	(pushd ArisiaComponents/Resource/Library && make && popd)

$(comp_res_dir)/ArisiaLibrary.d.ts: $(lib_res_dir)/ArisiaLibrary.d.ts
	cp $< $@

tools: dummy
	(pushd ArisiaTools/Project && make -f $(tool_mk) && popd)

dummy:

