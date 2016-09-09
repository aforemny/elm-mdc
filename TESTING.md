# Testing Elm-mdl

### This is only relevant for developers and contributors to Elm-mdl

Tests are located in a separate *"tests"* folder and does not affect elm-mdl.

Prerequisite: To be able to run tests from your terminal - install node-test-runner by running:
> npm install -g elm-test

Run all tests by executing this command in the root folder:
>elm-test

The travis.yml file has been configured to run elm-test when any branch is pushed to GitHub

**NOTE**

One primary reason to include elm-test now, is to improve the speed of Travis build.
Currently, there are no actual tests implemented. The Material components and Demo components are imported by the testrunner and only verifies that building those modules does not fail.

We should look at other projects to see how to implement tests in Elm-mdl.
- [elm-test](https://github.com/elm-community/elm-test) - The elm-test package used
- [elm-css](https://github.com/rtfeldman/elm-css) - A relevant project using elm-test.
- [elm-combine](https://github.com/Bogdanp/elm-combine) - Another relevant project using elm-test.
- [Caching elm builds on Travis](https://8thlight.com/blog/rob-looby/2016/04/07/caching-elm-builds-on-travis-ci.html)
- [Article on testing in Elm](https://medium.com/@_rchaves_/testing-in-elm-93ad05ee1832#.tr0bpt18s) - Some parts are outdated.
