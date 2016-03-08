elm.js:
	elm-make elm-mdl-demo.elm --output elm.js

clean: 
	rm -rf elm-stuff/build-artifacts elm.js

.PHONY: clean elm.js
