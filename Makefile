ifndef SRCDIR

SRCDIR := $(shell pwd)

endif
BASE_DIR		:= /

SRCPREDIR		:= $(SRCDIR)$(BASE_DIR)
PREFIX			:= $(HOME)$(BASE_DIR)

ZSH			:= .zshenv

VIM			:= .vimrc .gvimrc

VIMP		:= .vimperatorrc 
GIT			:= .gitignore
BASH		:= .bash_profile .bashrc .profile
CSH			:= .cshrc
SH			:= .inputrc
SCREEN		:= .screenrc .tscreenrc
X11			:= .Xdefaults .xinitrc
OTHER		:= .dircolors .lesshst .MacOSX/environment.plist

modules := $(subst /module.mk,,$(shell find . -name module.mk))
include common.mk
include $(addsuffix /module.mk,$(modules)) 

default: help

TARGET_LIST		= zsh vim vimp git bash csh sh screen other x11 sleepwatcher

.PHONY: install help all clean sakura $(TARGET_LIST)

sakura: zsh vim git csh screen
install: $(TARGET_LIST)
di: $(TARGET_LIST)
diff:
	git diff
############################################################
# Zsh
############################################################
ZSHLIST			= $(addprefix $(PREFIX),$(ZSH))

zsh: $(ZSHLIST) $(ZSH_RCLIST)

$(ZSHLIST): $(PREFIX)%: %
	$(file-attach)


############################################################
# Vim
############################################################
VIMLIST			= $(addprefix $(PREFIX),$(VIM))

vim: $(VIMLIST)

$(VIMLIST): $(PREFIX)%: %
	$(file-attach)


############################################################
# Vimperator
############################################################
VIMPLIST		= $(addprefix $(PREFIX),$(VIMP))
vimp: $(VIMPLIST) 

$(VIMPLIST): $(PREFIX)%: %
	$(file-attach)



############################################################
# Git
############################################################
GITLIST			= $(addprefix $(PREFIX),$(GIT))

git: $(GITLIST) $(HOME)/.gitconfig

$(GITLIST): $(PREFIX)%: %
	$(file-attach)

############################################################
# Bash
############################################################
BASHLIST		= $(addprefix $(PREFIX),$(BASH))

bash: $(BASHLIST)

$(BASHLIST): $(PREFIX)%: %
	$(file-attach)


############################################################
# Csh
############################################################
CSHLIST			= $(addprefix $(PREFIX),$(CSH))

csh: $(CSHLIST)

$(CSHLIST): $(PREFIX)%: %
	$(file-attach)


############################################################
# SH
############################################################
SHLIST			= $(addprefix $(PREFIX),$(SH))

sh: $(SHLIST)

$(SHLIST): $(PREFIX)%: %
	$(file-attach)


############################################################
# Screen
############################################################
SCREENLIST		= $(addprefix $(PREFIX),$(SCREEN))

screen: $(SCREENLIST)

$(SCREENLIST): $(PREFIX)%: %
	$(file-attach)


############################################################
# Other
############################################################
OTHERLIST		= $(addprefix $(PREFIX),$(OTHER))

other: $(OTHERLIST)


$(OTHERLIST): $(PREFIX)%: %
	$(file-attach)


############################################################
# X11
############################################################
X11LIST			= $(addprefix $(PREFIX),$(X11))

x11: $(X11LIST)

$(X11LIST): $(PREFIX)%: %
	$(file-attach)


############################################################
# HELP
############################################################



#$(TARGET_LIST): 
#	@echo 
#	@echo "    $@ install command"
#	@echo "    -------------------------------------------------"
#	@echo "    make $@-install		-- Copy"
#	@echo "    make $@-diff	-- Diff"
#	@echo "    make $@-up		-- up"
#	@echo "    -------------------------------------------------"
#	@echo "    make update		-- Mirror updates"




.PHONY: help
help: shorthelp
		@echo

.PHONY: shorthelp
shorthelp:
		@echo
		@echo "    dotfiles install utility"
		@echo "    gmake を使わないとダメぽいです"
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
