BASE_DIR := .vimperator
repo_dir := $(CURDIR)/$(BASE_DIR)/,$(sub_dir)/
local_dir := $(HOME)/$(BASE_DIR)/

VPATH += $(SUB_DIRS)
PREFIX := $(HOME)/$(BASE_DIR)

find_files = $(wildcard $(dir)/*)
FILES:= $(addprefix $(PREFIX)/, $(foreach dir,$(SUB_DIRS),$(find_files)))

include ../common.mk
