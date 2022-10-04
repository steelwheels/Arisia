#
# Makefile
#

adecl_cmd	= ~/tools/bin/adecl

all:  gen check

gen:
	(cd types ; $(adecl_cmd))

check:
	diff -rw types expected

clean:
	rm -f types/*.d.ts

dummy:

