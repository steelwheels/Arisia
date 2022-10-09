#
# Makefile
#

asc_cmd	= ~/tools/bin/asc

top_dir		= ../../../..

src_as		= main_view.as \
		  button.as
src_ts		= main.ts
dst_ts		= $(src_as:.as=.ts)
dst_js		= $(src_as:.as=.js) main.js

tsc	= npx tsc
tsc_opt	= -t ES2017 --lib "es2017" --declaration \
	  --declarationDir $(CURDIR)/types \
	  --typeRoots $(CURDIR)/types \
	  --alwaysStrict --strict --strictNullChecks --pretty

%.ts: %.as
	$(asc_cmd) -t window -f TypeScript $<
	$(asc_cmd) -t window -f TypeDeclaration $<
	mv *.d.ts types/

%.js: %.ts
	$(tsc) $(tsc_opt) $<

all: types $(dst_ts) $(dst_js)

clean:
	rm -f $(dst_ts) $(dst_js)
	rm -f types/*.d.ts

types:	types/ArisiaComponents.d.ts

types/ArisiaComponents.d.ts: $(top_dir)/ArisiaComponents/Resource/Library/types/ArisiaComponents.d.ts
	cp $< $@


