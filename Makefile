ELM=elm make
PAGES=../elm-mdc-gh-pages

all: build-demo

build-demo: material-components-web.css elm-mdc.js
	mkdir -p build
	rsync -r demo/images build
	cp demo/page.html build/index.html
	cp material-components-web.css build/
	cp demo/styles/main.css build/main.css
	cp elm-mdc.js build/
	(cd demo; $(ELM) --optimize Demo.elm --output ../build/demo.js)

node_modules:
	npm i

material-components-web.css: node_modules
	cp node_modules/material-components-web/dist/material-components-web.css .

elm-mdc.js: node_modules src/elm-mdc.js
	./node_modules/.bin/webpack

docs:
	$(ELM) --docs=docs.json

pages: build-demo
	rsync -r build/ $(PAGES)
	(cd $(PAGES); git commit -am "Update."; git push origin gh-pages)

clean:
	rm -rf build
	rm -rf elm-stuff/build-artifacts demo/elm-stuff/build-artifacts

distclean:
	rm -rf build
	rm -rf elm-stuff demo/elm-stuff
	rm -rf node_modules
	rm -f material-components-web.css
	rm -f elm-mdc.js
