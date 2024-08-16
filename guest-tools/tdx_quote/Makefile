PREFIX ?= /usr/local
BINDIR ?= $(PREFIX)/bin

CFLAGS = -O2
LDFLAGS = -ltdx_attest

.PHONY: all install uninstall clean

all: tdx_quote

tdx_quote: tdx_quote.c
	$(CC) $(CFLAGS) $^ -o $@ $(LDFLAGS)

install: tdx_quote
	install -D -m 755 tdx_quote $(DESTDIR)$(BINDIR)/tdx_quote

uninstall:
	rm -f $(DESTDIR)$(BINDIR)/tdx_quote

clean:
	rm -f tdx_quote
