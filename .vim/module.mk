local_dir := .vim
other_files := $(shell find $(local_dir) -type f ! -name "module.mk")

VIM += $(other_files)

