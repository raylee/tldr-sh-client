BIN ?= tldr
PREFIX ?= /usr/local

install:
	cp $(BIN) $(PREFIX)/bin/$(BIN)
    
uninstall:
	rm -f -- $(PREFIX)/bin/$(BIN)
