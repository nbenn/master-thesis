LATEX=pdflatex
LATEXOPT=--shell-escape
NONSTOP=--interaction=nonstopmode

LATEXMK=latexmk
LATEXMKOPT=-pdf
CONTINUOUS=-pvc

MAIN=00_Master
RESULT=MasterThesis
SUBFILES=$(filter-out $(MAIN).tex, $(wildcard *.tex))
SOURCES=$(MAIN).tex Makefile $(SUBFILES)
FIGURES := $(shell find images/* -type f)

all:    $(RESULT).pdf

.refresh:
		touch .refresh

$(RESULT).pdf: $(MAIN).tex .refresh $(SOURCES) $(FIGURES)
		$(LATEXMK) $(LATEXMKOPT) $(CONTINUOUS) -pdflatex="$(LATEX) $(LATEXOPT) \
		$(NONSTOP) %O %S" $(MAIN)

force:
		touch .refresh
		rm $(RESULT).pdf
		$(LATEXMK) $(LATEXMKOPT) $(CONTINUOUS) -pdflatex="$(LATEX) $(LATEXOPT) \
		%O %S" $(MAIN)

clean:
		$(LATEXMK) -C $(MAIN)
		rm -f $(MAIN).pdfsync
		rm -rf *~ *.tmp
		rm -f *.bbl *.blg *.aux *.end *.fls *.log *.out *.fdb_latexmk

once:
		$(LATEXMK) $(LATEXMKOPT) -pdflatex="$(LATEX) $(LATEXOPT) %O %S" $(MAIN)

debug:
		$(LATEX) $(LATEXOPT) $(MAIN)

.PHONY: clean force once all
