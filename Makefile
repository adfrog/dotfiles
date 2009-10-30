#ifndef SRCDIR

SRCDIR := $(shell pwd)

#endif

PREFIX = $(HOME)/.

ZSH			= zshenv
ZSH_RC		= zaliases zshrc zshrc_darwin zshrc_sakura
VIM			= vimrc gvimrc
VIMP		= vimperatorrc
VIMP_RC		= vimperatorrc.js
GIT			= gitconfig gitignore
BASH		= bash_profile bashrc profile
CSH			= cshrc
SH			= inputrc
SCREEN		= screenrc tscreenrc
X11			= Xdefaults xinitrc
OTHER		= sleep wakeup dircolors lesshst


default: help


.PHONY: zsh vim vimp git bash csh sh screen other help all clean sakura

sakura: zsh vim git csh screen
all: zsh vim vimp git bash csh sh screen other x11


############################################################
# Zsh
############################################################
ZSHLIST			= $(addprefix $(PREFIX),$(ZSH))
ZSH_RCLIST		= $(addprefix $(PREFIX)zsh/.,$(ZSH_RC))
zsh: $(ZSHLIST) $(ZSH_RCLIST)

$(ZSHLIST): $(PREFIX)%: $(SRCDIR)/%
	@echo $< $@

$(ZSH_RCLIST): $(PREFIX)zsh/.%: $(SRCDIR)/zsh/%
	@mkdir -p $(dir $@)
	@echo $< $@

############################################################
# Vim
############################################################
VIMLIST			= $(addprefix $(PREFIX),$(VIM))

vim: $(VIMLIST)

$(VIMLIST): $(PREFIX)%: $(SRCDIR)/%
	@echo $< $@


############################################################
# Vimperator
############################################################
VIMPLIST		= $(addprefix $(PREFIX),$(VIMP))
VIMP_RCLIST		= $(addprefix $(PREFIX)vimperator/.,$(VIMP_RC))
vimp: $(VIMPLIST) $(VIMP_RCLIST)

$(VIMPLIST): $(PREFIX)%: $(SRCDIR)/%
	@echo $< $@

$(VIMP_RCLIST): $(PREFIX)vimperator/.%: $(SRCDIR)/vimperator/%
	@mkdir -p $(dir $@)
	@echo $< $@



############################################################
# Git
############################################################
GITLIST			= $(addprefix $(PREFIX),$(GIT))

git: $(GITLIST)

$(GITLIST): $(PREFIX)%: $(SRCDIR)/%
	@echo $< $@ 

############################################################
# Bash
############################################################
BASHLIST		= $(addprefix $(PREFIX),$(BASH))

bash: $(BASHLIST)

$(BASHLIST): $(PREFIX)%: $(SRCDIR)/%
	@echo $< $@ 


############################################################
# Csh
############################################################
CSHLIST			= $(addprefix $(PREFIX),$(CSH))

csh: $(CSHLIST)

$(CSHLIST): $(PREFIX)%: $(SRCDIR)/%
	@echo $< $@ 


############################################################
# SH
############################################################
SHLIST			= $(addprefix $(PREFIX),$(SH))

sh: $(SHLIST)

$(SHLIST): $(PREFIX)%: $(SRCDIR)/%
	@echo $< $@ 


############################################################
# Screen
############################################################
SCREENLIST		= $(addprefix $(PREFIX),$(SCREEN))

screen: $(SCREENLIST)

$(SCREENLIST): $(PREFIX)%: $(SRCDIR)/%
	@echo $< $@ 



############################################################
# Other
############################################################
OTHERLIST		= $(addprefix $(PREFIX),$(OTHER))

other: $(OTHERLIST) $(PREFIX)MacOSX/environment.plist


$(OTHERLIST): $(PREFIX)%: $(SRCDIR)/%
	@echo $< $@ 

$(PREFIX)MacOSX/environment.plist: $(SRCDIR)/MacOSX/environment.plist
	@mkdir -p $(dir $@)
	@echo $< $@

############################################################
# X11
############################################################
X11LIST			= $(addprefix $(PREFIX),$(X11))

x11: $(X11LIST)

$(X11LIST): $(PREFIX)%: $(SRCDIR)/%
	@echo $< $@ 


############################################################
# 
############################################################







.PHONY: help
help: shorthelp
		@echo

.PHONY: shorthelp
shorthelp:
		@echo
		@echo "    dotfiles install utility"
		@echo "    -------------------------------------------------"
		@echo "    make help              -- Short help"
#		@echo "    make longhelp          -- Long help"
		@echo "    make setup             -- Setup directory tree"
		@echo "    make sakura            -- SAKURA Internet"
		@echo "    -------------------------------------------------"
		@echo "    make update            -- Mirror updates"

.PHONY: longhelp
longhelp: shorthelp
		@echo "    -------------------------------------------------"
		@echo 
		@echo "    -------------------------------------------------"
		@echo
