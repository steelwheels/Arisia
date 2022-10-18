#
# Makefile.inc
#

tsc	= npx tsc
tsc_opt	= -t ES2017 --lib "es2017" --declaration --declarationDir types \
	  --typeRoots types \
	  --alwaysStrict --strict --strictNullChecks --pretty

asc_cmd   = ~/tools/bin/asc
adecl_cmd = ~/tools/bin/adecl

%.js: %.ts
	$(tsc) $(tsc_opt) $<

%.ts: %.as
	$(asc_cmd) -f TypeScript $<

%-if.d.ts: %.as
	$(asc_cmd) -f TypeDeclaration $<
