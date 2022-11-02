#
# Makefile.inc
#

include ../Makefile.inc

src_types = ../../../ArisiaComponents/Resource/Library/types

src_tsscrs = main.ts
src_asscrs = home.as
dst_jsscrs = $(src_tsscrs:.ts=.js) $(src_asscrs:.as=.js)

all: types $(dst_jsscrs)

clean:
	rm -f $(dst_jsscrs)

types: types/ArisiaComponents.d.ts

types/ArisiaComponents.d.ts: $(src_types)/ArisiaComponents.d.ts
	cp $< $@

