## Upgrade to 0.42

* Textfield
  * Box option is now the default, option removed.
  * Remove dense option already, will be removed soon.

* Dialog
  * Surface div is gone. Put header, content and actions directly as children from dialog.
  * Dialog.body is now Dialog.content
  * Dialog.footer is now Dialog.actions.
  * Dialog.header is removed.

* Tabs: replaced by TabBar. Structure mostly the same.
  * Replace `import Material.Tabs as TabBar` with `import Material.TabBar as TabBar`.
  * Remove occurances of `TabBar.indicator`.
  * Icons are handled by setting TabBar.icon property in the tab supplying the right name.

* Lists: two line format needs special primaryText class.

* Updated webpack to latest 4 and webpack-cli to latest 3.
