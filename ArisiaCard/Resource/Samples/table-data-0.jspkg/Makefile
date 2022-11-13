#
# Makefile
#

include ../../Makefile.inc

lib_dir   = ../../Library/types/
src_base  = $(lib_dir)/ArisiaPlatform.d.ts

src_ts   = main.ts
src_as	 = table.as

dst_ts   = $(src_as:.as=.ts)
dst_js   = $(src_ts:.ts=.js) $(dst_ts:.ts=.js)
dst_rec  = types/record.d.ts
dst_base = ./types/ArisiaPlatform.d.ts

asc_opt += --import $(dst_rec)

all: types $(dst_ts) $(dst_js)

clean:
	rm -f $(dst_ts) $(dst_js) $(dst_rec) $(dst_base)
	rm -rf types

types: type_dir $(dst_rec) $(dst_base)

type_dir: dummy
	mkdir -p types

$(dst_rec): dummy
	if [ -x $(ares_cmd) ] ; then \
	    $(ares_cmd) ../table-data-0.jspkg > $(dst_rec) ; \
	fi

$(dst_base): $(src_base)
	cp $< $@

dummy:

