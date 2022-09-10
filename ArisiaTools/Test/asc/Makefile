#
# Makefile: Test for asc command
#

asc		= ~/tools/bin/asc
script_dir	= ./scripts
logs_dir	= ./logs

scripts		= empty-frame.ars \
		  property-1.ars \
		  property-2.ars \
		  property-3.ars \
		  property-4.ars \
		  property-5.ars \
		  property-6.ars

all:
	(for scr in $(scripts) ; do \
	    $(asc) $(script_dir)/$$scr | tee $(logs_dir)/$${scr}.log 2>&1 ; \
	 done)

check: all
	(for scr in $(scripts) ; do \
		diff $(logs_dir)/$${scr}.log $(logs_dir)/$${scr}.log.OK ; \
	 done)
	
clean:
	rm -rf logs/*.log

