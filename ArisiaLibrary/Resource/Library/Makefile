#
# Makefile for Library
#

src_scrs	= Transpiler.ts
dst_scrs	= $(src_scrs:.ts=.js)
dst_decls	= $(src_scrs:.ts=.d.ts)
targ_decl	= types/ArisiaLibrary.d.ts

tsc	= npx tsc
tsc_opt	= -t ES2017 --lib "es2017" --declaration --declarationDir types \
	  --typeRoots types \
	  --alwaysStrict --strict --strictNullChecks --pretty

%.js: %.ts
	$(tsc) $(tsc_opt) $<

all: $(dst_scrs) $(targ_decl)

clean:
	rm -f $(dst_scrs) $(dst_decls) $(targ_decl)

$(targ_decl): types/Builtin.d.ts
	(cd types && cat Builtin.d.ts $(dst_decls)) > $(targ_decl)

dummy:

