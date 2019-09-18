# About

Special branch where the current [live version of the demo](https://aforemny.github.io/elm-mdc/) is located.


# Build

Start with cloning both the current `master` and the special `gh-pages` branch:

```
git clone git@github.com:aforemny/elm-mdc.git
git clone -b gh-pages git@github.com:aforemny/elm-mdc.git elm-mdc-gh-pages
```

Then build the demo:

```
cd elm-mdc
make pages
```

This will automatically update the demo, and commit it.
