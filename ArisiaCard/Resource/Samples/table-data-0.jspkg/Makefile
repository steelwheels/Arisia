#
#
#

include ../../Makefile.inc

lib_dir   = ../../Library/types/
src_base  = $(lib_dir)/ArisiaComponents.d.ts

src_ts   = main.ts
src_as	 = table.as

dst_ts   = $(src_as:.as=.ts)
dst_js   = $(src_ts:.ts=.js)
dst_rec  = ./types/record.d.ts
dst_base = ./types/ArisiaComponents.d.ts

asc_opt += --import $(dst_rec)

arecdecl = $(HOME)/tools/bin/arecdecl

all: types $(dst_ts) $(dst_js)

clean:
	rm -f $(dst_ts) $(dst_js) $(dst_rec) $(dst_base)
	rm -f types/main.d.ts

types: $(dst_rec) $(dst_base)

$(dst_rec): dummy
	$(arecdecl) ../table-data-0.jspkg > $(dst_rec)

$(dst_base): $(src_base)
	cp $< $@

dummy:

