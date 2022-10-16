#
# Makefile.inc
#

include ../Makefile.inc

src_types = ../../../ArisiaComponents/Resource/Library/types

src_scrs   = main.ts
dst_jsscrs = $(src_scrs:.ts=.js)

all: types $(dst_jsscrs)

clean:
	rm -f $(dst_jsscrs)

types: types/ArisiaComponents.d.ts

types/ArisiaComponents.d.ts: $(src_types)/ArisiaComponents.d.ts
	cp $< $@

