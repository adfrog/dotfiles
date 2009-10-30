ifndef SRCDIR

SRCDIR := $(shell pwd)

endif


# Vimperator
R_VIMP			= $(SRCDIR)/vimperatorrc.js
L_VIMP			= $(HOME)/.vimperator/vimperatorrc.js



#default: all

DIRS = colors plugin userchrome
TARGETS = doc xpi
.PHONY: all
#all: xpi ;

$(TARGETS:%=\%.%):
	@echo 3 MAKE $@
	$(MAKE) -C $* $(@:$*.%=%)
	@echo 4


$(TARGETS):
	@echo 1
	$(MAKE) $(DIRS:%=%.$@)
	@echo 2



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
