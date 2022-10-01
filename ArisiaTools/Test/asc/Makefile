#
# Makefile: Test for asc command
#

asc		= ~/tools/bin/asc
script_dir	= ./scripts
lib_dir		= ../../../ArisiaLibrary/Resource/Library

as_scripts	= empty-frame.as \
		  property-boolean.as \
		  property-number.as \
		  property-string.as \
		  property-array.as \
		  property-dictionary.as \
		  property-enum.as \
		  property-init.as \
		  property-func.as \
		  property-listner.as \
		  property-frame.as \
		  init-0.as \
		  listner-0.as

decl_scripts	= $(as_scripts:.as=.d.ts)
js_scripts	= $(as_scripts:.as=.js)
ts_scripts	= $(as_scripts:.as=.ts)

tsc	= npx tsc
tsc_opt	= -t ES2017 --lib "es2017" --declaration \
	  --declarationDir $(CURDIR)/types \
	  --typeRoots $(CURDIR)/types \
	  --alwaysStrict --strict --strictNullChecks --pretty

%.js: %.as
	$(asc) -c $< > $@

%.ts: %.as
	$(asc) -c -l TypeScript $< > $@

all: decls $(js_scripts) $(ts_scripts) check

clean:
	rm -f $(js_scripts) $(ts_scripts) 
	(cd ./types && rm -f $(decl_scripts))

check: dummy
	for file in `ls *.[jt]s` ; do \
		echo "file; $${file}" ; \
		diff $$file expected/$$file ; \
	done

decls: types/KiwiLibrary.d.ts types/ArisiaLibrary.d.ts

types/KiwiLibrary.d.ts: $(lib_dir)/types/KiwiLibrary.d.ts
	cp $< $@

types/ArisiaLibrary.d.ts: $(lib_dir)/types/ArisiaLibrary.d.ts
	cp $< $@

dummy:

