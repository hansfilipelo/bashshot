PREFIX ?= /

BINARY_DIR ?= /usr/bin/
ETC_DIR ?= $(PREFIX)/etc
CRON_DIR ?= $(ETC_DIR)/cron.d
LOGROTATE_DIR ?= $(ETC_DIR)/logrotate.d

.PHONY: uninstall install purge

install: bashshot-cleaner bashshot config crontab logrotate bashshot.conf
	install -d $(CURDIR)/bashshot-cleaner $(BINARY_DIR)/bashshot-cleaner
	install -d $(CURDIR)/bashshot $(BINARY_DIR)/bashshot
	install -d -m 644 $(CURDIR)/bashshot.conf $(ETC_DIR)/bashshot.conf
	install -d -m 644 $(CURDIR)/logrotate $(LOGROTATE_DIR)/bashshot
	install -d -m 644 $(CURDIR)/crontab $(CRON_DIR)/bashshot

uninstall:
	rm -f $(BINARY_DIR)/bashshot-cleaner
	rm -f $(BINARY_DIR)/bashshot
	rm -f $(LOGROTATE_DIR)/bashshot
	rm -f $(CRON_DIR)/bashshot

purge: uninstall
	rm -f $(ETC_DIR)/bashshot.conf

