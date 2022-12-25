#
# Makefile
#

src_scr 	= panel.ts \
		  window.ts
dst_scrs	= $(src_scr:.ts=.js)

src_decls	= types/ArisiaLibrary.d.ts \
		  types/Builtin.d.ts \
		  types/panel.d.ts \
		  types/window.d.ts
dst_decl	= types/ArisiaComponents.d.ts 

tsc	= npx tsc
tsc_opt	= -t ES2017 --lib "es2017" --declaration --declarationDir types \
	  --typeRoots types \
	  --alwaysStrict --strict --strictNullChecks --pretty

%.js: %.ts
	$(tsc) $(tsc_opt) $<

all: $(dst_scrs) $(dst_decl)

clean:
	rm -f $(dst_scrs) $(dst_decl)

$(dst_decl): $(src_decls)
	cat $(src_decls) > $(dst_decl)

