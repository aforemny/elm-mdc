PAGES=../elm-mdl-gh-pages

pages : 
	elm-make examples/Demo.elm --output $(PAGES)/elm.js
	(cd $(PAGES); git commit -am "Update."; git push origin gh-pages)

.phony : pages
