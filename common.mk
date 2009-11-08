MKDIR := mkdir -p
CP := echo cp -afv
RM := rm

INSTALL_CMD	= $(CP) $(CURDIR)/$< $@
DIFF_CMD	= echo diff -uN $< $@
UP_CMD		= echo up $< $@

