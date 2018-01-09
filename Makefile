ELM=elm-make --yes --warn

.PHONY: all demo docs pages cleanish clean distclean
.DELETE_ON_ERROR:

all: demo docs

demo: build/demo.js

docs: documentation.json

build: demo/* node_modules/material-components-web/dist/material-components-web.css elm-mdc.js
	mkdir -p build/assets/dialog

	rsync -r demo/images build
	rsync -r demo/assets/dialog build/assets
	cp node_modules/material-components-web/dist/material-components-web.css build

	cp demo/page.html build/index.html
	cp elm-mdc.js build/elm-mdc.js

build/demo.js: build demo/*
	(cd demo; $(ELM) Demo.elm --output ../build/demo.js)

documentation.json: src/*
	$(ELM) --docs=documentation.json

cleanish:
	rm -rf build

clean: cleanish
	rm -rf elm-stuff/build-artifacts demo/elm-stuff/build-artifacts

distclean : clean
	rm -rf elm-stuff demo/elm-stuff
