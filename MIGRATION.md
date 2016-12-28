# Migrating from elm 7.x.x to 8.0.0

If you are upgrading from 7.x.x, you will need to change your code as follows.
All necessary changes will be flagged as type errors by the compiler, so you
can use the compiler to identify the necessary changes. 

1. Most event handlers now live in `Options`. E.g., there is no longer a `Button.onClick`; use instead `Options.onClick`.

    _Motivation_. This change is to avoid re-implementing substantial parts
    of `Html.Events` in each component. 

2. `Toggles.onClick` is renamed `Options.onToggle`. 

    _Motivation_. This change enables you to register a regular `onClick` handler
    should you need to. (`onToggle` is a shorthand for registering both 
    `onClick` and `onChange`.)

3. Textfield now takes an extra argument: 

        Textfield.render Mdl [0] model.mdl []           -- 7.x.x

    becomes

        Textfield.render Mdl [0] model.mdl [] []        -- 8.0.0

    _Motivation_. Although never used since a Textfield cannot have child
    elements, this argument makes all elm-mdl `render` functions have the same
    number and meaning of parameters. 
  
4. `Textfield.inner` is renamed `Options.input`. 

    _Motivation_. Some elm-mdl components pretend to be input elements, even though 
    they are implemented as a number of `div`s containing an `input` element
    somewhere. 

5. `Slider.container` is renamed `Slider.element`. 

    _Motivation_. See change (4) above. 

6. `Options.when x y` becomes `Options.when y x` (switch of parameter order). 

    _Motivation_. `when` was intended to be used infix, with backticks, 
    but this usage is no longer supported by Elm 0.18. The switching of 
    parameter order allows using `when` with piping: 

        cs "important-css-class" `when` model.isImportant

    becomes 

        cs "important-css-class" |> when model.isImportant

7. The `Material.update` function now needs a lifting function. 

            Material.update msg model                     -- 7.x.x

        becomes

            Material.update Mdl msg model                 -- 8.0.0
   
    _Motivation_. This change is necessitated by the move away from 
    the [Parts library](https://github.com/debois/elm-parts). 

