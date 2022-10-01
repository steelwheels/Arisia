#
# Makefile: Test for asc command
#

include ../Makefile.common

vpath %.as $(src_dir)

all: decls $(js_scripts) check

clean:
	rm -f $(js_scripts) 

check: dummy
	for file in `ls *.js` ; do \
		echo "file; $${file}" ; \
		diff $$file expected/$$file ; \
	done

decls: types/KiwiLibrary.d.ts types/ArisiaLibrary.d.ts

types/KiwiLibrary.d.ts: $(lib_dir)/types/KiwiLibrary.d.ts
	cp $< $@

types/ArisiaLibrary.d.ts: $(lib_dir)/types/ArisiaLibrary.d.ts
	cp $< $@

dummy:

