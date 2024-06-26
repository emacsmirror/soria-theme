TOP := $(dir $(realpath $(firstword $(MAKEFILE_LIST))))
LOAD_PATH = -L $(TOP) -L $(TOP)vendor
PKG = soria

ELS_ALL = $(wildcard *.el)
ELS = $(filter-out $(PKG)-autoloads.el,$(ELS_ALL))
OBJECTS = $(ELS:.el=.elc)

EMACS ?= emacs
BATCH = $(EMACS) --quick --batch $(LOAD_PATH)

##
# General

.PHONY: all
all: clean test

.PHONY: version
version:
	@$(EMACS) --version

.PHONY: clean
clean:
	@rm -rf $(TOP)vendor/* $(PKG)-autoloads.el* $(OBJECTS)

.PHONY: build
build: $(OBJECTS)

$(OBJECTS): %.elc: %.el
	@$(BATCH) --kill -l bytecomp --eval '(byte-recompile-file (expand-file-name "$(TOP)$<") nil 0)'

##
# Test

.PHONY: ci
ci: version all

.PHONY: test
test: lint checkdoc load-test

# Maybe it would've been nicer to use Cask or something like that, but it
# doesn't have too many dependencies so it should be fine for now.
.PHONY: vendor
vendor:
	@mkdir -p $(TOP)vendor
ifeq ("$(wildcard $(TOP)vendor/elisp-lint.el)","")
	@echo "Downloading 'elisp-lint' into 'vendor' directory"
	@wget -q -O $(TOP)vendor/elisp-lint.el https://raw.githubusercontent.com/gonewest818/elisp-lint/master/elisp-lint.el
endif
# Required by elisp-lint.el
ifeq ("$(wildcard $(TOP)vendor/package-lint.el)","")
	@echo "Downloading 'package-lint' into 'vendor' directory"
	@wget -q -O $(TOP)vendor/package-lint.el https://raw.githubusercontent.com/purcell/package-lint/master/package-lint.el
endif
# Required by elisp-lint.el
ifeq ("$(wildcard $(TOP)vendor/dash.el)","")
	@echo "Downloading 'dash' into 'vendor' directory"
	@wget -q -O vendor/dash.el https://raw.githubusercontent.com/magnars/dash.el/master/dash.el
endif

.PHONY: fix-stdlib-changes
fix-stdlib-changes:
# HACK: God knows why this file is needed, but an empty expression makes
# package-lint shut up.
	@mkdir -p vendor/data
	@echo "()" > vendor/data/stdlib-changes
	@echo "()" > vendor/data/compat-symbols

.PHONY: lint
lint: vendor fix-stdlib-changes
	@$(BATCH) -l elisp-lint.el -f elisp-lint-files-batch $(ELS)

.PHONY: load-test
load-test:
	@$(BATCH) -nw --load soria-theme.el \
		--eval "(progn \
		          (add-to-list 'custom-theme-load-path \"$(TOP)\") \
		          (load-theme 'soria t) \
		          (message \"%s\" soria-theme-hide-helm-header))"

.PHONY: checkdoc
checkdoc:
	@chmod +x ./bin/checkdoc.sh
	@./bin/checkdoc.sh $(BATCH) -nw --load soria-theme.el
