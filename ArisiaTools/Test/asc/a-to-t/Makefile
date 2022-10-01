#
# Makefile: Test for asc command
#

include ../Makefile.common

vpath %.as $(src_dir)

all: decls $(ts_scripts)
	for file in `ls *.ts` ; do \
		echo "file; $${file}" ; \
		$(tsc) $(tsc_opt) $$file ; \
	done

#diff $$file expected/$$file ;

clean:
	rm -f $(ts_scripts) $(js_scripts)
	(cd types && rm -f $(decl_scripts))

decls:	types/KiwiLibrary.d.ts types/ArisiaLibrary.d.ts \
	types/ArisiaComponents.d.ts

types/KiwiLibrary.d.ts: $(lib_dir)/types/KiwiLibrary.d.ts
	cp $< $@

types/ArisiaLibrary.d.ts: $(lib_dir)/types/ArisiaLibrary.d.ts
	cp $< $@

types/ArisiaComponents.d.ts: $(lib_dir)/types/ArisiaComponents.d.ts
	cp $< $@

dummy:

