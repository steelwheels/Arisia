#
# Makefile
#

PROJECT_DIR	?= .

res_dir	= $(PROJECT_DIR)/../Resource

all: dummy
	(cd $(res_dir)/Home.jspkg && make)
	(cd $(res_dir)/Samples && make)
	(cd $(res_dir)/Applications && make)

clean: dummy
	(cd $(res_dir)/Home.jspkg && make clean)
	(cd $(res_dir)/Samples && make clean)
	(cd $(res_dir)/Applications && make clean)

dummy:

