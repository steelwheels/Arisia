#
# Makefile
#

asc_cmd	= ~/tools/bin/asc

as_scripts	= main_view.as \
		  button.as
ts_scripts	= $(as_scripts:.as=.ts)

%.ts: %.as
	$(asc_cmd) -f TypeScript $<

all: $(ts_scripts)

clean:
	rm -f $(ts_scripts)


