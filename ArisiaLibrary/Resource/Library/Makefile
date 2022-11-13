#
# Makefile for Library
#

src_decls	= types/KiwiLibrary.d.ts \
		  types/Builtin.d.ts \
		  types/Frame.d.ts
dst_decl	= types/ArisiaLibrary.d.ts

src_scrs	= Transpiler.ts
dst_scrs	= $(src_scrs:.ts=.js)

tsc	= npx tsc
tsc_opt	= -t ES2017 --lib "es2017" --declaration --declarationDir types \
	  --typeRoots types \
	  --alwaysStrict --strict --strictNullChecks --pretty

%.js: %.ts
	$(tsc) $(tsc_opt) $<

all: $(dst_decl) $(dst_scrs)

clean:
	rm -f $(dst_decl) $(dst_scrs)

$(dst_decl): $(src_decls) types/Transpiler.d.ts
	cat $(src_decls) types/Transpiler.d.ts > $@

types/Transpiler.d.ts: $(dst_scrs)

