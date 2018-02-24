module Material.Toolbar exposing
    ( -- VIEW
      view
    , Property
    , flexibleExpansionRatio -- TODO: demo only

    , fixed
    , waterfall
    , flexible
    , flexibleDefaultBehavior
    , backgroundImage
    , shrinkToFit

    , row
    , section
    , alignStart
    , alignEnd

    , title
    , menuIcon
    , icon

    , fixedAdjust

      -- TEA
    , Model
    , defaultModel
    , Msg
    , update

      -- RENDER
    , render
    , Store
    , react
    )

import Dict exposing (Dict)
import DOM
import GlobalEvents
import Html.Attributes as Html
import Html exposing (Html, text)
import Json.Decode as Json exposing (Decoder)
import Material.Component as Component exposing (Indexed, Index)
import Material.Icon as Icon
import Material.Internal.Options as Internal
import Material.Internal.Toolbar exposing (Msg(..), Geometry, defaultGeometry)
import Material.Msg
import Material.Options as Options exposing (styled, cs, css, when)


cssClasses
    : { fixed : String
      , fixedLastRow : String
      , fixedAtLastRow : String
      , toolbarRowFlexible : String
      , flexibleDefaultBehavior : String
      , flexibleMax : String
      , flexibleMin : String
      }
cssClasses =
    { fixed = "mdc-toolbar--fixed"
    , fixedLastRow = "mdc-toolbar--fixed-lastrow-only"
    , fixedAtLastRow = "mdc-toolbar--fixed-at-last-row"
    , toolbarRowFlexible = "mdc-toolbar--flexible"
    , flexibleDefaultBehavior = "mdc-toolbar--flexible-default-behavior"
    , flexibleMax = "mdc-toolbar--flexible-space-maximized"
    , flexibleMin = "mdc-toolbar--flexible-space-minimized"
    }


strings
    : { titleSelector : String
      , firstRowSelector : String
      , changeEvent : String
      }
strings =
    { titleSelector = "mdc-toolbar__title"
    , firstRowSelector = "mdc-toolbar__row:first-child"
    , changeEvent = "MDCToolbar:change"
    }


numbers
    : { minTitleSize : Float
      , maxTitleSize : Float
      , toolbarRowHeight : Float
      , toolbarRowMobileHeight : Float
      , toolbarMobileBreakpoint : Float
      }
numbers =
    { maxTitleSize = 2.125
    , minTitleSize = 1.25
    , toolbarRowHeight = 64
    , toolbarRowMobileHeight = 56
    , toolbarMobileBreakpoint = 600
    }


type alias Model =
    { geometry : Maybe Geometry
    , scrollTop : Float
    , calculations : Maybe Calculations
    , config : Maybe Config
    }


defaultModel : Model
defaultModel =
    { geometry = Nothing
    , scrollTop = 0
    , calculations = Nothing
    , config = Nothing
    }


type alias Calculations =
    { toolbarRowHeight : Float
    , toolbarRatio : Float
    , flexibleExpansionRatio : Float
    , maxTranslateYRatio : Float
    , scrollThresholdRatio : Float
    , toolbarHeight : Float
    , flexibleExpansionHeight : Float
    , maxTranslateYDistance : Float
    , scrollThreshold : Float
    }


defaultCalculations : Calculations
defaultCalculations =
    { toolbarRowHeight = 0
    , toolbarRatio = 0
    , flexibleExpansionRatio = 0
    , maxTranslateYRatio = 0
    , scrollThresholdRatio = 0
    , toolbarHeight = 0
    , flexibleExpansionHeight = 0
    , maxTranslateYDistance = 0
    , scrollThreshold = 0
    }


type alias Msg =
    Material.Internal.Toolbar.Msg


update : Msg -> Model -> ( Model, Cmd m )
update msg model =
    case msg of
        Init config geometry ->
            let
                calculations =
                    initKeyRatio config geometry
                    |> setKeyHeights geometry
            in
            (
              { model
                | geometry = Just geometry
                , calculations = Just calculations
                , config = Just config
              }
            ,
              Cmd.none
            )

        Resize config geometry ->
            let
                calculations =
                    Maybe.map (setKeyHeights geometry) model.calculations
            in
            (
              { model
                | geometry = Just geometry
                , calculations = calculations
                , config = Just config
              }
            ,
              Cmd.none
            )

        Scroll config scrollTop ->
            ( { model | scrollTop = scrollTop, config = Just config }, Cmd.none )


type alias Config =
    Material.Internal.Toolbar.Config


defaultConfig : Config
defaultConfig =
    Material.Internal.Toolbar.defaultConfig


type alias Property m =
    Options.Property Config m


view : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
view lift model options nodes =
    let
        ({ config } as summary)=
            Internal.collect defaultConfig options

        { toolbarProperties
        , flexibleRowElementStyles
        , elementStylesDefaultBehavior
        } =
            Maybe.map2
                (\ geometry calculations ->
                    toolbarStyles config geometry model.scrollTop calculations
                )
                model.geometry
                model.calculations
            |> Maybe.map (\ styles ->
                   { toolbarProperties = Just styles.toolbarProperties
                   , flexibleRowElementStyles = styles.flexibleRowElementStyles
                   , elementStylesDefaultBehavior = styles.elementStylesDefaultBehavior
                   }
               )
            |> Maybe.withDefault
                   { toolbarProperties = Nothing
                   , flexibleRowElementStyles = Nothing
                   , elementStylesDefaultBehavior = Nothing
                   }

        flexibleRowElementStylesHack =
            flexibleRowElementStyles
            |> Maybe.map (\ { height } ->
                   let
                       className =
                           "mdc-toolbar-flexible-row-element-styles-hack-"
                           ++ (String.join "-" (String.split "." height))

                       text =
                           "." ++ className
                           ++ " .mdc-toolbar__row:first-child{height:" ++ height ++ ";}"
                   in
                   { className = className, text = text }
               )

        elementStylesDefaultBehaviorHack =
            elementStylesDefaultBehavior
            |> Maybe.map (\ { fontSize } ->
                   let
                       className =
                           "mdc-toolbar-flexible-default-behavior-hack-"
                           ++ (String.join "-" (String.split "." fontSize))

                       text =
                           "." ++ className
                           ++ " .mdc-toolbar__title{font-size:" ++ fontSize ++ ";}"
                   in
                   { className = className, text = text }
               )

        backgroundImageHack =
            config.backgroundImage
            |> Maybe.map (\ backgroundImage ->
                   let
                       className =
                           (++) "mdc-toolbar-background-image-back-"
                               ( backgroundImage
                                 |> String.split "."
                                 |> String.join "-"
                                 |> String.split "/"
                                 |> String.join "-"
                               )

                       text =
                           "." ++ className
                           ++ " .mdc-toolbar__row:first-child::after {"
                           ++ "background-image:url(" ++ backgroundImage ++ ");"
                           ++ "background-position:center;"
                           ++ "background-size:cover;}"
                   in
                   { className = className, text = text }
               )
    in
    Internal.apply summary
    Html.header
    (
      cs "mdc-toolbar"
    :: ( when config.fixed <|
         cs cssClasses.fixed
       )
    :: ( when (config.fixed && config.fixedLastrow) <|
         cs cssClasses.fixedLastRow
       )
    :: ( when config.waterfall <|
         cs "mdc-toolbar--waterfall"
       )
    :: ( when config.flexible <|
         cs "mdc-toolbar--flexible"
       )
    :: ( when (config.flexible && config.useFlexibleDefaultBehavior) <|
         cs "mdc-toolbar--flexible-default-behavior"
       )
    :: ( when (model.geometry == Nothing) <|
         Options.many << List.map Options.attribute <|
         GlobalEvents.onTick (Json.map (lift << Init config) decodeGeometry)
       )
    :: ( Options.many << List.map Options.attribute <|
         GlobalEvents.onResize (Json.map (lift << Resize config) decodeGeometry)
       )
    :: ( Options.many << List.map Options.attribute <|
         GlobalEvents.onScroll (Json.map (lift << Scroll config) decodeScrollTop)
       )
    :: ( toolbarProperties
         |> Maybe.map Options.many
         |> Maybe.withDefault Options.nop
       )
    :: ( flexibleRowElementStylesHack
         |> Maybe.map (.className >> cs)
         |> Maybe.withDefault Options.nop
       )
    :: ( elementStylesDefaultBehaviorHack
         |> Maybe.map (.className >> cs)
         |> Maybe.withDefault Options.nop
       )
    :: ( backgroundImageHack
         |> Maybe.map (.className >> cs)
         |> Maybe.withDefault Options.nop
       )
    :: options
    )
    []
    ( nodes ++ [
          Html.node "style"
          [ Html.type_ "text/css"
          ]
          [ text <|
            String.join "\n" <|
            List.filterMap (Maybe.map .text)
            [ flexibleRowElementStylesHack
            , elementStylesDefaultBehaviorHack
            , backgroundImageHack
            ]
          ]
       ]
    )


waterfall : Property m
waterfall =
    Internal.option (\ config -> { config | waterfall = True } )


fixed : Property m
fixed =
    Internal.option (\ config -> { config | fixed = True } )


flexible : Property m
flexible =
    Internal.option (\ config -> { config | flexible = True } )


backgroundImage : String -> Property m
backgroundImage backgroundImage =
    Internal.option (\ config -> { config | backgroundImage = Just backgroundImage } )


fixedLastRow : Property m
fixedLastRow =
    Internal.option (\ config -> { config | fixedLastrow = True })


icon : List (Icon.Property m) -> String -> Html m
icon options icon =
    Icon.view
    ( cs "mdc-toolbar__icon"
    :: options
    )
    icon


menuIcon : List (Icon.Property m) -> String -> Html m
menuIcon options icon =
    Icon.view
    ( cs "mdc-toolbar__menu-icon"
    :: options
    )
    icon


title : List (Property m) -> List (Html m) -> Html m
title options =
    styled Html.span
    ( cs "mdc-toolbar__title"
    :: options
    )


row : List (Property m) -> List (Html m) -> Html m
row options =
    styled Html.div
    ( cs "mdc-toolbar__row"
    :: options
    )


section : List (Property m) -> List (Html m) -> Html m
section options =
    styled Html.section
    ( cs "mdc-toolbar__section"
    :: options
    )


alignStart : Property m
alignStart =
    cs "mdc-toolbar__section--align-start"


alignEnd : Property m
alignEnd =
    cs "mdc-toolbar__section--align-end"


shrinkToFit : Property m
shrinkToFit =
    cs "mdc-toolbar__section--shrink-to-fit"


flexibleDefaultBehavior : Property m
flexibleDefaultBehavior =
    Internal.option (\ config -> { config | useFlexibleDefaultBehavior = True })


fixedAdjust : List Int -> Store s -> Options.Property c m
fixedAdjust index store =
    let
        model =
            Dict.get index store.toolbar
            |> Maybe.withDefault defaultModel

        styles =
            Maybe.map2 (,) model.config model.calculations
            |> Maybe.andThen (\ ( config, calculations ) ->
                   adjustElementStyles config calculations
               )
    in
    Options.many
    [ cs "mdc-toolbar-fixed-adjust"
    , Maybe.withDefault Options.nop styles
    ]


adjustElementStyles : Config -> Calculations -> Maybe (Options.Property c m)
adjustElementStyles config calculations =
    let
        marginTop =
            calculations.toolbarHeight
    in
    if config.fixed then
        Just (css "margin-top" (toString marginTop ++ "px"))
    else
        Nothing


flexibleExpansionRatio : Calculations -> Float -> Float
flexibleExpansionRatio calculations scrollTop =
    let
        delta = 0.0001
    in
    max 0 (1 - scrollTop / (calculations.flexibleExpansionHeight + delta))


initKeyRatio : Config -> Geometry -> Calculations
initKeyRatio config geometry =
    let
        toolbarRowHeight =
            geometry.getRowHeight

        firstRowMaxRatio =
            if toolbarRowHeight == 0 then
                0
            else
                geometry.getFirstRowElementOffsetHeight / toolbarRowHeight

        toolbarRatio =
            if toolbarRowHeight == 0 then
                0
            else
                geometry.getOffsetHeight / toolbarRowHeight

        flexibleExpansionRatio =
            firstRowMaxRatio - 1

        maxTranslateYRatio =
            if config.fixedLastrow then
                toolbarRatio - firstRowMaxRatio
            else
                0

        scrollThresholdRatio =
            if config.fixedLastrow then
                toolbarRatio - 1
            else
                firstRowMaxRatio - 1
    in
    { defaultCalculations
        | toolbarRatio = toolbarRatio
        , flexibleExpansionRatio = flexibleExpansionRatio
        , maxTranslateYRatio = maxTranslateYRatio
        , scrollThresholdRatio = scrollThresholdRatio
    }


setKeyHeights : Geometry -> Calculations -> Calculations
setKeyHeights geometry calculations =
    let
        toolbarRowHeight =
            geometry.getRowHeight

        toolbarHeight =
            calculations.toolbarRatio * toolbarRowHeight

        flexibleExpansionHeight =
            calculations.flexibleExpansionRatio * toolbarRowHeight

        maxTranslateYDistance =
            calculations.maxTranslateYRatio * toolbarRowHeight

        scrollThreshold =
            calculations.scrollThresholdRatio * toolbarRowHeight
    in
    { calculations
        | toolbarRowHeight = toolbarRowHeight
        , toolbarHeight = toolbarHeight
        , flexibleExpansionHeight = flexibleExpansionHeight
        , maxTranslateYDistance = maxTranslateYDistance
        , scrollThreshold = scrollThreshold
    }


toolbarStyles
    : Config
    -> Geometry
    -> Float
    -> Calculations
    -> { toolbarProperties : List (Property m)
       , flexibleRowElementStyles : Maybe { height : String }
       , elementStylesDefaultBehavior : Maybe { fontSize : String }
       }
toolbarStyles config geometry scrollTop calculations =
    let
        hasScrolledOutOfThreshold =
            scrollTop > calculations.scrollThreshold

        flexibleExpansionRatio_ =
            flexibleExpansionRatio calculations scrollTop

        toolbarFlexibleState =
            case flexibleExpansionRatio_ of
              1 ->
                  cs cssClasses.flexibleMax
              0 ->
                  cs cssClasses.flexibleMin
              _ ->
                  Options.nop

        toolbarFixedState =
            let
                translateDistance =
                    max 0 <|
                    min (scrollTop - calculations.flexibleExpansionHeight) <|
                    (calculations.maxTranslateYDistance)
            in
            when config.fixedLastrow << Options.many <|
            [ css "transform" ("translateY(-" ++ toString translateDistance ++ "px)")
            , when (translateDistance == calculations.maxTranslateYDistance) <|
              cs cssClasses.fixedAtLastRow
            ]

        flexibleRowElementStyles =
            if config.flexible && config.fixed then
                let
                    height =
                        calculations.flexibleExpansionHeight * flexibleExpansionRatio_
                in
                Just { height = toString (height + calculations.toolbarRowHeight) ++ "px" }
            else
                Nothing

        elementStylesDefaultBehavior =
            if config.useFlexibleDefaultBehavior then
                let
                    maxTitleSize =
                        numbers.maxTitleSize

                    minTitleSize =
                        numbers.minTitleSize

                    currentTitleSize =
                        (maxTitleSize - minTitleSize) * flexibleExpansionRatio_
                        + minTitleSize
                in
                Just { fontSize = toString currentTitleSize ++ "rem" }
            else
                Nothing
    in
    { toolbarProperties =
          [ toolbarFlexibleState
          , toolbarFixedState
          ]
    , flexibleRowElementStyles =
          flexibleRowElementStyles
    , elementStylesDefaultBehavior =
          elementStylesDefaultBehavior
    }


type alias Store s =
    { s | toolbar : Indexed Model }


( get, set ) =
    Component.indexed .toolbar (\x y -> { y | toolbar = x }) defaultModel


render :
    (Material.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
render =
    Component.render get view Material.Msg.ToolbarMsg


react :
    (Material.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Msg.ToolbarMsg (Component.generalise update)


decodeGeometry : Decoder Geometry
decodeGeometry =
    let
      viewportWidth =
          DOM.target <|
          Json.at ["ownerDocument", "defaultView", "innerWidth"] Json.float

      getRowHeight =
          viewportWidth
          |> Json.map (\ viewportWidth ->
                 if viewportWidth < numbers.toolbarMobileBreakpoint then
                     numbers.toolbarRowMobileHeight
                 else
                     numbers.toolbarRowHeight
             )

      getFirstRowElementOffsetHeight =
          firstRowElement DOM.offsetHeight

      firstRowElement decoder =
          DOM.target <|
          DOM.childNode 0 decoder

      getOffsetHeight =
          DOM.target <|
          DOM.offsetHeight
    in
    Json.map3 (\ getRowHeight getFirstRowElementOffsetHeight getOffsetHeight ->
          { getRowHeight = getRowHeight
          , getFirstRowElementOffsetHeight = getFirstRowElementOffsetHeight
          , getOffsetHeight = getOffsetHeight
          }
      )
      getRowHeight
      getFirstRowElementOffsetHeight
      getOffsetHeight


decodeScrollTop : Decoder Float
decodeScrollTop =
    DOM.target <|
    Json.at ["ownerDocument", "defaultView", "scrollY"] Json.float
