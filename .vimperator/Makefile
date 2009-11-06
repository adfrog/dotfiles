SUB_DIRS := colors plugin userchrome
VPATH = $(SUB_DIRS)
BASE_DIR := .vimperator
PREFIX := $(HOME)/$(BASE_DIR)

find_files = $(wildcard $(dir)/*)
FILES:= $(addprefix $(PREFIX)/, $(foreach dir,$(SUB_DIRS),$(find_files)))

.PHONY: install

install: $(FILES)


$(FILES): $(PREFIX)/%: %
	@mkdir -p $(dir $@)
	@cp -afv $(CURDIR)/$< $@
