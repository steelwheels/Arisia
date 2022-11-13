#
#
#

script_dir	= ../../Script
env_file	= xcode_sets.env

all: dummy
	( \
	    bash $(script_dir)/export_env.sh $(env_file) \
	 && source ${env_file} \
	 && echo "PROJECT_NAME=$$PROJECT_NAME" \
	 && make -f $(script_dir)/install_tool.mk \
		install_bundle install_tools install_decls \
	 && rm $(env_file) \
	)

dummy:

