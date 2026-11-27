# Makefile for ltMermaid test and build
# リポジトリの top で make -C dev <target> として実行する

# パッケージと doc はリポジトリの top にある
TOP=..
LATEX=lualatex
PDFLATEX=pdflatex
L3BUILD=texlua $(shell kpsewhich l3build.lua)
LATEX_OPTS=-shell-escape -interaction=nonstopmode
DOCS=ltmermaid-doc.tex mermaid-doc.tex
TEXMFLOCAL ?= $(shell kpsewhich --var-value=TEXMFLOCAL 2>/dev/null)
INSTALL_STY=$(addprefix $(TOP)/,ltmermaid.sty mermaid.sty)
INSTALL_DOC=$(addprefix $(TOP)/,ltmermaid-doc.tex mermaid-doc.tex ltmermaid-doc-ja.tex mermaid-doc-ja.tex README.md)

.DEFAULT_GOAL := help
.PHONY: help all build test l3build-check l3build-luatex-check l3build-test l3build-clean install local-install clean

all: build l3build-test

build:
	cd $(TOP) && $(LATEX) $(LATEX_OPTS) ltmermaid-doc.tex
	cd $(TOP) && $(LATEX) $(LATEX_OPTS) mermaid-doc.tex

test: l3build-test

l3build-check:
	$(L3BUILD) check

l3build-luatex-check:
	$(L3BUILD) check -c luatex

l3build-test: l3build-check l3build-luatex-check

l3build-clean:
	$(L3BUILD) clean

help:
	@echo "Usage: make -C dev <target>"
	@echo
	@echo "Available targets:"
	@echo "  all                  Build docs and run the full l3build test suite"
	@echo "  build                Build documentation only"
	@echo "  test                 Run the full l3build test suite"
	@echo "  l3build-check        Run l3build checks with pdfTeX"
	@echo "  l3build-luatex-check Run l3build checks with LuaTeX"
	@echo "  l3build-test         Run both l3build check configs"
	@echo "  l3build-clean        Clean l3build-generated artifacts"
	@echo "  install              Install files into the global texmf tree"
	@echo "  local-install        Install files into a local texmf tree"
	@echo "  clean                Remove temporary build files"
	@echo
	@echo "Examples:"
	@echo "  make -C dev all"
	@echo "  make -C dev local-install LOCAL_MKTEX=/path/to/texmf"

install: TEXMFLOCAL := $(TEXMFLOCAL)
install:
	@if [ -z "$(TEXMFLOCAL)" ]; then \
		echo "Error: TEXMFLOCAL is not defined or kpsewhich failed."; exit 1; \
	fi
	@echo "Installing to $(TEXMFLOCAL)"
	@install -d "$(TEXMFLOCAL)/tex/latex/ltmermaid" "$(TEXMFLOCAL)/doc/latex/ltmermaid"
	@install -m 644 $(INSTALL_STY) "$(TEXMFLOCAL)/tex/latex/ltmermaid/"
	@install -m 644 $(INSTALL_DOC) "$(TEXMFLOCAL)/doc/latex/ltmermaid/"
	@mktexlsr "$(TEXMFLOCAL)"

local-install:
	@if [ -z "$(LOCAL_MKTEX)" ]; then \
		echo "Error: LOCAL_MKTEX is not defined."; \
		echo; \
		echo "Usage:"; \
		echo "  make -C dev local-install LOCAL_MKTEX=/path/to/texmf"; \
		echo; \
		exit 1; \
	fi
	@echo "Installing to $(LOCAL_MKTEX)"
	@install -d "$(LOCAL_MKTEX)/tex/latex/ltmermaid" "$(LOCAL_MKTEX)/doc/latex/ltmermaid"
	@install -m 644 $(INSTALL_STY) "$(LOCAL_MKTEX)/tex/latex/ltmermaid/"
	@install -m 644 $(INSTALL_DOC) "$(LOCAL_MKTEX)/doc/latex/ltmermaid/"
	@mktexlsr "$(LOCAL_MKTEX)"

# doc の PDF は Git で管理しているので消さない
clean:
	cd $(TOP) && rm -f *.aux *.log *.out *.toc *.dvi *.fls *.fdb_latexmk
	rm -rf $(TOP)/mermaid/
