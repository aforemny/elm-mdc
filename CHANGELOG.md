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
