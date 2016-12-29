# Contributing

Please do! You can report issues, add documentation, fix bugs, enhance the
demo, or add components. 

Quick links: 
- [Report an issue](#reporting_issues) 
- [Submit a pull request](PR.md)

# Reporting issues

One very helpful and very easy way to contribute is to [open an
issue](https://github.com/debois/elm-mdl/issues/new) for any bug you find. No
bug is too small: we intend elm-mdl to provide a completely smooth experience
with Material Design for elm developers. 

## Can I speed up my issue?

We can't make any promises, but there are a few things you can do to speed up the process: 

- Make sure your issue contains only one bug/feature request. Feel free to open more issues.
- [Search the known issues](https://github.com/debois/elm-mdl/issues) to make
  sure your issue isn't already known. It might have a known workaround. 

     For example, see [#93](https://github.com/debois/elm-mdl/issues/93#issuecomment-234567268).

- Check if your issue is a known bug in Google's Material Design Lite
  ("upstream") and provide a link to the upstream issue if possible. 
  
    It happens frequently that the upstream issue contains an easy solution that
    can't be implemented upstream for backwards compatibility reasons, but which
    we can easily implement in elm-mdl; such issues we can resolve _real_ quick.

    For an example, see
    [#127](https://github.com/debois/elm-mdl/issues/127#issuecomment-236321803). 
- Provide a link where we can see the code that fails. 
- Provide a [PR](https://github.com/debois/elm-mdl/compare) with a fix yourself. 

# Contributing code

TL;DR: Check [this list](https://github.com/debois/elm-mdl/issues?q=is%3Aopen+is%3Aissue+label%3Astarting-point).

The elm-mdl library has opportunities for both newcomers and experienced Elm
programmers: adding documentation, fixing bugs, enhancing the demo and adding
missing features is a good way to get deeper into the language; for experienced
programmers, every step of the way (so far) has been a surprisingly subtle and
complex challenge in finding proper APIs and working around limitations in Elm. 


## Add documentation 

This is perhaps the easiest place to start. In some cases, documentation can be
based more or less directly on the [MDL documentation](getmdl.io/components).
In other cases, you'll need to read the code needing documentation. If you are
new to Elm, this could be a good way to get deeper into the language. 

See the [documentation issue
list](https://github.com/debois/elm-mdl/issues?utf8=%E2%9C%93&q=is%3Aissue+label%3Adocumentation+)

## Improve the demo

The [demo](https://debois.github.io/elm-mdl/) is always in need of attention:
You could add code samples (real easy), add better samples, animations.
Contributing to the demo is an easy place to start and a good way to get
acquainted with the library. 

See the [demo issue list](https://github.com/debois/elm-mdl/issues?utf8=%E2%9C%93&q=is%3Aissue+label%3Ademo).

## Fix bugs

Bugfixes, no matter how small, are always _very_ welcome. 

See the [bug issue list](https://github.com/debois/elm-mdl/issues?utf8=%E2%9C%93&q=is%3Aissue+label%3Abug).

## Enhance existing components

Some components are stable but not fully featured. Adding minor features could be a 
good way to get started. 

See the [enhancement issue
list](https://github.com/debois/elm-mdl/issues?utf8=%E2%9C%93&q=is%3Aissue+label%3Aenhancement).

## Implement new components

The library presently implements all components of Google's Material Design
Lite 1.3.0. But you could contribute a component _not_ covered by MDL.

See the [missing component list](https://github.com/debois/elm-mdl/issues?q=is%3Aissue+is%3Aopen+label%3Acomponent).

If you want to implement a component not on the above list (date/time pickers,
anyone?), we'd love that! Do [open an
issue](https://github.com/debois/elm-mdl/issues/new) for your component before
starting work, to avoid duplication of efforts. 

### Getting started with a new component

Take a look at the source for one of the simpler components: 

1. [Badge](https://github.com/debois/elm-mdl/blob/master/src/Material/Badge.elm). No internal messages. 
2. [Button](https://github.com/debois/elm-mdl/blob/master/src/Material/Button.elm). With internal messages. 

Focus initially on writin a TEA component, then either copy-paste the boilerplate for adding shorthand support, or call out on the 
[#elm-mdl](https://elm.slack.com/messages/elm-mdl) slack. 

Look at
[Layout](https://github.com/debois/elm-mdl/blob/master/src/Material/Layout.elm) to
see how to implement subscriptions. 

To avoid duplication of work, either indicate your interest in an existing issue, or 
[open a new one](https://github.com/debois/elm-mdl/issues/new).

## What's next?

Once you have some code in place, consider taking a look at our guidelines for
[submitting a pull request](PR.md).
