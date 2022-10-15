#
# Makefile.inc
#

inc_opt	= -I../../ArisiaComponents/Resource/Library/types 
m4_opt  = -P $(inc_opt)

%.md : %.md4
	m4 $(m4_opt) $< > $@

