#
#
#

include ../../Makefile.inc

src_ts		= main.ts
src_as		= hello.as 
src_type_dir	= ../../Library/types

dsts = $(src_ts:.ts=.js) $(src_as:.as=.js)

all: types $(dsts)

types: ./types/ArisiaComponents.d.ts

./types/ArisiaComponents.d.ts: $(src_type_dir)/ArisiaComponents.d.ts
	cp $< $@

clean:
	rm -f $(dsts)

