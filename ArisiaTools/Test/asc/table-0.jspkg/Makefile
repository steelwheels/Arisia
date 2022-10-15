#
#
#

tsc	= npx tsc
tsc_opt	= -t ES2017 --lib "es2017" --declaration \
	  --declarationDir $(CURDIR)/types \
	  --typeRoots $(CURDIR)/types \
	  --alwaysStrict --strict --strictNullChecks --pretty

%.js: %.as
	$(asc_cmd) -f JavaScript $<

%.ts: %.as
	$(asc_cmd) -f TypeScript $<

%.js: %.ts
	$(tsc) $(tsc_opt) $<

%-if.d.ts: %.as
	$(asc_cmd) -f TypeDeclaration $<

srcs = main.ts
dsts = $(srcs:.ts=.js)

all: $(dsts)

clean:
	rm -f $(dsts)

