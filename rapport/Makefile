NAME = memoire

all: pdf html

content.md: 00_garde 01_entreprise 02_sujet 03_technique
	cat 00_garde newpage 01_entreprise newpage 02_sujet newpage 03_technique > content.md

remerciements.tex: 00_remerciements
	pandoc --template=default.latex -V papersize:a4paper --from=markdown --to=latex -o remerciements.tex 00_remerciements
	# NE PAS ajouter les remerciements dans le sommaire (ajout d'une étoile)
	sed -i 's/section{/section*{/' remerciements.tex

before.tex: remerciements.tex newpage
	cat newpage remerciements.tex > before.tex

pdf: content.md 00_remerciements before.tex
	pandoc -V classoption:twoside -V graphics:true --template=default.latex -B before.tex --toc -V toc-title:'Sommaire' -V papersize:a4paper --from=markdown --to=latex -o "${NAME}.pdf" content.md

html: content.md
	pandoc --from=markdown --to=html -o "${NAME}.html" content.md

clean:
	rm -f content.md
	rm -f before.tex
	rm -f *.html *.pdf
