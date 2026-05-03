all: stdlib.unicode.dg

stdlib.ascii.dg: dialog/stdlib.dg Makefile
	cp dialog/stdlib.dg ./stdlib.ascii.dg

stdlib.unicode.dg: stdlib.ascii.dg Makefile
	## This runs a bunch of regexes on stdlib.dg to replace straight quotes with curly
	rm -f stdlib.unicode.dg
	## Put a comment at the top of the file
	echo "%% Auto-generated from default stdlib.dg: straight quotes changed to curly\n%% Regexes by Daniel Stelzer https://github.com/dstelzer/dialog-unicode" | cat - stdlib.ascii.dg > stdlib.unicode.dg
	## And alter the version string appropriately
	perl -pi -e "s/(\(library version\).*)\.$$/\1, Unicode version./" stdlib.unicode.dg
	## First: double-quotes between whitespace and non-whitespace
	perl -pi -e "s/(\S)\"(\s|$$)/\1”\2/g" stdlib.unicode.dg
	perl -pi -e "s/(\s)\"(\S)/\1“\2/g" stdlib.unicode.dg
	## Second: single-quotes between whitespace and non-whitespace
	perl -pi -e "s/(\s)\'(\S)/\1‘\2/g" stdlib.unicode.dg
	## The following one is more broad to hit "they're" etc
	perl -pi -e "s/(\S)\'/\1’/g" stdlib.unicode.dg
	## Third: double-quotes in parentheses
	perl -pi -e "s/\"\)/”\)/g" stdlib.unicode.dg
	perl -pi -e "s/\(\"/\(“/g" stdlib.unicode.dg
	## Fourth: double-quotes between words and any other punctuation
	perl -pi -e "s/(\w)\"(\W)/\1”\2/g" stdlib.unicode.dg
	perl -pi -e "s/(\W)\"(\w)/\1“\2/g" stdlib.unicode.dg
	## Not currently covered: something like " (print words $$) " or "(print words $$)"
	## Fortunately, this does not currently occur in the library
	grep "[\"']" stdlib.unicode.dg && exit 1 || echo Success!

.PHONY: all
