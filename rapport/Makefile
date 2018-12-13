NAME = memoire

all: pdf html

content.md: 00_garde 00_introduction 01_entreprise 02_sujet 03_technique 05_realisations 99_conclusion
	cat 00_garde newpage 00_introduction newpage 01_entreprise newpage 02_sujet newpage 03_technique newpage 05_realisations newpage 99_conclusion > content.md

remerciements.tex: 00_remerciements
	pandoc -V papersize:a4 --from=markdown --to=latex -o remerciements.tex 00_remerciements
	# NE PAS ajouter les remerciements dans le sommaire (ajout d'une étoile)
	sed -i 's/section{/section*{/' remerciements.tex

before.tex: remerciements.tex newpage
	cat newpage remerciements.tex > before.tex

couches.png: couches.dot
	dot -T png couches.dot -o couches.png

cycle_programmes.png: cycle_programmes.dot
	dot -T png cycle_programmes.dot -o cycle_programmes.png

genimages: couches.png cycle_programmes.png

pdf: genimages content.md before.tex
	pandoc -B before.tex -V colorlinks -V fontfamily="utopia" -V fontsize=11pt -V classoption:twoside --number-sections -V graphics --template=default.latex --toc -V toc-title:'Sommaire' -V papersize:a4 --from=markdown --to=latex -o "${NAME}.pdf" content.md

html: genimages content.md
	pandoc --from=markdown --to=html -o "${NAME}.html" content.md

clean:
	rm -f content.md
	rm -f before.tex remerciements.tex
	rm -f ${NAME}.html ${NAME}.pdf
	rm -f couches.png cycle_programmes.png
