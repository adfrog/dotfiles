local_dir := .LocalPorts
other_files := $(shell find $(local_dir) -type f ! -name "module.mk")
OTHER		+= $(other_files)
