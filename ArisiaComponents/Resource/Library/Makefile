#
# Makefile
#

adecl_cmd = $(HOME)/tools/bin/adecl

srcs	= Frame.d.ts \
	  ButtonView.d.ts \
	  RootView.d.ts \
	  StackView.d.ts

all: types/ArisiaComponents.d.ts

types/ArisiaComponents.d.ts: dummy
	if [ -x $(adecl_cmd) ] ; then \
		cd types && $(adecl_cmd) ; \
	fi
	(cd types && cat $(srcs) > ArisiaComponents.d.ts)

dummy:


