ifndef SRCDIR

SRCDIR := $(shell pwd)

endif

VPATH = $(HOME):$(SRCDIR):./colors

DIRS = colors plugin userchrome
TARGETS = doc xpi
.PHONY: all
#all: xpi ;

#$(TARGETS:%=\%.%):
#	@echo 3 MAKE $@
#	$(MAKE) -C $* $(@:$*.%=%)
#	@echo 4


#$(TARGETS):
#	@echo 1
#	$(MAKE) $(DIRS:%=%.$@)
#	@echo 2


all: .zshenv

zsh-diff:
	
.zshenv: ../zshenv
	@echo $< $@
