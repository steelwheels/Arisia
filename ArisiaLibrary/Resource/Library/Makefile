#
# Makefile for Library
#

src_scrs	= Transpiler.ts
bltin_decl	= Frame.d.ts
dst_scrs	= $(src_scrs:.ts=.js)
dst_decls	= $(src_scrs:.ts=.d.ts)

target		= types/ArisiaLibrary.d.ts

tsc	= npx tsc
tsc_opt	= -t ES2017 --lib "es2017" --declaration --declarationDir types \
	  --typeRoots types \
	  --alwaysStrict --strict --strictNullChecks --pretty

%.js: %.ts
	$(tsc) $(tsc_opt) $<

adecl_cmd = ~/tools/bin/adecl

all: $(target)

clean:
	rm -f $(target) $(dst_scrs)
	(cd types && rm -f $(bltin_decl) $(dst_decls))

$(target): bltin_decl decls types/Builtin.d.ts types/KiwiLibrary.d.ts
	cat types/KiwiLibrary.d.ts 	>  $(target)
	cat types/Builtin.d.ts     	>> $(target)
	(cd types && cat $(bltin_decl))	>> $(target)
	(cd types && cat $(dst_decls))	>> $(target)

bltin_decl: dummy
	if [ -x $(adecl_cmd) ] ; then \
		(cd types && $(adecl_cmd) Frame) ; \
	fi

decls: $(dst_scrs)

dummy:

