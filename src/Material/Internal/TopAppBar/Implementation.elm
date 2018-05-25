module Material.Internal.TopAppBar.Implementation exposing
    ( actionItem
    , alignEnd
    , alignStart
    , collapsed
    , dense
    , fixed
    , fixedAdjust
    , hasActionItem
    , navigation
    , prominent
    , Property
    , react
    , short
    , section
    , title
    , view
    )

import DOM
import Html exposing (Html, text)
import Json.Decode as Json exposing (Decoder)
import Material.Internal.Component as Component exposing (Indexed, Index)
import Material.Internal.GlobalEvents as GlobalEvents
import Material.Internal.Icon.Implementation as Icon
import Material.Internal.Msg
import Material.Internal.Options as Options exposing (styled, cs, css, when, nop)
import Material.Internal.TopAppBar.Model exposing (Model, defaultModel, Config, defaultConfig, Msg(..))


cssClasses
    : { dense : String
      , fixed : String
      , scrolled: String
      , prominent : String
      , short: String
      , collapsed: String
      }
cssClasses =
    { dense = "mdc-top-app-bar--dense"
    , fixed = "mdc-top-app-bar--fixed"
    , scrolled = "mdc-top-app-bar--fixed-scrolled"
    , prominent = "mdc-top-app-bar--prominent"
    , short = "mdc-top-app-bar--short"
    , collapsed = "mdc-top-app-bar--short-collapsed"
    }


update : Msg -> Model -> ( Model, Cmd m )
update msg model =
    case msg of
        Init config ->
            ( { model | config = Just config }, Cmd.none )

        Scroll config scrollTop ->
            ( { model | scrollTop = scrollTop, config = Just config }, Cmd.none )


decodeScrollTop : Decoder Float
decodeScrollTop =
    DOM.target <|
    Json.at ["ownerDocument", "defaultView", "scrollY"] Json.float


-- VIEW


topAppBar : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
topAppBar lift model options sections =
    let
        ({ config } as summary)=
            Options.collect defaultConfig options
    in
    Options.apply summary Html.header
    (
      cs "mdc-top-app-bar"
    :: ( cs cssClasses.dense |> when config.dense )
    :: ( cs cssClasses.fixed |> when config.fixed )
    :: ( cs cssClasses.scrolled |> when (config.fixed && model.scrollTop > 0) )
    :: ( cs cssClasses.prominent |> when config.prominent )
    :: ( cs cssClasses.short |> when config.short )
    :: ( cs cssClasses.collapsed |> when (config.collapsed || (config.short && model.scrollTop > 0) ) )
    :: ( css "top" ((toString ((round (negate model.scrollTop)))) ++ "px") |> when (not config.fixed && not config.short) )
    :: ( GlobalEvents.onScroll (Json.map (lift << Scroll config) decodeScrollTop)
       )
    :: options
    )
    []
    ( [ row [] sections ] )


row : List (Property m) -> List (Html m) -> Html m
row options =
    styled Html.div
    ( cs "mdc-top-app-bar__row"
    :: options
    )


-- COMPONENT


type alias Store s =
    { s | topAppBar : Indexed Model }


( get, set ) =
    Component.indexed .topAppBar (\x y -> { y | topAppBar = x }) defaultModel


react :
    (Material.Internal.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Internal.Msg.TopAppBarMsg (Component.generalise update)


-- API


type alias Property m =
    Options.Property Config m


view :
    (Material.Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    Component.render get topAppBar Material.Internal.Msg.TopAppBarMsg


dense : Property m
dense =
    Options.option (\ config -> { config | dense = True } )


fixed : Property m
fixed =
    Options.option (\ config -> { config | fixed = True } )


prominent : Property m
prominent =
    Options.option (\ config -> { config | prominent = True } )


short : Property m
short =
    Options.option (\ config -> { config | short = True } )


collapsed : Property m
collapsed =
    Options.option (\ config -> { config | collapsed = True } )


hasActionItem : Property m
hasActionItem =
    cs "mdc-top-app-bar--short-has-action-item"


alignStart : Property m
alignStart =
    cs "mdc-top-app-bar__section--align-start"


alignEnd : Property m
alignEnd =
    cs "mdc-top-app-bar__section--align-end"


navigation : List (Icon.Property m) -> String -> Html m
navigation options name =
    Icon.view
        ( cs "mdc-top-app-bar__navigation-icon"
        :: Icon.anchor
        :: options )
        name


section : List (Property m) -> List (Html m) -> Html m
section options =
    styled Html.section
    ( cs "mdc-top-app-bar__section"
    :: options
    )


title : List (Property m) -> List (Html m) -> Html m
title options =
    styled Html.span
    ( cs "mdc-top-app-bar__title"
    :: options
    )


actionItem : List (Icon.Property m) -> String -> Html m
actionItem options name =
    Icon.view
        ( cs "mdc-top-app-bar__action-item"
        :: Icon.anchor
        :: options )
        name


fixedAdjust : Property m
fixedAdjust =
    cs "mdc-top-app-bar--fixed-adjust"
