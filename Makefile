ifndef SRCDIR

SRCDIR := $(shell pwd)

endif

ROOT			:= /
BASE_DIR		:= /


SRCPREDIR		:= $(SRCDIR)$(BASE_DIR)
PREFIX			:= $(HOME)$(BASE_DIR)

ZSH			= .zshenv
ZSH_RC		= .zaliases .zshrc .zshrc_darwin .zshrc_sakura
VIM			= .vimrc .gvimrc
VIMP		= .vimperatorrc
VIMP_RC		= vimperatorrc.js
GIT			= .gitconfig .gitignore
BASH		= .bash_profile .bashrc .profile
CSH			= .cshrc
SH			= .inputrc
SCREEN		= .screenrc .tscreenrc
X11			= .Xdefaults .xinitrc
OTHER		= .sleep .wakeup .dircolors .lesshst



CP_CMD		= echo cp -afv $< $@
DIFF_CMD	= diff -uN $< $@
UP_CMD		= echo up $< $@

define file-attach
	@case $(MAKECMDGOALS) in \
		*-install) 	$(CP_CMD);; \
		*-diff)	$(DIFF_CMD); echo $(dir $@);; \
		*-up)		$(UP_CMD);; \
	esac;
endef
default: help

TARGET_LIST		= zsh vim vimp git bash csh sh screen other x11
TARGET			= $(addsuffix -install,$(TARGETLIST)) \
				  $(addsuffix -diff,$(TARGET_LIST)) \
				  $(addsuffix -up,$(TARGET_LIST))

.PHONY: help all clean sakura $(TARGET) $(TARGET_LIST)

sakura: zsh vim git csh screen
all: zsh vim vimp git bash csh sh screen other x11


############################################################
# Zsh
############################################################
ZSHLIST			= $(addprefix $(PREFIX),$(ZSH))
ZSH_RCLIST		= $(addprefix $(PREFIX).zsh/,$(ZSH_RC))

zsh-install zsh-diff: $(ZSHLIST) $(ZSH_RCLIST)

$(ZSHLIST): $(PREFIX)%: $(SRCPREDIR)%
	@echo $(ZSH_RCLIST)
	$(file-attach)

vpath % .zsh
$(ZSH_RCLIST): $(PREFIX).zsh/%:%
	@mkdir -p $(dir $@)
	$(file-attach)

############################################################
# Vim
############################################################
VIMLIST			= $(addprefix $(PREFIX),$(VIM))
V_TARGET = vim-install vim-diff

$(V_TARGET): $(VIMLIST)

$(VIMLIST): $(PREFIX)%: $(SRCPREDIR)%
	$(file-attach)


############################################################
# Vimperator
############################################################
VIMPLIST		= $(addprefix $(PREFIX),$(VIMP))
VIMP_RCLIST		= $(addprefix $(PREFIX).vimperator/.,$(VIMP_RC))
vimp: $(VIMPLIST) $(VIMP_RCLIST)

$(VIMPLIST): $(PREFIX)%: $(SRCPREDIR)%
	$(file-attach)

$(VIMP_RCLIST): $(PREFIX).vimperator/%: $(SRCPREDIR).vimperator/%
	@mkdir -p $(dir $@)
	$(file-attach)


############################################################
# Git
############################################################
GITLIST			= $(addprefix $(PREFIX),$(GIT))

git: $(GITLIST)

$(GITLIST): $(PREFIX)%: $(SRCPREDIR)%
	$(file-attach)

############################################################
# Bash
############################################################
BASHLIST		= $(addprefix $(PREFIX),$(BASH))

bash: $(BASHLIST)

$(BASHLIST): $(PREFIX)%: $(SRCPREDIR)%
	$(file-attach)


############################################################
# Csh
############################################################
CSHLIST			= $(addprefix $(PREFIX),$(CSH))

csh: $(CSHLIST)

$(CSHLIST): $(PREFIX)%: $(SRCPREDIR)%
	$(file-attach)


############################################################
# SH
############################################################
SHLIST			= $(addprefix $(PREFIX),$(SH))

sh: $(SHLIST)

$(SHLIST): $(PREFIX)%: $(SRCPREDIR)%
	$(file-attach)


############################################################
# Screen
############################################################
SCREENLIST		= $(addprefix $(PREFIX),$(SCREEN))

screen: $(SCREENLIST)

$(SCREENLIST): $(PREFIX)%: $(SRCPREDIR)%
	$(file-attach)


############################################################
# Other
############################################################
OTHERLIST		= $(addprefix $(PREFIX),$(OTHER))

other: $(OTHERLIST) $(PREFIX).MacOSX/environment.plist


$(OTHERLIST): $(PREFIX)%: $(SRCPREDIR)%
	$(file-attach)


$(PREFIX)MacOSX/environment.plist: $(SRCPREDIR)/MacOSX/environment.plist
	@mkdir -p $(dir $@)
	$(file-attach)

############################################################
# X11
############################################################
X11LIST			= $(addprefix $(PREFIX),$(X11))

x11: $(X11LIST)

$(X11LIST): $(PREFIX)%: $(SRCPREDIR)%
	$(file-attach)


############################################################
# HELP
############################################################



$(TARGET_LIST): 
	@echo 
	@echo "    $@ install command"
	@echo "    -------------------------------------------------"
	@echo "    make $@-install		-- Copy"
	@echo "    make $@-diff	-- Diff"
	@echo "    make $@-up		-- up"
	@echo "    -------------------------------------------------"
	@echo "    make update		-- Mirror updates"




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
