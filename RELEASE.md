# Release notes

This release embodies a major re-working of elm-mdl internals:

##### Upgrade to Elm 0.18. 
Many thanks to @MichaelCombs28 for providing a
   temporary elm-mdl upgrade fork when we were too slow to upgrade the main
   repo.

##### Elm-mdl no longer relies on Parts
We removed all dependencies on the [Parts
library](https://github.com/debois/elm-parts).  This change essentially _does
not_ affect the elm-mdl API. You still use the `render` function to construct
elm-mdl widgets; you still do not have to represent them explicitly in your
model.  

This change puts elm-mdl in conformance with 
[component
guidelines](https://github.com/evancz/elm-sortable-table#usage-rules) from Elm
language creators; in particular, elm-mdl no longer dispatches function values
in messages. 

You can observe this change by adding `Debug.log msg` someplace; you will
then be able to see readable, serialisable elm-mdl messages in your
browser's Javascript Console. 

##### Support for arbitrary attributes and event handlers

You can now add any attribute of `Html.Attributes.*`  to any elm-mdl widget. If
you are adding event handlers, please do not use attributes from `Html.Events`,
but use instead the ones from `Material.Options`. Using the latter ensures that
if you are registering a handler for an event that elm-mdl also processes
internally, _both_ handlers will trigger. 

This change is due to very sophisticated work by @vipentti, and relies on his
[Dispatch](https://github.com/vipentti/elm-dispatch) to manage multiple 
subscriptions to the same event. 

## Migration

If you are upgrading from 7.x.x, this release requires some migration. See
[MIGRATION.md](https://github.com/debois/elm-mdl/blob/v8/MIGRATION.md) for
details. 

## Changes

**Features:**

- Arbitrary attributes and event-handler support [\#208](https://github.com/debois/elm-mdl/issues/208) [\#213](https://github.com/debois/elm-mdl/pull/213) [\#179](https://github.com/debois/elm-mdl/pull/179) ([vipentti](https://github.com/vipentti))
- Support for `href` on buttons [\#201](https://github.com/debois/elm-mdl/issues/201) [\#235](https://github.com/debois/elm-mdl/pull/235) ([vipentti](https://github.com/vipentti))
- Initial implementation of Link buttons  ([vipentti](https://github.com/vipentti))
- Support for expandable textfields [\#198](https://github.com/debois/elm-mdl/issues/198) [\#199](https://github.com/debois/elm-mdl/pull/199) ([vipentti](https://github.com/vipentti))
- Support for Elm 0.18 [\#253](https://github.com/debois/elm-mdl/issues/253) ([debois](https://github.com/debois), special thanks to [MichaelCombs28](https://github.com/MichaelCombs28))
- Support input with type ‘email’ [\#246](https://github.com/debois/elm-mdl/pull/246) ([rmies](https://github.com/rmies))

**Bugfixes:**

- Layout.navigation ignores styles [\#232](https://github.com/debois/elm-mdl/pull/232) ([bparadie](https://github.com/bparadie))
- Cannot set tabindex on Textfield [\#191](https://github.com/debois/elm-mdl/issues/191)

**Documentation fixes:**

- Layout's code demo mentions tabs = \[\] while it should be tabs = \(\[\], \[\]\) [\#242](https://github.com/debois/elm-mdl/issues/242)
- Cards demo with wrong "Demo Source" link [\#238](https://github.com/debois/elm-mdl/pull/238) ([tiago-pereira](https://github.com/tiago-pereira))
- \#256 broken source code link fixed [\#257](https://github.com/debois/elm-mdl/pull/257) ([swojtasiak](https://github.com/swojtasiak))
- Fix source URL typo on Cards page [\#252](https://github.com/debois/elm-mdl/pull/252) ([MoonlightOwl](https://github.com/MoonlightOwl))
- Update broken Demo link references [\#245](https://github.com/debois/elm-mdl/pull/245) ([torresmi](https://github.com/torresmi))
- Fix error in example usage of spinner [\#234](https://github.com/debois/elm-mdl/pull/234) ([DavidDTA](https://github.com/DavidDTA))
- Add a separate listing of templates [\#230](https://github.com/debois/elm-mdl/pull/230) ([hakonrossebo](https://github.com/hakonrossebo))
- Change links from fixed to relative [\#228](https://github.com/debois/elm-mdl/pull/228) ([hakonrossebo](https://github.com/hakonrossebo))
- Correct project description in USERS.md [\#225](https://github.com/debois/elm-mdl/pull/225) ([IwalkAlone](https://github.com/IwalkAlone))
- type alias, not type [\#223](https://github.com/debois/elm-mdl/pull/223) ([willnwhite](https://github.com/willnwhite))
- Add reference implementation and repository for Offtie.com [\#222](https://github.com/debois/elm-mdl/pull/222) ([hakonrossebo](https://github.com/hakonrossebo))
- Add knewter/time-tracker to USERS.md [\#219](https://github.com/debois/elm-mdl/pull/219) ([knewter](https://github.com/knewter))

**Internals & building:**

- Add a commit hook to warn on incorrect commit message [\#233](https://github.com/debois/elm-mdl/pull/233) ([hakonrossebo](https://github.com/hakonrossebo))
- Elm-test framework and Travis CI speed improvements [\#210](https://github.com/debois/elm-mdl/pull/210) ([hakonrossebo](https://github.com/hakonrossebo))

[Full Changelog](https://github.com/debois/elm-mdl/compare/7.6.0...HEAD)
