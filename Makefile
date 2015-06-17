BUILDDIR = .build
TEXTDIR  = chapters
STYLEDIR = setup
FIGDIR   = figures
DATADIR  = data
RDIR     = R
CACHEDIR = .cache

LATEX    = pdflatex
LATEXOPT = --shell-escape -file-line-error -synctex=1

LATEXMK    = latexmk
LATEXMKOPT = -pdf -outdir=$(BUILDDIR)

MAIN     = thesis
RNWSRC   = $(basename $(wildcard $(RDIR)/*.Rnw) $(wildcard $(RDIR)/*/*.Rnw))
RSRC     = $(wildcard $(RDIR)/*.R)
TEXSRC   = $(MAIN).tex $(wildcard $(TEXTDIR)/*.tex) $(addsuffix .tex,$(RNWSRC))
SETUPSRC = $(wildcard $(STYLEDIR)/*.tex) $(wildcard $(STYLEDIR)/*.sty)
TEXTSRC  = $(TEXSRC) mendeley.bib $(SETUPSRC)
FIGURES  = $(wildcard $(FIGDIR)/*.pdf) $(wildcard $(FIGDIR)/*.eps)
DATA     = $(wildcard $(DATADIR)/*/*.csv)

all: $(MAIN).pdf

.refresh:
		touch .refresh

%.tex: %.Rnw
		Rscript \
			  -e "library(knitr)" \
			  -e "knitr::opts_chunk[['set']](fig.path='$(FIGDIR)/$*-')" \
			  -e "knitr::opts_chunk[['set']](cache.path='$(CACHEDIR)/$*-')" \
			  -e "knitr::opts_chunk[['set']](dev=c('pdf', 'postscript'))" \
			  -e "knitr::knit('$<','$@')"

$(MAIN).pdf: $(TEXTSRC) $(FIGURES) $(DATA) $(RSRC) .refresh Makefile
		mkdir -p $(BUILDDIR)/$(TEXTDIR)
		$(LATEXMK) $(LATEXMKOPT) -pdflatex="$(LATEX) $(LATEXOPT) %O %S" \
		$(MAIN).tex
		cp $(BUILDDIR)/$(MAIN).pdf $(MAIN).pdf

force:
		touch .refresh
		$(MAKE) $(MAIN).pdf

.PHONY: clean force all

print-%  : ; @echo $* = $($*)

clean:
		$(LATEXMK) -C $(MAIN).tex
		rm -f $(MAIN).pdfsync
		rm -rf *~ *.tmp
