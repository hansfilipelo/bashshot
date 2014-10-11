PREFIX ?= /

BINARY_DIR ?= $(PREFIX)/usr/bin/
ETC_DIR ?= $(PREFIX)/etc
CRON_DIR ?= $(ETC_DIR)/cron.d
LOGROTATE_DIR ?= $(ETC_DIR)/logrotate.d

.PHONY: uninstall install purge

install: bashshot-cleaner bashshot bashshot.conf crontab logrotate bashshot.conf
	install -D $(CURDIR)/bashshot-cleaner $(BINARY_DIR)/bashshot-cleaner
	install -D $(CURDIR)/bashshot $(BINARY_DIR)/bashshot
	install -D -m 644 $(CURDIR)/bashshot.conf $(ETC_DIR)/bashshot.conf
	install -D -m 644 $(CURDIR)/logrotate $(LOGROTATE_DIR)/bashshot
	(echo PATH=/bin:/usr/bin:$(BINARY_DIR); cat crontab) > $(CRON_DIR)/bashshot

uninstall:
	rm -f $(BINARY_DIR)/bashshot-cleaner
	rm -f $(BINARY_DIR)/bashshot
	rm -f $(LOGROTATE_DIR)/bashshot
	rm -f $(CRON_DIR)/bashshot

purge: uninstall
	rm -f $(ETC_DIR)/bashshot.conf
