#
# Makefile for Library
#

src_scrs	= Frame.ts
src_decls	= Builtin.d.ts $(src_scrs:.ts=.d.ts)

target_scrs	= $(src_scrs:.ts=.js)
target_decl	= AlisiaLibrary.d.ts

tsc	= npx tsc
tsc_opt	= -t ES2017 --lib "es2017" --declaration --declarationDir types \
	  --typeRoots types \
	  --alwaysStrict --strict --strictNullChecks --pretty

%.js: %.ts
	$(tsc) $(tsc_opt) $<

all: $(target_scrs) types/$(target_decl)

clean:
	rm -f $(target_scrs) $(target_decl)

types/$(target_decl): dummy
	(cd types && cat $(src_decls) > $(target_decl))

dummy:

