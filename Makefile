BUILDDIR = .build

LATEX    = pdflatex
LATEXOPT = --shell-escape -file-line-error -synctex=1

LATEXMK    = latexmk
LATEXMKOPT = -pdf -outdir=$(BUILDDIR) -pv-

MAIN     = thesis
TEXSRC   = $(MAIN).tex $(wildcard chapters/*.tex) refs.bib
SETUPSRC = $(wildcard setup/*.tex) $(wildcard setup/*.sty)
FIGURES  = $(wildcard figures/*.pdf) setup/ETHlogo.pdf setup/ETHlogo.ps

all:    $(MAIN).pdf

.refresh:
		touch .refresh

$(MAIN).pdf: $(TEXSRC) $(SETUPSRC) $(FIGURES) .refresh Makefile
		$(LATEXMK) $(LATEXMKOPT) -pdflatex="$(LATEX) $(LATEXOPT) %O %S" \
		$(MAIN).tex
		cp $(BUILDDIR)/$(MAIN).pdf $(MAIN).pdf

force:
		touch .refresh
		$(MAKE) $(MAIN).pdf

.PHONY: clean force all

clean:
		$(LATEXMK) -C $(MAIN).tex
		rm -f $(MAIN).pdfsync
		rm -rf *~ *.tmp
