#
# Makefile
#

src_scr 	= Alloc.ts
src_decl	= ButtonView.d.ts \
	  	  Frame.d.ts \
	  	  RootView.d.ts \
	  	  StackView.d.ts \
	  	  Alloc.d.ts
dst_scr		= $(src_scr:.ts=.js)
dst_decl	= types/ArisiaComponents.d.ts

tsc	= npx tsc
tsc_opt	= -t ES2017 --lib "es2017" --declaration --declarationDir types \
	  --typeRoots types \
	  --alwaysStrict --strict --strictNullChecks --pretty

adecl_cmd = ~/tools/bin/adecl

vpath %.d.ts types

%.js: %.ts
	$(tsc) $(tsc_opt) $<

all: $(dst_scr) $(dst_decl)

clean:
	rm -f $(dsts) 
	(cd types && make clean)

$(dst_decl): dummy
	if [ -x $(adecl_cmd) ] ; then \
		(cd types && $(adecl_cmd)) ; \
	fi 
	(cd types && cat $(src_decl)) > $(dst_decl)

dummy:

