local_dir := .zsh
files := .zaliases .zshrc .zshrc_darwin .zshrc_sakura
#sub_dir := functions
#dirs := $(addprefix $(local_dir)/, $(sub_dir))

ZSH += $(addprefix $(local_dir)/, $(files))
#ZSH += $(shell ls -Al $(local_dir)/.)
