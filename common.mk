files := $(get-files)
define file-attach
	@case $(MAKECMDGOALS) in \
		install|sakura) 	mkdir -p $(dir $@); $(INSTALL_CMD);; \
	esac;
endef
MKDIR := mkdir -p
CP := cp -afv
RM := rm

INSTALL_CMD	= $(CP) $(CURDIR)/$< $@
DIFF_CMD	= echo diff -uN $< $@
UP_CMD		= echo up $< $@

