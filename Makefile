BUILDDIR = .build
TEXTDIR  = chapters
STYLEDIR = setup
FIGDIR   = figures

LATEX    = pdflatex
LATEXOPT = --shell-escape -file-line-error -synctex=1

LATEXMK    = latexmk
LATEXMKOPT = -pdf -outdir=$(BUILDDIR)

MAIN     = thesis
TEXSRC   = $(MAIN).tex $(wildcard $(TEXTDIR)/*.tex) refs.bib
SETUPSRC = $(wildcard $(STYLEDIR)/*.tex) $(wildcard $(STYLEDIR)/*.sty)
FIGURES  = $(wildcard $(FIGDIR)/*.pdf)

export TEXINPUTS:=./$(STYLEDIR):${TEXINPUTS}

all:    $(MAIN).pdf

.refresh:
		touch .refresh

$(MAIN).pdf: $(TEXSRC) $(SETUPSRC) $(FIGURES) .refresh Makefile
		mkdir -p $(BUILDDIR)/$(TEXTDIR)
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
