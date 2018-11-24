NAME = memoire

all: pdf html

content.md: 00_garde 01_entreprise 02_sujet 03_technique
	cat 00_garde newpage 01_entreprise newpage 02_sujet newpage 03_technique > content.md

pdf: content.md
	pandoc --toc --from=markdown --to=latex -o "${NAME}.pdf" content.md

html: content.md
	pandoc --from=markdown --to=html -o "${NAME}.html" content.md

clean:
	rm -f content.md
	rm -f *.html *.pdf
