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

# Vimperator
R_VIMP_RC		= $(SRCDIR)/vimperatorrc
R_VIMP_RC_JS	= $(SRCDIR)/vimperator/vimperatorrc.js

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
R_MACOSX		= $(SRCDIR)/MacOSX/environment.plist

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

# Vimperator
L_VIMP_RC		= $(HOME)/.vimperatorrc
L_VIMP_RC_JS	= $(HOME)/.vimperator/vimperatorrc.js

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
L_MACOSX		= $(HOME)/.MacOSX/environment.plist

# X11
L_XDEFAULTS		= $(HOME)/.Xdefaults
L_XINITRC		= $(HOME)/.xinitrc





default: help


.PHONY: all
all: zsh vim vimp git bash csh sh screen other

.PHONY: sakura
sakura: zsh vim git csh screen


# ZSH

.PHONY: zsh
zsh: $(L_ZSHENV) $(L_ZALIASES) $(L_ZSHRC) $(L_ZSHRC_DARWIN) $(L_ZSHRC_SAKURA) 


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



.PHONY: vim
vim: $(L_VIMRC) $(L_GVIMRC)

# VIM
$(L_VIMRC): $(R_VIMRC)
	@cp -afv $< $@

$(L_GVIMRC): $(R_GVIMRC)
	@cp -afv $< $@





.PHONY: vimp
vimp: $(L_VIMP_RC) $(L_VIMP_RC_JS)

# Vimperator
$(L_VIMP_RC): $(R_VIMP_RC)
	@mkdir -p $(dir $@)
	@cp -afv $< $@


$(L_VIMP_RC_JS): $(R_VIMP_RC_JS)
	@mkdir -p $(dir $@)
	@cp -afv $< $@


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
