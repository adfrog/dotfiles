ifndef SRCDIR

SRCDIR := $(shell pwd)

endif

ROOT			:= /
BASE_DIR		:= /
VPATH			= .zsh .vimperator .MacOSX

SRCPREDIR		:= $(SRCDIR)$(BASE_DIR)
PREFIX			:= $(HOME)$(BASE_DIR)

ZSH			= .zshenv $(addprefix $(ZSH_DIR),$(ZSH_RC))
ZSH_RC		= .zaliases .zshrc .zshrc_darwin .zshrc_sakura
ZSH_DIR		= .zsh/

VIM			= .vimrc .gvimrc

VIMP		= .vimperatorrc $(addprefix $(VIMP_DIR),$(VIMP_RC))
VIMP_RC		= vimperatorrc.js
VIMP_DIR	= .vimperator/

GIT			= .gitconfig .gitignore
BASH		= .bash_profile .bashrc .profile
CSH			= .cshrc
SH			= .inputrc
SCREEN		= .screenrc .tscreenrc
X11			= .Xdefaults .xinitrc
OTHER		= .sleep .wakeup .dircolors .lesshst $(addprefix .MacOSX/,$(OTHER_RC))
OTHER_RC	= environment.plist


INSTALL_CMD	= echo cp -afv $< $@
DIFF_CMD	= diff -uN $< $@
UP_CMD		= echo up $< $@

define file-attach
	@case $(MAKECMDGOALS) in \
		install|sakura) 	mkdir -p $(dir $@); $(INSTALL_CMD);; \
		diff)	$(DIFF_CMD); echo $(dir $@);; \
		up)		$(UP_CMD);; \
	esac;
endef
default: help

TARGET_LIST		= zsh vim vimp git bash csh sh screen other x11
TARGET			= $(addsuffix -install,$(TARGETLIST)) \
				  $(addsuffix -diff,$(TARGET_LIST)) \
				  $(addsuffix -up,$(TARGET_LIST))

.PHONY: help all clean sakura $(TARGET) $(TARGET_LIST)

sakura: zsh vim git csh screen
install: $(TARGET_LIST)
diff: $(TARGET_LIST)
#include .vimperator/Makefile
test:
	@echo $(BASE_DIR)
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
vimp: $(VIMPLIST) $(VIMP_RCLIST)
	@$(MAKE) -C .vimperator

$(VIMPLIST): $(PREFIX)%: %
	$(file-attach)



############################################################
# Git
############################################################
GITLIST			= $(addprefix $(PREFIX),$(GIT))

git: $(GITLIST)

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
