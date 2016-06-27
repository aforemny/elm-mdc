# Material Design Components in Elm

[![Build Status](https://travis-ci.org/debois/elm-mdl.svg?branch=master)](https://travis-ci.org/debois/elm-mdl)

[Live demo](https://debois.github.io/elm-mdl/).

Port of Google's
[Material Design Lite](https://www.getmdl.io/)
CSS/JS implementation of the
[Material Design Specification](https://www.google.com/design/spec/material-design/introduction.html).

MDL is implemented primarily through CSS, with a little bit of JavaScript
adding and removing CSS classes in response to DOM events. This port
re-implements the JavaScript parts in Elm, but relies on the CSS of MDL
verbatim.

### Get Started

Build the demo:

    > elm-make examples/Demo.elm

This will construct a file `index.html`; open that in your browser.

### Embedding in your own HTML. 

Initial page load of the demo will produce a flicker, which can only be 
avoided if you set up the MDL CSS to load before elm does. Use the file
`page.html` as a template. Find the line containing '**' in 
[demo/Demo.elm](https://github.com/debois/elm-mdl/blob/master/demo/Demo.elm),
follow the instructions there, and build the demo like this: 

    > elm-make demo/Demo.elm --output elm.js

This will produce a file `elm.js`. Open the file 
[`page.html`](https://raw.githubusercontent.com/debois/elm-mdl/master/page.html) in your 
browser; this file will set up MDL CSS and load `elm.js`.

### Contribute

Contributions are warmly encouraged! Whether you are a newcomer to Elm or 
an accomplished expert, the MDL port presents interesting challenges. Refer
to [this page](https://github.com/debois/elm-mdl/blob/master/CONTRIBUTING.md)
for a detailed list of possible contributions. 

