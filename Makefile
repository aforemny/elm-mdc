ELM=elm-make --yes --warn
PAGES=../elm-mdc-gh-pages

all:
	mkdir -p build
	rsync -r material-components-web/demos/images build
	cp demo/page.html build/index.html
	#cp material-components-web/build/material-components-web.css build
	cp node_modules/material-components-web/dist/material-components-web.css build
	(cd demo; $(ELM) Demo.elm --output ../build/elm.js)

docs:
	$(ELM) --docs=documentation.json

pages:
	rsync -r build/ $(PAGES)
	(cd $(PAGES); git commit -am "Update."; git push origin gh-pages)

cleanish:
	rm -rf build

clean: cleanish
	rm -rf elm-stuff/build-artifacts demo/elm-stuff/build-artifacts

distclean : clean
	rm -rf elm-stuff demo/elm-stuff
