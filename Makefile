ELM=elm-make --yes --warn
PAGES=../elm-mdc-gh-pages

all: build-demo

build-demo: material-components-web.css
	mkdir -p build
	rsync -r demo/images build
	cp demo/page.html build/index.html
	cp material-components-web.css build/
	cp elm-mdc.js build/
	(cd demo; $(ELM) Demo.elm --output ../build/demo.js)

material-components-web.css:
	npm i
	cp node_modules/material-components-web/dist/material-components-web.css .

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
