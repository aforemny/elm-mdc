# Material Design Components for Elm

Port of Google's
[Material Design Lite](https://www.getmdl.io/)
CSS/JS implementation of the
[Material Design Specification](https://www.google.com/design/spec/material-design/introduction.html).

[Live demo](https://debois.github.io/elm-mdl/) & [package documentation](http://package.elm-lang.org/packages/debois/elm-mdl/latest).

[![Build Status](https://travis-ci.org/debois/elm-mdl.svg?branch=master)](https://travis-ci.org/debois/elm-mdl)

### Get Started

Adapt
[examples/Counter.elm](https://github.com/debois/elm-mdl/tree/master/examples) to suit your needs. 
Then refer to the [extensive package
documentation](http://package.elm-lang.org/packages/debois/elm-mdl/latest/), or look at the 
[source](https://github.com/debois/elm-mdl/tree/master/demo) of the 
[Live demo](https://debois.github.io/elm-mdl/), which exercises most components of the library. 


### Contribute

Contributions are warmly encouraged! Whether you are a newcomer to Elm or 
an accomplished expert, the MDL port presents interesting challenges. Refer
to [this page](https://github.com/debois/elm-mdl/blob/master/CONTRIBUTING.md)
for a detailed list of possible contributions. 

### Implementation

MDL is implemented primarily through CSS, with a little bit of JavaScript
adding and removing CSS classes in response to DOM events. This port
re-implements the JavaScript parts in Elm, but relies on the CSS of MDL
verbatim.


