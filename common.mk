
#find_files = $(wildcard $(dir)/*)
#get-files := $(foreach dir,$(dirs),$(find_files))
#FILES:= $(addprefix $(PREFIX)/, $(foreach dir,$(sub_dir),$(find_files)))

INSTALL_CMD	= echo cp -afv $(CURDIR)/$< $@
DIFF_CMD	= echo diff -uN $< $@
UP_CMD		= echo up $< $@

MKDIR := mkdir -p
CP := cp -afv
RM := rm
