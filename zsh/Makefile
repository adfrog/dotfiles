ifndef SRCDIR

SRCDIR := $(shell pwd)

endif


RZSHDIR = zsh


# Zsh
R_ZSHENV		= $(SRCDIR)/zshenv
R_ZALIASES		= $(SRCDIR)/$(RZSHDIR)/zaliases
R_ZSHRC			= $(SRCDIR)/$(RZSHDIR)/zshrc
R_ZSHRC_DARWIN	= $(SRCDIR)/$(RZSHDIR)/zshrc_darwin
R_ZSHRC_SAKURA	= $(SRCDIR)/$(RZSHDIR)/zshrc_sakura
#R_ZSH_FUNCTIONS	= $(SRCDIR)/$(RZSHDIR)/functions

# Vim
R_VIMRC			= $(SRCDIR)/vimrc
R_GVIMRC		= $(SRCDIR)/gvimrc

# Git
R_GITCONFIG		= $(SRCDIR)/gitconfig
R_GITIGNORE		= $(SRCDIR)/gitignore

# Bash
R_BASH_PROFILE	= $(SRCDIR)/bash_profile
R_BASHRC		= $(SRCDIR)/bashrc
R_PROFILE		= $(SRCDIR)/profile

# Csh
R_CSHRC			= $(SRCDIR)/cshrc

# SH
R_INPUTRC		= $(SRCDIR)/inputrc

# Screen
R_SCREENRC		= $(SRCDIR)/screenrc
R_TSCREENRC		= $(SRCDIR)/tscreenrc

# Other
R_SLEEP			= $(SRCDIR)/sleep
R_WAKEUP		= $(SRCDIR)/wakeup
R_DIRCOLORS		= $(SRCDIR)/dircolors
R_LESSHST		= $(SRCDIR)/lesshst

# X11
R_XDEFAULTS		= $(SRCDIR)/Xdefaults
R_XINITRC		= $(SRCDIR)/xinitrc




LZSHDIR = .zsh

# ZSH
L_ZSHENV		= $(HOME)/.zshenv
L_ZALIASES		= $(HOME)/$(LZSHDIR)/.zaliases
L_ZSHRC			= $(HOME)/$(LZSHDIR)/.zshrc
L_ZSHRC_DARWIN	= $(HOME)/$(LZSHDIR)/.zshrc_darwin
L_ZSHRC_SAKURA	= $(HOME)/$(LZSHDIR)/.zshrc_sakura

# Vim
L_VIMRC			= $(HOME)/.vimrc
L_GVIMRC		= $(HOME)/.gvimrc

# Git
L_GITCONFIG		= $(HOME)/.gitconfig
L_GITIGNORE		= $(HOME)/.gitignore

# Bash
L_BASH_PROFILE	= $(HOME)/.bash_profile
L_BASHRC		= $(HOME)/.bashrc
L_PROFILE		= $(HOME)/.profile

# Csh
L_CSHRC			= $(HOME)/.cshrc

# SH
L_INPUTRC		= $(HOME)/.inputrc

# Screen
L_SCREENRC		= $(HOME)/.screenrc
L_TSCREENRC		= $(HOME)/.tscreenrc

# Other
L_SLEEP			= $(HOME)/.sleep
L_WAKEUP		= $(HOME)/.wakeup
L_DIRCOLORS		= $(HOME)/.dircolors
L_LESSHST		= $(HOME)/.lesshst
L_XDEFAULTS		= $(HOME)/.Xdefaults
L_XINITRC		= $(HOME)/.xinitrc




# Vimperator
R_VIMP			= $(SRCDIR)/vimperatorrc
R_VIMPBASEDIR	= $(SRCDIR)/vimperator
R_VIMP_COLORS_DIR	= $(R_VIMP_BASE_DIR)/colors
R_VIMP_PLUGIN_DIR	= $(R_VIMP_BASE_DIR)/plugin
R_VIMP_USERCHROME	= $(R_VIMP_BASE_DIR)/userchrome
R_VIMP_SUBRC		= $(SRCDIR)/.vimperatorrc.js

R_VIMP_USERCHROMa	= \
					  $(SRCDIR)/vimperator/userchrome/ContextEncodingMenu.uc.js \
					  $(SRCDIR)/vimperator/userchrome/DragNgoModoki5.uc.js

LVIMP				= \
					  $(HOME)/.vimperator/userchrome/ContextEncodingMenu.uc.js \
					  $(HOME)/.vimperator/userchrome/DragNgoModoki5.uc.js

# Vim Plugin
VP_VIM_FUZZYFINDER		= \
							  autoload/fuf/fuf.vim \
							  autoload/fuf/bookmark.vim \
							  autoload/fuf/buffer.vim \
							  autoload/fuf/callbackfile.vim \
							  autoload/fuf/callbackitem.vim \
							  autoload/fuf/changelist.vim \
							  autoload/fuf/dir.vim \
							  autoload/fuf/file.vim \
							  autoload/fuf/givencmd.vim \
							  autoload/fuf/givendir.vim \
							  autoload/fuf/givenfile.vim \
							  autoload/fuf/jumplist.vim \
							  autoload/fuf/mrucmd.vim \
							  autoload/fuf/quickfix.vim \
							  autoload/fuf/tag.vim \
							  autoload/fuf/taggedfile.vim \
							  autoload/fuf.vim \
							  doc/fuf.jax \
							  doc/fuf.txt \
							  plugin/fuf.vim \

fuzzyfinder: $(VP_VIM_FUZZYFINDER)

VP_VIM_BUFBUF			= \
						  plugin/bufbuf.vim

VP_VIM_YANKRING			= \
						  doc/yankring.txt \
						  plugin/yankring.vim

VP_VIM_NEOCOMPLCACHE	= \
						  















default: help

.PHONY: all
all:
	@echo $(R_ALL)

.PHONY: get
get:
#	cp -afv $(L_ALL) $(SRCDIR)


.PHONY: vimp
vimp: 
	@echo 1


# ZSH

.PHONY: zsh
zsh: $(L_ZSHENV) $(L_ZALIASES) $(L_ZSHRC) $(L_ZSHRC_DARWIN) $(L_ZSHRC_SAKURA) 
#	@echo $(shell ls $(HOME)/.vim/) $(SHELL ls $(HOME)/.zsh/)
#	@echo $(shell ls -R vim)


$(L_ZSHENV): $(R_ZSHENV) 
	@cp -afv $< $@

$(L_ZALIASES): $(R_ZALIASES) 
	@mkdir -p $(dir $@)
	@cp -afv $< $@

$(L_ZSHRC): $(R_ZSHRC) 
	@mkdir -p $(dir $@)
	@cp -afv $< $@

$(L_ZSHRC_DARWIN): $(R_ZSHRC_DARWIN) 
	@mkdir -p $(dir $@)
	@cp -afv $< $@

$(L_ZSHRC_SAKURA): $(R_ZSHRC_SAKURA)
	@mkdir -p $(dir $@)
	@cp -afv $< $@




# VIM
$(L_VIMRC): $(R_VIMRC)
	@cp -afv $< $@

$(L_GVIMRC): $(R_GVIMRC)
	@cp -afv $< $@

.PHONY: vimplugin
#	@echo $(sort $(dir $(addprefix $(SRCDIR)/vim/, $(VP_VIM_FUZZYFINDER))))


.PHONY: vim
vim: $(L_VIMRC) $(L_GVIMRC)



# GIT
$(L_GITCONFIG): $(R_GITCONFIG)
	@cp -afv $< $@

$(L_GITIGNORE): $(R_GITIGNORE)
	@cp -afv $< $@

.PHONY: git
git: $(L_GITCONFIG) $(L_GITIGNORE)


# BASH
$(L_BASH_PROFILE): $(R_BASH_PROFILE)
	@cp -afv $< $@

$(L_BASHRC): $(R_BASHRC)
	@cp -afv $< $@

$(L_PROFILE): $(R_PROFILE)
	@cp -afv $< $@

.PHONY: bash
bash: $(L_BASH_PROFILE) $(L_BASHRC) $(L_PROFILE)


# CSH
$(L_CSHRC): $(R_CSHRC)
	@cp -afv $< $@

.PHONY: csh
csh: $(L_CSHRC)


# SH
$(L_INPUTRC): $(R_INPUTRC)
	@cp -afv $< $@

.PHONY: sh
sh: $(L_INPUTRC)


# SCREEN
$(L_SCREENRC): $(R_SCREENRC)
	@cp -afv $< $@

$(L_TSCREENRC): $(R_TSCREENRC)
	@cp -afv $< $@

.PHONY: screen
screen: $(L_SCREENRC) $(L_TSCREENRC)


# X11
$(L_XDEFAULTS): $(R_XDEFAULTS)
	@cp -afv $< $@

$(L_XINITRC): $(R_XINITRC)
	@cp -afv $< $@

.PHONY: x11
x11: $(L_XDEFAULTS) $(L_XINITRC)


# OTHER
$(L_SLEEP): $(R_SLEEP)
	@cp -afv $< $@

$(L_WAKEUP): $(R_WAKEUP)
	@cp -afv $< $@

$(L_DIRCOLORS): $(R_DIRCOLORS)
	@cp -afv $< $@

$(L_LESSHST): $(R_LESSHST)
	@cp -afv $< $@

.PHONY: other
other: $(L_SLEEP) $(L_WAKEUP) $(L_DIRCOLORS) $(L_LESSHST)


.PHONY: help
help: shorthelp
		@echo

.PHONY: shorthelp
shorthelp:
		@echo
		@echo "    dotfiles install utility"
		@echo "    -------------------------------------------------"
		@echo "    make help              -- Short help"
		@echo "    make longhelp          -- Long help"
		@echo "    make setup             -- Setup directory tree"
		@echo "    make clean             -- Clean unused index.html"
		@echo "    -------------------------------------------------"
		@echo "    make update            -- Mirror updates"

.PHONY: longhelp
longhelp: shorthelp
		@echo "    -------------------------------------------------"
		@echo 
		@echo "    -------------------------------------------------"
		@echo
