#
# Makefile: Test for asc command
#

asc		= ~/tools/bin/asc
script_dir	= ./scripts
logs_dir	= ./logs

scripts		= empty-frame.ars \
		  property-boolean.ars \
		  property-number.ars \
		  property-string.ars \
		  property-array.ars \
		  property-dictionary.ars \
		  property-enum.ars \
		  property-init.ars \
		  property-func.ars

all:
	(for scr in $(scripts) ; do \
	    $(asc) $(script_dir)/$$scr | tee $(logs_dir)/$${scr}.log 2>&1 ; \
	 done)

check: all
	(for scr in $(scripts) ; do \
		echo "* script $${scr}" ; \
		diff $(logs_dir)/$${scr}.log $(logs_dir)/$${scr}.log.OK ; \
	 done)
	
clean:
	rm -rf logs/*.log

