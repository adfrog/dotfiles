ifndef SRCDIR

SRCDIR := $(shell pwd)

endif

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

CP_CMD		= cp -afv $< $@
DIFF_CMD	= echo diff -uN $< $@
UP_CMD		= echo up $< $@

define FILE_ATTACH
	@if [ ! $(MAKECMDGOALS) = vim ]; then \
		case $(subst vim-,,$(MAKECMDGOALS)) in \
			cp) 	$(CP_CMD);; \
			diff)	$(DIFF_CMD); echo $(dir $@);; \
			up)		$(UP_CMD);; \
		esac; \
	else \
		$(CP_CMD); \
	fi
endef
default: help

TARGET_LIST		= zsh vim vimp git bash csh sh screen other
TARGET			= $(TARGET_LIST) \
				  $(addsuffix -cp,$(TARGETLIST)) \
				  $(addsuffix -diff,$(TARGET_LIST)) \
				  $(addsuffix -up,$(TARGET_LIST))

V_TARGET		= vim vim-cp vim-diff vim-up
.PHONY: help all clean sakura $(TARGET)

sakura: zsh vim git csh screen
all: zsh vim vimp git bash csh sh screen other x11

test: 
	@echo $(TARGET)

############################################################
# Zsh
############################################################
ZSHLIST			= $(addprefix $(PREFIX),$(ZSH))
ZSH_RCLIST		= $(addprefix $(PREFIX)zsh/.,$(ZSH_RC))
zsh: $(ZSHLIST) $(ZSH_RCLIST)

$(ZSHLIST): $(PREFIX)%: $(SRCDIR)/%
	@cp -afv $< $@
#	@echo $< $@

$(ZSH_RCLIST): $(PREFIX)zsh/.%: $(SRCDIR)/zsh/%
	@mkdir -p $(dir $@)
	@cp -afv $< $@
#	@echo $< $@

############################################################
# Vim
############################################################
VIMLIST			= $(addprefix $(PREFIX),$(VIM))

$(V_TARGET): $(VIMLIST)

$(VIMLIST): $(PREFIX)%: $(SRCDIR)/%
	$(FILE_ATTACH)


############################################################
# Vimperator
############################################################
VIMPLIST		= $(addprefix $(PREFIX),$(VIMP))
VIMP_RCLIST		= $(addprefix $(PREFIX)vimperator/.,$(VIMP_RC))
vimp: $(VIMPLIST) $(VIMP_RCLIST)

$(VIMPLIST): $(PREFIX)%: $(SRCDIR)/%
	@cp -afv $< $@
#	@echo $< $@

$(VIMP_RCLIST): $(PREFIX)vimperator/.%: $(SRCDIR)/vimperator/%
	@mkdir -p $(dir $@)
	@cp -afv $< $@
#	@echo $< $@



############################################################
# Git
############################################################
GITLIST			= $(addprefix $(PREFIX),$(GIT))

git: $(GITLIST)

$(GITLIST): $(PREFIX)%: $(SRCDIR)/%
	@cp -afv $< $@
#	@echo $< $@

############################################################
# Bash
############################################################
BASHLIST		= $(addprefix $(PREFIX),$(BASH))

bash: $(BASHLIST)

$(BASHLIST): $(PREFIX)%: $(SRCDIR)/%
	@cp -afv $< $@
#	@echo $< $@


############################################################
# Csh
############################################################
CSHLIST			= $(addprefix $(PREFIX),$(CSH))

csh: $(CSHLIST)

$(CSHLIST): $(PREFIX)%: $(SRCDIR)/%
	@cp -afv $< $@
#	@echo $< $@


############################################################
# SH
############################################################
SHLIST			= $(addprefix $(PREFIX),$(SH))

sh: $(SHLIST)

$(SHLIST): $(PREFIX)%: $(SRCDIR)/%
	@cp -afv $< $@
#	@echo $< $@


############################################################
# Screen
############################################################
SCREENLIST		= $(addprefix $(PREFIX),$(SCREEN))

screen: $(SCREENLIST)

$(SCREENLIST): $(PREFIX)%: $(SRCDIR)/%
	@cp -afv $< $@
#	@echo $< $@



############################################################
# Other
############################################################
OTHERLIST		= $(addprefix $(PREFIX),$(OTHER))

other: $(OTHERLIST) $(PREFIX)MacOSX/environment.plist


$(OTHERLIST): $(PREFIX)%: $(SRCDIR)/%
	@cp -afv $< $@
#	@echo $< $@

$(PREFIX)MacOSX/environment.plist: $(SRCDIR)/MacOSX/environment.plist
	@mkdir -p $(dir $@)
	@cp -afv $< $@
#	@echo $< $@

############################################################
# X11
############################################################
X11LIST			= $(addprefix $(PREFIX),$(X11))

x11: $(X11LIST)

$(X11LIST): $(PREFIX)%: $(SRCDIR)/%
	@cp -afv $< $@
#	@echo $< $@


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
