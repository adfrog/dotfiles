local_dir := gitconfig
$(HOME)/.gitconfig: $(local_dir)/gitconfig
	@cp -afv $< $@
	@git config --global core.excludesfile $(HOME)/.gitignore
