local_dir := .vimperator
sub_dir := colors plugin userchrome
dirs := $(addprefix $(local_dir)/, $(sub_dir))

find_files = $(wildcard $(dir)/*)
get-files := $(foreach dir,$(dirs),$(find_files))
VIMP += \
			 $(local_dir)/vimperatorrc.js \
			 $(get-files)

