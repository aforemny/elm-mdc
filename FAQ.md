Elm-mdl FAQ
=====================
We want the process of using Elm-mdl as easy and smooth as possible. Check this faq before submitting issues.

**Table of Contents**

- [How do I update this FAQ?](#how-do-i-update-this-faq)
- [General](#general)
  - [Get started?](#get-started)
  - [Get help?](#get-help)
  - [How is Elm-mdl implemented](how-is-elm-mdl-implemented)
  - [Other projects using Elm-mdl](#other-projects-using-elm-mdl)
  - [Should I put MDL in each sub model?](#should-i-put-mdl-in-each-sub-model)
- [Layout component](#layout-component)
  - [Why doesn't layout resize properly?](#why-does-not-layout-resize-properly)
- [Menu component](#menu-component)
  - [Why doesn't menu close on off-menu clicks?](#why-does-not-menu-close-on-off-menu-clicks)
- [Best practices](#best-practices)
  - [Best practice 1?](#best-practice-1)
  - [Best practice 2?](#best-practice-2)
- [Contributing to Elm-mdl](#contributing)
- [Upgrading](upgrading)
  - [Upgrading from 6.x.x](upgrading-from-6.x.x)
- [Troubleshooting errors](#troubleshooting-errors)
  - [Error type?](#error-type)


### How do I update this FAQ?

Create an issue, or fork the FAQ and send a pull request (we can discuss changes and ideas as part of the pull request).


## General

### Get Started

Adapt
[examples/Counter.elm](https://github.com/debois/elm-mdl/tree/master/examples) to suit your needs.
The
[Live demo](https://debois.github.io/elm-mdl/) contains code samples for most components, which
you may find helpful.

For a long-form tutorial, you might like [@jadams](https://github.com/jadams) excellent "Introduction to elm-mdl", available as both a [daily drip video](https://www.dailydrip.com/topics/elm/drips/elm-mdl-introduction) and a very nice [writeup](https://medium.com/@dailydrip/introduction-to-using-material-design-in-elm-dc2320087410#.dodoot1wd).


### Get help
For more in-depth documentation, refer to the [extensive package
documentation](http://package.elm-lang.org/packages/debois/elm-mdl/latest/).

Ask any questions you may have on
[stackoverflow](https://stackoverflow.com/questions/ask?tags=elm+elm-mdl)
or on [#elm-mdl](https://elm.slack.com/messages/elm-mdl) in the elm-slack.

### How is Elm-mdl implemented?

MDL is implemented primarily through CSS, with a little bit of JavaScript
adding and removing CSS classes in response to DOM events. This port
re-implements the JavaScript parts in Elm, but relies on the CSS of MDL
verbatim.
You can do either, but it's easier if you have a separate MDL model in each subcomponent.


### Other projects using Elm-mdl

Check out the [users page](USERS.md) for a list of projects using elm-mdl.


### Should I put MDL in each sub model?
>If I need to use mdl in subcomponents, should I put mdl in each submodel or should I lift all mdl commands to the parent msg and then pass down parent.mdl when rendering subviews?


## Layout component

### Why does not layout resize properly
Fill in text here


## Menu component

### Why does not menu close on off-menu clicks
Fill in text here


## Best practices

### Best practice 1
Some text

### Best practice 2
Some text talking about code

```bash
some code
```

## Contributing
Contributions are warmly encouraged! Whether you are a newcomer to Elm or
an accomplished expert, the MDL port presents interesting challenges. Refer
to [this page](https://github.com/debois/elm-mdl/blob/master/CONTRIBUTING.md)
for a detailed list of possible contributions.

Most importantly: Do [report
bugs](https://github.com/debois/elm-mdl/issues/new). The elm-mdl library
aims to provide a completely smooth experience with Material Design for elm
developers. No bug is too small.

You may want to read the hints on how to get your issue [resolved
quickly](https://github.com/debois/elm-mdl/blob/master/CONTRIBUTING.md#can-i-speed-up-my-issue)
but you don't have to.

## Upgrading

### Upgrading from 6.x.x

The 7.0.0 release changes the required boilerplate in two aspects.

1. The type of elm-mdl messages should now be:

        type Msg =
          ...
          | Mdl (Material.Msg Msg)

2. Dispatching elm-mdl messages should now be:

        update message model =
          case message of
            ...
            Mdl message' ->
              Material.update message' model

Some components (notably menu) has changed API to varying degrees. If you run
into troubles, refer to the code samples in [the
demo](https://debois.github.io/elm-mdl/); check out [the
documentation](http://package.elm-lang.org/packages/debois/elm-mdl/latest/), or
ask on [#elm-mdl in the elm-slack](https://elm.slack.com/messages/elm-mdl) for
help in migrating.


## Troubleshooting errors

### Error type
Solving error type 1
