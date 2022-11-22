# install_all.mk

build_mk = ../../Script/build.mk
tool_mk  = ../../Script/build_tool.mk
app_mk   = ../../Script/build_app.mk

lib_res_dir   =  ArisiaLibrary/Resource/Library/types
comp_res_dir  =  ArisiaComponents/Resource/Library/types
card_res_dir  =  ArisiaCard/Resource/Library/types
tools_res_dir =  ArisiaTools/Resource/Library/types

all: card doc

clean: dummy
	(cd ArisiaLibrary/Resource && make clean)
	(cd ArisiaComponents/Resource && make clean)
	(cd ArisiaTools/Resource && make clean)
	(cd ArisiaCard/Resource && make clean)
	(cd Document && make clean)

card: tools $(card_res_dir)/ArisiaPlatform.d.ts
	(pushd ArisiaCard/Project && make -f $(app_mk) && popd)

doc: dummy
	(cd Document && make)

$(card_res_dir)/ArisiaPlatform.d.ts: $(tools_res_dir)/ArisiaPlatform.d.ts
	cp $< $@

# output library:
#    Resource/Library/types/ArisiaPlatform.d.ts
tools: components $(tools_res_dir)/ArisiaComponents.d.ts
	(pushd ArisiaTools/Project && make -f $(tool_mk) && popd)

$(tools_res_dir)/ArisiaComponents.d.ts: $(comp_res_dir)/ArisiaComponents.d.ts
	cp $< $@

# output library:
#    Resource/Library/types/ArisiaComponents.d.ts
components: lib $(comp_res_dir)/ArisiaLibrary.d.ts
	(pushd ArisiaComponents/Resource && make && popd)
	(pushd ArisiaComponents/Project  && make -f $(build_mk) && popd)

$(comp_res_dir)/ArisiaLibrary.d.ts: $(lib_res_dir)/ArisiaLibrary.d.ts
	cp $< $@

# output library:
#    Resource/Library/types/ArisiaLibrary.d.ts
lib: dummy
	(pushd ArisiaLibrary/Resource && make && popd)
	(pushd ArisiaLibrary/Project && make -f $(build_mk) && popd)

dummy:

