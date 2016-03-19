PAGES=../elm-mdl-gh-pages

elm.js: 
	elm-make examples/Demo.elm --output elm.js

pages : 
	elm-make examples/Demo.elm --output $(PAGES)/elm.js
	(cd $(PAGES); git commit -am "Update."; git push origin gh-pages)

clean :
	rm -f elm.js index.html

veryclean :
	rm -rf elm-stuff/build-artifacts

distclean : clean
	rm -rf elm-stuff


.PHONY : pages elm.js clean veryclean distclean
