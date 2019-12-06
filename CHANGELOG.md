## Latest changes


## Upgrade to 4.0.0

New features:
* Support for the menu selection group.
* Upgrade to MDC 4.0.0. Ripples are now done with internal elements,
  but this should be transparent for the users of this library.
* Selects now display as the enhanced select.

Breaking changes:
* List.ListItem.children had to change, because of support for the Menu Selection Group.
  You probably can simply stick List.HtmlList in front of what you have.
* The select no longer uses the native select control. When an option
  is selected in a select, the displayed text is no longer automatically
  updated. Set the `Select.selectedText` property to the text you want
  to display. You can use `Select.onSelect` to update your model with
  the text to display for example.
  We possibly could have used the nodes of the option that is
  selected, but this gives you fewer options, and the behaviour didn't
  feel entirely Elm like. But feedback appreciated.
* `Select.preselected` has been removed. Use `Select.required` for a similar effect.
* You will need to call `Material.Subscriptions` to make sure you can
  click outside the select menu to close it.
* The Menu used to have the first item selected by default, but it no longer does.
* The obsolete style property from Ripple.bounded and Ripple.unbounded has been removed.

Bug fixes:
* List.selected did set the activated property instead of the selected property.

Possible bugs:
* The selected option when you drop down a select is shown in the
  activated colour in the MDC demo. However it is not clear how this
  is eached, since it uses the selected state like we do, and
  therefere should have the colours of the selected state.
  Exactly why the CSS of the MDC demo is different is not yet known.


## Upgrade to 3.2.0

Breaking changes:
* Removed Toolbar (removed upstream).

Changes:
* Lists: In addition to using selectedIndex you can use the selected
  state on a list item. Depending on the use case on or the other
  might be easier.
* ImageList: added `node` option to easily change the default "div" element to something else.
* TopAppBar: support scrolling on any div by using `onScroll`.
* Menu: a menu item can now be styled in the disabled state.

Fixes:
* Lists: the activated item will receive the keyboard focus by default instead of the first.


## Upgrade to 3.1.1

New features
* Data table support.


## Upgrade to 2.3.1

Changes:
* Snackbar timeout default is now 5 seconds to be compatible with
  the JavaScript version.
* Keyboard support added to menu.

Demo:
* Menu now looks like MDC demo.


## Upgrade to 2.2.0

New features:
* List: add support for disabled items.

Breaking changes:

* Drawer: keyboard navigation and ripples supported. But this means List.nav in
  drawer now takes the three common parameters
* Extended fabs are now supported. The icon parameter has now been replaced with a list.
  Set the icon as option in options: [ Fab.icon "favorites" ]
* Lists now support ripples. To implement this, List.ul, List.ol and
  List.nav now needs the full Mdc, index and model parameters as is
  usual with the other components.
* TopAppBar.navigationIcon and TopAppBar.actionItem need the usual 3
  additional arguments now, in order to implement ripples. It also
  uses a button instead of an a element.
* Textfield: Do not specify outlined for multiline text fields.
* Icon toggle: The icon toggle class has been removed, use IconButton instead.


Implementation changes:

* Ripple code has been improved to emit CSS variables as inline
  styles. There's a bug in Elm that makes this hard, but our
  workaround does not seem to have drawbacks.
  There's a pull request to fix this bug: https://github.com/elm/virtual-dom/pull/127
  You no longer have to use the returned style property, although this
  has been left in the interface so you can update existing code at your leasure.



## Upgrade to 0.44.1

* Textfield:
  * Material.TextField.HelperText now needs to be wrapped in Material.TextField.HelperLine.
  * Support for character counter via Material.TextField.CharacterCounter.


## Upgrade to 0.43

* Snackbar.Contents: new record structure.


## Upgrade to 0.42

* Textfield:
  * Box option is now the default, option removed.
  * Remove dense option already, will be removed soon.
  * unClickable option is removed. Set onLeadingIconClick and
    onTrailingIconClick to indicate actions for any icons.

* Dialog:
  * Surface div is gone. Put header, content and actions directly as children from dialog.
  * Dialog.body is now Dialog.content
  * Dialog.footer is now Dialog.actions.
  * Dialog.header is removed.
  * Dialog.backdrop is removed, see new structure.

* Tabs: replaced by TabBar. Structure mostly the same.
  * Replace `import Material.Tabs as TabBar` with `import Material.TabBar as TabBar`.
  * Remove occurances of `TabBar.indicator`.
  * Icons are handled by setting TabBar.icon property in the tab supplying the right name.

* Updated webpack to latest 4 and webpack-cli to latest 3.

* Select:
  * Select.box variant has been removed as it was removed from mdc.
  * Select.outlined: new variant.

* Lists: two line format needs special primaryText class.


## Upgrade to 0.39

* Material.Drawer.Temporary replaced with Material.Drawer.Modal.
