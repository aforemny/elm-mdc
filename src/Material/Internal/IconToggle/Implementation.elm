module Material.Internal.IconToggle.Implementation exposing
    ( className
    , disabled
    , icon
    , label
    , on
    , Property
    , react
    , view
    )

import Html exposing (Html, text)
import Material.Internal.Component as Component exposing (Index, Indexed)
import Material.Internal.IconToggle.Model exposing (Model, defaultModel, Msg(..))
import Material.Internal.Msg
import Material.Internal.Options as Options exposing (styled, cs, css, when)
import Material.Internal.Options.Internal as Internal
import Material.Internal.Ripple.Implementation as Ripple


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RippleMsg msg_ ->
          let
              ( ripple, effects ) =
                  Ripple.update msg_ model.ripple
          in
          ( { model | ripple = ripple }, Cmd.map RippleMsg effects )


type alias Config =
    { on : Bool
    , label : { on : String, off : String }
    , icon : { on : String, off : String }
    , inner : Maybe String
    }


defaultConfig : Config
defaultConfig =
    { on = False
    , label = { on = "", off = "" }
    , icon = { on = "", off = "" }
    , inner = Nothing
    }


type alias Property m =
    Options.Property Config m


on : Property m
on =
    Internal.option (\config -> { config | on = True })


className : String -> Property m
className className =
    Internal.option (\ config -> { config | inner = Just className })


icon : { on : String, off : String } -> Property m
icon icon =
    Internal.option (\config -> { config | icon = icon })


label : { on : String, off : String } -> Property m
label label =
    Internal.option (\config -> { config | label = label })


disabled : Property m
disabled =
    cs "mdc-icon-toggle--disabled"


iconToggle : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
iconToggle lift model options _ =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options

        ripple =
            Ripple.view True (lift << RippleMsg) model.ripple []
    in
    Internal.apply summary (if config.inner == Nothing then Html.i else Html.span)
    ( cs "mdc-icon-toggle"
    :: when (config.inner == Nothing) (cs "material-icons")
    :: Options.aria "label" (if config.on then config.label.on else config.label.off)
    :: Options.many
       [ ripple.interactionHandler
       , ripple.properties
       ]
    :: options
    )
    []
    [ if config.inner /= Nothing then
          styled Html.i
          [ cs (Maybe.withDefault "material-icons" config.inner)
          , if config.on then
                cs config.icon.on
            else
                cs config.icon.off
          ]
          []
      else
          text (if config.on then config.icon.on else config.icon.off)
    ,
      ripple.style
    ]


type alias Store s =
    { s | iconToggle : Indexed Model
    }


( get, set ) =
    Component.indexed .iconToggle (\x y -> { y | iconToggle = x }) defaultModel


react :
    (Material.Internal.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Internal.Msg.IconToggleMsg (Component.generalise update)


view :
    (Material.Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Component.render get iconToggle Material.Internal.Msg.IconToggleMsg
