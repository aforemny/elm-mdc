PAGES=../elm-mdl-gh-pages

comp: 
	elm-make examples/Component.elm --warn --output elm.js

demo:
	(cd demo; elm-make Demo.elm --warn --output ../elm.js)

docs:
	elm-make --docs=docs.json 

wip-pages : 
	elm-make examples/Demo.elm --output $(PAGES)/wip.js
	(cd $(PAGES); git commit -am "Update."; git push origin gh-pages)

pages : 
	elm-make examples/Demo.elm --output $(PAGES)/elm.js
	(cd $(PAGES); git commit -am "Update."; git push origin gh-pages)

cleanish :
	rm -f elm.js index.html

clean :
	rm -rf elm-stuff/build-artifacts demo/elm-stuff/build-artifacts

distclean : clean
	rm -rf elm-stuff


.PHONY : pages elm.js clean cleanish distclean demo
