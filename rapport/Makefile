NAME = memoire

all: pdf html

content.md: 00_garde 00_introduction 01_entreprise 02_sujet 03_technique
	cat 00_garde newpage 00_introduction newpage 01_entreprise newpage 02_sujet newpage 03_technique newpage 99_conclusion > content.md

remerciements.tex: 00_remerciements
	pandoc --template=default.latex -V papersize:a4paper --from=markdown --to=latex -o remerciements.tex 00_remerciements
	# NE PAS ajouter les remerciements dans le sommaire (ajout d'une étoile)
	sed -i 's/section{/section*{/' remerciements.tex

before.tex: remerciements.tex newpage
	cat newpage remerciements.tex > before.tex

pdf: content.md 00_remerciements before.tex
	pandoc -V colorlinks --variable mainfont=Georgia --variable sansfont=Arial --variable monofont="Bitstream Vera Sans Mono" --variable fontsize=11pt -V classoption:twoside --number-sections -V graphics --template=default.latex -B before.tex --toc -V toc-title:'Sommaire' -V papersize:a4paper --from=markdown --to=latex -o "${NAME}.pdf" content.md

html: content.md
	pandoc --from=markdown --to=html -o "${NAME}.html" content.md

clean:
	rm -f content.md
	rm -f before.tex
	rm -f *.html *.pdf
