#
# Makefile.inc
#

include ../Makefile.inc

src_types = ../Library/types

src_tsscrs = main.ts
src_asscrs = preference.as
dst_jsscrs = $(src_tsscrs:.ts=.js) $(src_asscrs:.as=.js)

all: types $(dst_jsscrs)

clean:
	rm -f $(dst_jsscrs)

types: types/ArisiaPlatform.d.ts

types/ArisiaPlatform.d.ts: $(src_types)/ArisiaPlatform.d.ts
	cp $< $@

