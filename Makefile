elm.js:
	elm-make Demo.elm --output elm.js

clean:
	rm -rf elm-stuff/build-artifacts elm.js

.PHONY: clean elm.js
