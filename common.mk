SUB_DIRS := colors plugin userchrome
VPATH = $(SUB_DIRS)
BASE_DIR := .vimperator
PREFIX := $(HOME)/$(BASE_DIR)

find_files = $(wildcard $(dir)/*)
FILES:= $(addprefix $(PREFIX)/, $(foreach dir,$(SUB_DIRS),$(find_files)))

INSTALL_CMD	= cp -afv $(CURDIR)/$< $@
DIFF_CMD	= echo diff -uN $< $@
UP_CMD		= echo up $< $@

