#
# Makefile
#

dst_decl	= ./types/ArisiaPlatform.d.ts
adecl_cmd	= $(HOME)/tools/bin/adecl

all: $(dst_decl)

clean:
	rm -f $(dst_decl)

$(dst_decl): dummy
	(cd types && $(adecl_cmd))
	cat types/ArisiaComponents.d.ts \
	    types/Box.d.ts \
	    types/Button.d.ts \
	    types/Collection.d.ts \
	    types/Image.d.ts \
	    types/Icon.d.ts \
	    types/Label.d.ts \
	    types/RadioButtons.d.ts \
	    types/Stepper.d.ts \
	    types/TableData.d.ts \
	> $@

dummy:

