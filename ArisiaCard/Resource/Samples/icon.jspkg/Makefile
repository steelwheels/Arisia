#
#
#

include ../../Makefile.inc

src_ts		= main.ts
src_as		= icon.as 
src_type_dir	= ../../Library/types

dsts = $(src_ts:.ts=.js) $(src_as:.as=.ts) $(src_as:.as=.js)
dst_type	= ./types/ArisiaPlatform.d.ts

all: types images $(dsts)

types: $(dst_type)

$(dst_type): $(src_type_dir)/ArisiaPlatform.d.ts
	cp $< $@

images: images/card.png

images/card.png: ../../Image/arisia-card-icon.png
	cp $< $@

clean:
	rm -f $(dsts) $(dst_type)

