module Material.IconToggle exposing
    ( Model
    , defaultModel
    , Msg
    , update
    , Config
    , defaultConfig
    , view
    , Property
    , on
    , icon
    , label
    , inner
    , primary
    , accent
    , disabled
    , render
    , react
    )

import Html exposing (Html, text)
import Material.Component as Component exposing (Index, Indexed)
import Material.Internal.IconToggle exposing (Msg(..))
import Material.Internal.Options as Internal
import Material.Msg
import Material.Options as Options exposing (styled, cs, css, when)


type alias Model =
    Bool


defaultModel : Model
defaultModel =
    False


type alias Msg =
    Material.Internal.IconToggle.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        _ -> model ! []


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


icon : String -> String -> Property m
icon on off =
    Internal.option (\config -> { config | icon = { on = on, off = off } })


label : String -> String -> Property m
label on off =
    Internal.option (\config -> { config | label = { on = on, off = off } })


inner : String -> Property m
inner =
    Internal.option << (\value config -> { config | inner = Just value })


primary : Property m
primary =
    cs "mdc-icon-toggle--primary"


accent : Property m
accent =
    cs "mdc-icon-toggle--accent"


disabled : Property m
disabled =
    cs "mdc-icon-toggle--disabled"


view : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
view lift model options _ =
    let
        ({ config } as summary) =
            Internal.collect defaultConfig options
    in
    Internal.apply summary (if config.inner == Nothing then Html.i else Html.span)
    ( cs "mdc-icon-toggle"
    :: when (config.inner == Nothing) (cs "material-icons")
    :: Options.aria "label" (if config.on then config.label.on else config.label.off)
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
    ]


type alias Store s =
    { s | iconToggle : Indexed Model
    }


( get, set ) =
    Component.indexed .iconToggle (\x y -> { y | iconToggle = x }) defaultModel


react :
    (Material.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Msg.IconToggleMsg (Component.generalise update)


render :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
render =
    Component.render get view Material.Msg.IconToggleMsg
