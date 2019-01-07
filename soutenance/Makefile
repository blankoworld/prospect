NAME = soutenance

all: html

flux.png:
	dot -Tpng -o flux.png flux.dot

aujourdhui.png:
	dot -Tpng -o aujourdhui.png aujourdhui.dot

html: slides.md reveal.js flux.png aujourdhui.png
	pandoc -t revealjs -s --self-contained -o "${NAME}.html" slides.md -V revealjs-url=./reveal.js -V theme=sky -V transition=slide -V slideNumber=true

pdf: slides.md flux.png aujourdhui.png
	pandoc -V theme:Boadilla -V fontfamily="utopia" -V fontsize=11pt -V toc-title:'Sommaire' --from=markdown --to=beamer -o "${NAME}.pdf" slides.md

clean:
	rm -f "${NAME}.html" flux.png aujourdhui.png "${NAME}.pdf"
