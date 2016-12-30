# Release notes 

This release patches various bugs and regressions caused by the Elm 0.18 upgrade, 
and upgrades to [Google MDL v1.3.0](https://github.com/google/material-design-lite/releases/tag/v1.3.0).

## Migration

If you are upgrading from 8.0.0 and manually load MDL CSS, you will need swich 
to loading v1.3.0 CSS. See "Load CSS from HTML" in the 
[`Material.Scheme` documentation](http://package.elm-lang.org/packages/debois/elm-mdl/8.0.1/Material-Scheme)


## Changes

**Bugfixes:**

- Grid: setting size/offset to 0 produces size/offset of 1 [\#241](https://github.com/debois/elm-mdl/issues/241)
- Textfield.value does not update for empty string [\#261](https://github.com/debois/elm-mdl/issues/261)
- Textfield label always floats if Textfield.value is set [\#264](https://github.com/debois/elm-mdl/issues/264)
- Fixed-drawer rendering error [\#258](https://github.com/debois/elm-mdl/issues/258)
- Drawer icon not vertically centered [\#244](https://github.com/debois/elm-mdl/issues/244)


**Documentation fixes:**

- Readme update [\#262](https://github.com/debois/elm-mdl/pull/262) ([JDReutt](https://github.com/JDReutt))

**Internals & building:**

- V8 upgrade and fix elm test [\#259](https://github.com/debois/elm-mdl/pull/259) ([hakonrossebo](https://github.com/hakonrossebo))


[Full Changelog](https://github.com/debois/elm-mdl/compare/8.0.0...HEAD)
