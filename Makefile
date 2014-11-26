NAME  = utfpr-pg
EX    = exemplos
DUM   = dummy
DUMMY = $(DUM)/dummy
TCC   = $(EX)/exemplo-tcc
SHELL = bash
PWD   = $(shell pwd)
TEMP := $(shell mktemp -d)
TDIR  = $(TEMP)/$(NAME)
VERS  = $(shell ltxfileinfo -v $(NAME).dtx)
UTREE = $(shell kpsewhich --var-value TEXMFHOME)
LOCAL = $(shell kpsewhich --var-value TEXMFLOCAL)
all:	$(NAME).pdf clean
$(NAME).pdf: $(NAME).dtx
	pdflatex -shell-escape -recorder $(NAME).dtx
	bibtex $(NAME).aux
	if [ -f $(NAME).glo ]; then makeindex -q -s gglo.ist -o $(NAME).gls $(NAME).glo; fi
	if [ -f $(NAME).idx ]; then makeindex -q -s gind.ist -o $(NAME).ind $(NAME).idx; fi
	pdflatex --recorder --interaction=nonstopmode $(NAME).dtx > /dev/null
	pdflatex --recorder --interaction=nonstopmode $(NAME).dtx > /dev/null
.PHONY: dummy
dummy: $(DUMMY).tex $(NAME).pdf
	pdflatex -shell-escape --output-directory=$(DUM) -recorder $(DUMMY).tex
	cp $(DUMMY).bib ./
	bibtex $(DUMMY).aux
	bibtex $(DUM)/this.aux
	bibtex $(DUM)/thisen.aux
	pdflatex --recorder --interaction=nonstopmode --output-directory=$(DUM) $(DUMMY).tex
	pdflatex --recorder --interaction=nonstopmode --output-directory=$(DUM) $(DUMMY).tex
	make clean
tcc: $(TCC).tex $(NAME).pdf
	pdflatex -shell-escape -recorder --output-directory=$(EX) $(TCC).tex
	cp $(TCC).bib ./
	bibtex $(TCC).aux
	bibtex $(EX)/this.aux
	bibtex $(EX)/thisen.aux
	pdflatex --recorder --interaction=nonstopmode --output-directory=$(EX) $(TCC).tex > /dev/null
	pdflatex --recorder --interaction=nonstopmode --output-directory=$(EX) $(TCC).tex > /dev/null
	make clean
clean:
# We don't want clean to clean all subdirectories files all the time, just the root
	find -maxdepth 1 -iregex '.*\.\(log\|aux\|lof\|lot\|bit\|idx\|glo\|bbl\|ilg\|toc\|ind\|ins\|out\|blg\|synctex.gz\|log\|bm\|brf\|bak\|bst\|fls\|loq\|hd\)' -delete
	rm -f *.bib
distclean:
# we DO need to clean all subfolders
	find -not -path "./.git/*" -iregex '.*\.\(log\|aux\|lof\|lot\|bit\|idx\|glo\|bbl\|ilg\|toc\|ind\|ins\|out\|blg\|synctex.gz\|log\|bm\|brf\|bak\|bst\|fls\|loq\|hd\)' -delete
	rm -f $(NAME).{pdf,cls}
	rm -f $(TCC).{pdf,cls}
# just to play safe
	rm -f *.bib 
inst: all
	mkdir -p $(UTREE)/{tex,source,doc}/latex/$(NAME)
	cp $(NAME).dtx $(UTREE)/source/latex/$(NAME)
	cp $(NAME).cls $(UTREE)/tex/latex/$(NAME)
	cp $(NAME).pdf $(UTREE)/doc/latex/$(NAME)
#install: all
#	mkdir -p $(LOCAL)/{tex,source,doc}/latex/$(NAME)
#	cp $(NAME).dtx $(LOCAL)/source/latex/$(NAME)
#	cp $(NAME).cls $(LOCAL)/tex/latex/$(NAME)
#	cp $(NAME).pdf $(LOCAL)/doc/latex/$(NAME)
zip: all
	mkdir $(TDIR)
	cp $(NAME).{pdf,cls,dtx} $(TDIR)
	cd $(TEMP); zip -Drq $(PWD)/$(NAME)-$(VERS).zip $(NAME)
