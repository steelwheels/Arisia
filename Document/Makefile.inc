#
# Makefile.inc
#

inc_opt	= -I../../ArisiaTools/Resource/Library/types \
	  -I../../ArisiaCard/Resource/Samples
m4_opt  = -P $(inc_opt)

%.md : %.md4
	m4 $(m4_opt) $< > $@

