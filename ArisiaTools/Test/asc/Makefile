#
# Makefile.common: 
#

asc_cmd		= ~/tools/bin/asc
src_dir		= ../src
lib_dir		= ../../../ArisiaComponents/Resource/Library

as_scripts	= empty-frame.as \
		  property-boolean.as \
		  property-number.as \
		  property-string.as \
		  property-array.as \
		  property-dictionary.as \
		  property-enum.as \
		  property-exp.as \
		  property-init.as \
		  property-event.as \
		  property-func.as \
		  property-listner.as \
		  property-frame.as \
		  init-0.as \
		  listner-0.as \
		  table-0.as \
		  collection-0.as

decl_scripts	= $(as_scripts:.as=-if.d.ts)
js_scripts	= $(as_scripts:.as=.js)
ts_scripts	= $(as_scripts:.as=.ts)

tsc	= npx tsc
tsc_opt	= -t ES2017 --lib "es2017" --declaration \
	  --declarationDir $(CURDIR)/types \
	  --typeRoots $(CURDIR)/types \
	  --alwaysStrict --strict --strictNullChecks --pretty

vpath %.as ./src

%.js: %.as
	$(asc_cmd) -f JavaScript $<

%.ts: %.as
	$(asc_cmd) -f TypeScript $<

%-if.d.ts: %.as
	$(asc_cmd) -f TypeDeclaration $<

all: $(js_scripts) $(ts_scripts) $(decl_scripts) check

clean: 
	rm -f $(js_scripts) $(ts_scripts) $(decl_scripts)
	rm -rf compile

check: check_js check_ts

check_js: dummy
	for file in `ls *.js` ; do \
		echo "check: $$file" ; \
		diff $$file ./expected/$$file ; \
	done

check_ts: dummy
	for file in `ls *.ts` ; do \
		echo "check: $$file" ; \
		diff $$file ./expected/$$file ; \
	done

compile: dummy
	mkdir -p compile/types
	cp *.d.ts compile/types
	cp $(lib_dir)/types/ArisiaComponents.d.ts compile/types
	cp *.ts compile
	rm -f compile/Makefile
	(cd compile && ln -s ../Makefile.compile ./Makefile)
	(cd compile && make)

dummy:

