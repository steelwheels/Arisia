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
	 && make -f $(script_dir)/install_xc.mk \
	 && rm $(env_file) \
	)

dummy:

