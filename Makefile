ELM=elm-make --yes --warn
PAGES=../elm-mdc-gh-pages

all: build-demo

build-demo:
	mkdir -p build
	rsync -r demo/images build
	cp node_modules/material-components-web/dist/material-components-web.css build
	cp demo/page.html build/index.html
	cp elm-global-events/elm-global-events.js build/elm-global-events.js
	cp elm-mdc.js build/elm-mdc.js
	(cd demo; $(ELM) Demo.elm --output ../build/demo.js)

docs:
	$(ELM) --docs=documentation.json

pages: build-demo
	rsync -r build/ $(PAGES)
	(cd $(PAGES); git commit -am "Update."; git push origin gh-pages)

cleanish:
	rm -rf build

clean:
	rm -rf build
	rm -rf elm-stuff/build-artifacts demo/elm-stuff/build-artifacts

distclean:
	rm -rf build
	rm -rf elm-stuff demo/elm-stuff
