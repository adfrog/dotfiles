SUB_DIRS := colors plugin userchrome
VPATH = $(SUB_DIRS)
BASE_DIR := .vimperator
PREFIX := $(HOME)/$(BASE_DIR)

find_files = $(wildcard $(dir)/*)
FILES:= $(addprefix $(PREFIX)/, $(foreach dir,$(SUB_DIRS),$(find_files)))

install: $(FILES)

test:
	@echo $(files)

$(FILES): $(PREFIX)/%: %
	@mkdir -p $(dir $@)
	@echo cp -afv $(CURDIR)/$< $@
