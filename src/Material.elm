module Material
    exposing
        ( Model
        , defaultModel
        , Msg
        , update
        , subscriptions
        , init
        , top
        )

{-|
@docs top
-}

import Dict
import Html.Attributes as Html
import Html exposing (Html, text)
import Material.Button as Button
import Material.Checkbox as Checkbox
import Material.Component as Component exposing (Indexed)
import Material.Dispatch as Dispatch
import Material.Drawer as Drawer
import Material.Fab as Fab
import Material.Helpers exposing (map1st)
import Material.IconToggle as IconToggle
import Material.Menu as Menu
import Material.Msg exposing (Msg(..))
import Material.Radio as Radio
import Material.Ripple as Ripple
import Material.Select as Select
import Material.Snackbar as Snackbar
import Material.Switch as Switch
import Material.Tabs as Tabs
import Material.Textfield as Textfield


{-| Material Store
-}
type alias Model = 
    { button : Indexed Button.Model
    , radio : Indexed Radio.Model
    , drawer : Indexed Drawer.Model
    , iconToggle : Indexed IconToggle.Model
    , fab : Indexed Fab.Model
    , textfield : Indexed Textfield.Model
    , menu : Indexed Menu.Model
    , checkbox : Indexed Checkbox.Model
    , switch : Indexed Switch.Model
    , tabs : Indexed Tabs.Model
    , select : Indexed Select.Model
    , ripple : Indexed Ripple.Model
    , snackbar : Indexed Snackbar.Model
    }


{-| Initial Material Store
-}
defaultModel : Model
defaultModel = 
    { button = Dict.empty
    , radio = Dict.empty
    , drawer = Dict.empty
    , iconToggle = Dict.empty
    , fab = Dict.empty
    , textfield = Dict.empty
    , menu = Dict.empty
    , checkbox = Dict.empty
    , switch = Dict.empty
    , tabs = Dict.empty
    , select = Dict.empty
    , ripple = Dict.empty
    , snackbar = Dict.empty
    }


{-| Material message type
-}
type alias Msg m =
    Material.Msg.Msg m


{-| Material update
-}
update : (Msg m -> m) -> Msg m -> { c | mdl : Model } -> (  { c | mdl : Model }, Cmd m )
update lift msg container =
  update_ lift msg (.mdl container)
      |> map1st (Maybe.map (\mdl -> { container | mdl = mdl }))
      |> map1st (Maybe.withDefault container)


update_ : (Msg m -> m) -> Msg m -> Model -> ( Maybe Model, Cmd m )
update_ lift msg store =
    case msg of
       ButtonMsg idx msg ->
           Button.react lift msg idx store

       RadioMsg idx msg ->
           Radio.react lift msg idx store

       DrawerMsg idx msg ->
           Drawer.react lift msg idx store

       IconToggleMsg idx msg ->
           IconToggle.react lift msg idx store

       SnackbarMsg idx msg ->
           Snackbar.react (SnackbarMsg idx >> lift) msg idx store

       FabMsg idx msg ->
           Fab.react lift msg idx store

       TextfieldMsg idx msg ->
           Textfield.react lift msg idx store

       MenuMsg idx msg ->
           Menu.react (MenuMsg idx >> lift) msg idx store

       SelectMsg idx msg ->
           Select.react (SelectMsg idx >> lift) msg idx store

       CheckboxMsg idx msg ->
           Checkbox.react lift msg idx store

       SwitchMsg idx msg ->
           Switch.react lift msg idx store

       TabsMsg idx msg ->
           Tabs.react (TabsMsg idx >> lift) msg idx store

       RippleMsg idx msg ->
           Ripple.react lift msg idx store

       Dispatch msgs -> 
           (Nothing, Dispatch.forward msgs)

{-| Subscriptions and initialisation of elm-mdl. Some components requires
subscriptions in order to function. Hook these up to your containing app as
follows.

    import Material

    type Model =
      { ...
      , mdl : Material.Model
      }

    type Msg =
      ...
      | Mdl (Material.Msg Msg)

    ...

    App.program
      { init = ( model, Material.init Mdl )
      , view = view
      , subscriptions = Material.subscriptions Mdl 
      , update = update
      }

Currently, only Layout and Menu require subscriptions, and only Layout require
initialisation.
-}
subscriptions : (Msg m -> m) -> { model | mdl : Model } -> Sub m
subscriptions lift model =
    Sub.batch
        [ Menu.subs lift model.mdl
        , Select.subs lift model.mdl
        , Drawer.subs lift model.mdl
        ]


{-| Initialisation. See `subscriptions` above.
-}
init : (Msg m -> m) -> Cmd m
init lift =
    Cmd.none


{-| Convenience function to add external CSS and JS scripts to your view
function:

*Note:* This is here only for prototyping. You will want to set this up
properly in your index.html. See TODO.

```
view_ model =
    *your view function*

view model =
    Material.top (view_ model)
```
-}
top : Html a -> Html a
top content =
    Html.div []
    [
      content

    , Html.node "style"
      [ Html.type_ "text/css"
      ]
      [ [ "https://fonts.googleapis.com/css?family=Roboto+Mono"
        , "https://fonts.googleapis.com/icon?family=Material+Icons"
        , "https://fonts.googleapis.com/css?family=Roboto:300,400,500"
        , "https://raw.githubusercontent.com/aforemny/elm-mdc/master/material-components-web.css"
        , "https://raw.githubusercontent.com/aforemny/elm-mdc/master/dialog-polyfill.css"
        ]
        |> List.map (\url ->
               "@import url(" ++ url ++ ");"
           )
        |> String.join "\n"
        |> text
      ]

    , Html.node "script"
      [ Html.type_ "text/javascript"
      , Html.src "https://raw.githubusercontent.com/aforemny/elm-mdc/master/dialog-polyfill.js"
      ]
      []

    , -- node insertion, credits (https://davidwalsh.name/detect-node-insertion):
      Html.node "script"
      [ Html.type_ "text/javascript"
      ]
      [ text """
var insertListener = function(event) {
  if (event.animationName == "nodeInserted") {
    console.warn("Another node has been inserted! ", event, event.target);
    event.target.dispatchEvent(new Event('mdc-init'));
  }
}

document.addEventListener("animationstart", insertListener, false); // standard + firefox
document.addEventListener("MSAnimationStart", insertListener, false); // IE
document.addEventListener("webkitAnimationStart", insertListener, false); // Chrome + Safari
"""
      ]

    , Html.node "script"
      [ Html.type_ "text/css"
      ]
      [ text """
@keyframes nodeInserted {
  from { opacity: 0.99; }
  to { opacity: 1; }
}

.mdc-tab-bar {
  animation-duration: 0.001s;
  animation-name: nodeInserted;
}
"""
      ]
    ]
