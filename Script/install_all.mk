# install_all.mk

build_mk = ../../Script/build.mk
tool_mk  = ../../Script/build_tool.mk
app_mk   = ../../Script/build_app.mk

lib_res_dir  =  ArisiaLibrary/Resource/Library/types
comp_res_dir =  ArisiaComponents/Resource/Library/types

all: lib doc components tools card

lib: dummy
	(pushd ArisiaLibrary/Project && make -f $(build_mk) && popd)
	(pushd ArisiaLibrary/Resource && make && popd)

doc: dummy
	(pushd ArisiaLibrary/Resource && make && popd)
	(pushd ArisiaComponents/Resource && make && popd)
	(pushd ArisiaCard/Resource && make && popd)
	(pushd ArisiaCard/Document && make && popd)
	(pushd Document/Components && make && popd)


components: $(comp_res_dir)/ArisiaLibrary.d.ts dummy
	(pushd ArisiaComponents/Project && make -f $(build_mk) && popd)
	(pushd ArisiaComponents/Resource/Library && make && popd)

$(comp_res_dir)/ArisiaLibrary.d.ts: $(lib_res_dir)/ArisiaLibrary.d.ts
	cp $< $@

tools: dummy
	(pushd ArisiaTools/Project && make -f $(tool_mk) && popd)

card: dummy
	(pushd ArisiaCard/Project && make -f $(app_mk) && popd)

dummy:

