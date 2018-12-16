NAME = soutenance

all: html

html: slides.md reveal.js
	pandoc -t revealjs -s --self-contained -o "${NAME}.html" slides.md -V revealjs-url=./reveal.js -V theme=sky -V transition=convex -V slideNumber=true

clean:
	rm -f "${NAME}.html"
