PREFIX ?= /

BINARY_DIR ?= /usr/bin/
CRON_DIR ?= $(PREFIX)/etc/cron.d
LOGROTATE_DIR ?= $(PREFIX)/etc/logrotate.d
EXT=.bash

.PHONY: uninstall install

install: bashshot-cleaner.bash bashshot.bash config crontab logrotate
	install -d $(CURDIR)/bashshot-cleaner$(EXT) $(BINARY_DIR)/bashshot-cleaner
	install -d $(CURDIR)/bashshot$(EXT) $(BINARY_DIR)/bashshot
	install -d -m 644 $(CURDIR)/logrotate $(LOGROTATE_DIR)/bashshot
	install -d -m 644 $(CURDIR)/crontab $(CRON_DIR)/bashshot

uninstall:
	rm -f $(BINARY_DIR)/bashshot-cleaner
	rm -f $(BINARY_DIR)/bashshot
	rm -f $(LOGROTATE_DIR)/bashshot
	rm -f $(CRON_DIR)/bashshot
