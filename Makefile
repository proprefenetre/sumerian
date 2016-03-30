## A Makefile in for your markdown-based paper project. 
## Assuming you are using the rest of my templates and toolchain,
## (see http://kieranhealy.org/resources) you can use it
### to create .html, .tex, and .pdf output files (complete with
### bibliography, if present) from your markdown file.
## -    Install the `pandoc-citeproc` and `pandoc-citeproc-preamble`
##      filters for `pandoc`.
## -	Change the paths at the top of the file as needed.
## -	Using `make` without arguments will generate html, tex, and pdf 
## 	output files from all of the files with the designated markdown
##	extension. The default is `.md` but you can change this. 
## -	You can specify an output format with `make tex`, `make pdf` or 
## - 	`make html`. 
## -	Doing `make clean` will remove all the .tex, .html, and .pdf files 
## 	in your working directory. Make sure you do not have files in these
##	formats that you want to keep!

## Markdown extension (e.g. md, markdown, mdown).
MEXT = md

## All markdown files in the working directory
SRC = $(wildcard *.$(MEXT))

## Location of Pandoc support files.
PREFIX = /home/niels/.pandoc
TEMPLATE = $(PREFIX)/templates/notsodefault.latex

## Location of your working bibliography file
BIB = refs.bib

## CSL stylesheet (located in the csl folder of the PREFIX directory).
CSL = $(PREFIX)/csl/apa.csl


PDFS=$(SRC:.md=.pdf)
HTML=$(SRC:.md=.html)
TEX=$(SRC:.md=.tex)
DOCX=$(SRC:.md=.docx)

all:	$(PDFS) $(HTML) $(TEX) $(DOCX)

pdf:	clean $(PDFS)
html:	clean $(HTML)
tex:	clean $(TEX)
docx:	clean $(DOCX)

%.html:	%.md
	pandoc -r markdown+simple_tables+table_captions+yaml_metadata_block -w html -S --template=$(PREFIX)/templates/html.template --css=$(PREFIX)/marked/kultiad-serif.css --filter pandoc-crossref --filter pandoc-citeproc --filter pandoc-citeproc-preamble --csl=$(PREFIX)/csl/$(CSL).csl --bibliography=$(BIB) -o $@ $<

%.tex:	%.md
	pandoc -f markdown+hard_line_breaks -t latex -s -S --latex-engine=pdflatex -V indent -V fontfamily=droid --csl=$(CSL) --template=$(TEMPLATE) --filter pandoc-crossref --filter pandoc-citeproc --filter pandoc-citeproc-preamble --bibliography=$(BIB) -o $@ $<

%.pdf:	%.md
	pandoc -f markdown+hard_line_breaks -t latex -s -S --latex-engine=pdflatex -V color -V indent -V fontfamily=droid -V numbersections --csl=$(CSL) --template=$(TEMPLATE) --filter pandoc-crossref --filter pandoc-citeproc --filter pandoc-citeproc-preamble --bibliography=$(BIB) -o $@ $<

%.docx:	%.md
	pandoc -r markdown+simple_tables+table_captions+yaml_metadata_block -s -S --filter pandoc-crossref --filter pandoc-citeproc --csl=$(PREFIX)/csl/$(CSL).csl --bibliography=$(BIB) -o $@ $<

clean:
	rm -f *.html *.pdf *.tex *.aux *.log *.out *.docx *.run.xml *.bcf *.swp *.swo

.PHONY: clean
