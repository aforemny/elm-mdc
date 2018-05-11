ELM=elm-make --yes --warn
PAGES=../elm-mdc-gh-pages

all: build-demo

build-demo: material-components-web.css elm-mdc.js
	mkdir -p build
	rsync -r demo/images build
	cp demo/page.html build/index.html
	cp material-components-web.css build/
	cp elm-mdc.js build/
	(cd demo; $(ELM) Demo.elm --output ../build/demo.js)

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
	(cd elm-focus-trap; make distclean)
	rm -rf build
	rm -rf elm-stuff demo/elm-stuff
	rm -f elm-autofocus.js elm-focus-trap.js
	rm -f material-components-web.css
	rm -rf node_modules
