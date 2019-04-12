## Bug fixes since 1.1.1 release

Stuff missed before I did the 1.1.1 release.

* Do not specify TextField.outlined for multiline text fields.
* The icon toggle class has been removed, use IconButton instead.


## Upgrade to 0.44.1

* Textfield
  * Material.TextField.HelperText now needs to be wrapped in Material.TextField.HelperLine.
  * Support for character counter via Material.TextField.CharacterCounter.


## Upgrade to 0.42

* Textfield
  * Box option is now the default, option removed.
  * Remove dense option already, will be removed soon.
  * unClickable option is removed. Set onLeadingIconClick and
    onTrailingIconClick to indicate actions for any icons.

* Dialog
  * Surface div is gone. Put header, content and actions directly as children from dialog.
  * Dialog.body is now Dialog.content
  * Dialog.footer is now Dialog.actions.
  * Dialog.header is removed.

* Tabs: replaced by TabBar. Structure mostly the same.
  * Replace `import Material.Tabs as TabBar` with `import Material.TabBar as TabBar`.
  * Remove occurances of `TabBar.indicator`.
  * Icons are handled by setting TabBar.icon property in the tab supplying the right name.

* Updated webpack to latest 4 and webpack-cli to latest 3.

* Select:
  * Select.box variant has been removed as it was removed from mdc.
  * Select.outlined: new variant.

* Lists: two line format needs special primaryText class.
