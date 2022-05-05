SHELL=bash

FENCRYPT?=./fencrypt

PREFIX=.fenc-meta.

TEXT_FILES=macbeth.txt aeschylus.txt
BINARY_FILES=ecb.jpg

all: encrypt search

encrypt: $(addprefix $(PREFIX),$(TEXT_FILES) $(BINARY_FILES))

$(PREFIX)%: %
	@echo "encrypting with password: $(shell echo -n $* | python -c 'import sys; print(repr(sys.stdin.read()))')"
	echo -n $* | $(FENCRYPT) -e -v $*

search:
	@echo
	echo -n wrongpassword | $(FENCRYPT) -s crickets
	@echo
	echo -n macbeth.txt | $(FENCRYPT) -s haha
	@echo
	echo -n macbeth.txt | $(FENCRYPT) -s -v crickets
	@echo
	echo -n macbeth.txt | $(FENCRYPT) -s cric*
	@echo
	echo -n aeschylus.txt | $(FENCRYPT) -s άδραστου
	@echo
	echo -n aeschylus.txt | $(FENCRYPT) -s άδρασ*

decrypt:
	@echo
	echo -n macbeth.txt | $(FENCRYPT) -d macbeth.txt
	@echo
	echo -n aeschylus.txt | $(FENCRYPT) -d aeschylus.txt
	@echo
	echo -n ecb.jpg | $(FENCRYPT) -d ecb.jpg

clean:
	@-rm *.txt* .*.txt
	@-rm *.jpg* .*.jpg

macbeth.txt:
	@echo
	# https://www.gutenberg.org/ebooks/2264
	curl -s https://www.gutenberg.org/cache/epub/2264/pg2264.txt | tee $@.plain > $@

aeschylus.txt:
	@echo
	# https://www.gutenberg.org/ebooks/17996
	curl -s https://www.gutenberg.org/files/17996/17996-0.txt | tee $@.plain > $@

ecb.jpg:
	@echo
	# https://en.wikipedia.org/wiki/Block_cipher_mode_of_operation
	curl -s https://upload.wikimedia.org/wikipedia/commons/f/f0/Tux_ecb.jpg | tee $@.plain > $@
