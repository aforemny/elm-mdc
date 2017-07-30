ELM=elm-make --yes
PAGES=../elm-mdc-gh-pages

demo:
	mkdir -p build
	rsync -r material-components-web/demos/images build
	cp demo/page.html build/index.html
	cp material-components-web/build/material-components-web.css build
	(cd demo; $(ELM) Demo.elm --warn --output ../build/elm.js)

docs:
	$(ELM) --docs=docs.json

pages:
	rsync -r build/ $(PAGES)
	(cd $(PAGES); git commit -am "Update."; git push origin gh-pages)

cleanish:
	rm -rf build

clean: cleanish
	rm -rf elm-stuff/build-artifacts demo/elm-stuff/build-artifacts

distclean : clean
	rm -rf elm-stuff demo/elm-stuff

.PHONY : pages clean cleanish distclean demo docs
