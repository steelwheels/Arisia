#
# Makefile
#

src_scr 	= window.ts
bltin_decl	= Button.d.ts \
		  Box.d.ts \
		  TableData.d.ts \
	  	  window.d.ts
dst_scr		= $(src_scr:.ts=.js)
dst_decl	= $(src_scr:.ts=.d.ts)
target		= types/ArisiaComponents.d.ts

tsc	= npx tsc
tsc_opt	= -t ES2017 --lib "es2017" --declaration --declarationDir types \
	  --typeRoots types \
	  --alwaysStrict --strict --strictNullChecks --pretty

adecl_cmd = ~/tools/bin/adecl

vpath %.d.ts types

%.js: %.ts
	$(tsc) $(tsc_opt) $<

all: $(target)

clean:
	rm -f $(target) $(dst_scr)
	(cd types && rm -f $(bltin_decl))
	(cd types && rm -f $(dst_decl))

$(target): types/ArisiaLibrary.d.ts types/Builtin.d.ts dst_decl bltin_decl 
	cat types/ArisiaLibrary.d.ts	>  $(target)
	cat types/Builtin.d.ts		>>  $(target)
	(cd types && cat $(bltin_decl))	>> $(target)
	(cd types && cat $(dst_decl))	>> $(target)

dst_decl: $(dst_scr)

bltin_decl: dummy
	if [ -x $(adecl_cmd) ] ; then \
		(cd types && $(adecl_cmd)) ; \
	fi 

dummy:

