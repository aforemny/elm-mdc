module Material.Toolbar exposing
    ( -- VIEW
      view
    , Property

    , fixed
    , waterfall
    , flexible
    , backgroundImage
    , fixedLastRow

    , row
    , section
    , alignStart
    , alignEnd

    , title
    , menu
    , icon
    , icon_

    , fixedAdjust

      -- TEA
    , subscriptions
    , Model
    , defaultModel
    , Msg
    , update

      -- RENDER
    , subs
    , render
    , Store
    , react
    )

import AnimationFrame
import DOM
import Html exposing (Html, text)
import Json.Decode as Json exposing (Decoder)
import Material.Component as Component exposing (Indexed, Index)
import Material.Internal.Options as Internal
import Material.Internal.Toolbar exposing (Msg(..), Geometry, defaultGeometry)
import Material.Msg
import Material.Options as Options exposing (styled, cs, css, when)
import Window


type alias Model =
    { calculations : Calculations
    , geometry : Maybe Geometry
    , initialized : Bool
    , requestAnimation : Bool
    }


defaultModel : Model
defaultModel =
    { calculations = defaultCalculations
    , geometry = Nothing
    , initialized = False
    , requestAnimation = True
    }


type alias Calculations =
    { toolbarRowHeight : Float
    , toolbarHeight : Float
    , toolbarRatio : Float
    , flexibleExpansionHeight : Float
    , flexibleExpansionRatio : Float
    , maxTranslateYDistance : Float
    , maxTranslateYRatio : Float
    , scrollThreshold : Float
    , scrollThresholdRatio : Float
    }


defaultCalculations : Calculations
defaultCalculations =
    { toolbarRowHeight = 0
    , toolbarHeight = 0
    , toolbarRatio = 0
    , flexibleExpansionHeight = 0
    , flexibleExpansionRatio = 0
    , maxTranslateYDistance = 0
    , maxTranslateYRatio = 0
    , scrollThreshold = 0
    , scrollThresholdRatio = 0
    }


calculate : Config -> Geometry -> Float -> Calculations
calculate config geometry scrollTop =
    let
        fixedLastRow =
            config.fixedLastRow

        initKeyRatio calculations =
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
                    if fixedLastRow then
                        toolbarRatio - firstRowMaxRatio
                    else
                        0
                scrollThresholdRatio =
                    if fixedLastRow then
                        toolbarRatio - 1
                    else
                        firstRowMaxRatio - 1
            in
            { calculations
                | toolbarRatio = toolbarRatio
                , flexibleExpansionRatio = flexibleExpansionRatio
                , maxTranslateYRatio = maxTranslateYRatio
                , scrollThresholdRatio = scrollThresholdRatio
            }

        setKeyHeights calculations =
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

        updateToolbarStyles calculations =
            let
                hasScrolledOutOfThreshold =
                    scrollTop > calculations.scrollThreshold

                flexibleExpansionRatio =
                    max 0 ( 1 - scrollTop / (calculations.flexibleExpansionHeight + 0.0001) )
            in
            { calculations
                | flexibleExpansionRatio = flexibleExpansionRatio
            }
    in
      defaultCalculations
      |> initKeyRatio
      |> setKeyHeights
      |> updateToolbarStyles


resize : Geometry -> Calculations -> Calculations
resize geometry calculations =
    let
        toolbarRowHeight =
            geometry.getRowHeight

        toolbarHeight =
            calculations.toolbarRatio * calculations.toolbarRowHeight

        flexibleExpansionHeight =
            calculations.flexibleExpansionRatio * toolbarRowHeight

        maxTranslateYDistance =
            calculations.maxTranslateYRatio * toolbarRowHeight

        scrollThreshold =
            calculations.scrollThreshold * toolbarRowHeight
    in
    if toolbarRowHeight /= calculations.toolbarRowHeight then
        { calculations
            | toolbarRowHeight = toolbarRowHeight
            , toolbarHeight = toolbarHeight
            , flexibleExpansionHeight = flexibleExpansionHeight
            , maxTranslateYDistance = maxTranslateYDistance
            , scrollThreshold = scrollThreshold
        }
    else
        calculations


type alias Msg =
    Material.Internal.Toolbar.Msg


update : Msg -> Model -> ( Model, Cmd m )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        Init geometry ->
            ( { model | geometry = Just geometry, initialized = True }, Cmd.none )

        Resize ->
            ( { model | requestAnimation = True }, Cmd.none )

        AnimationFrame ->
            if model.requestAnimation then
                ( { model
                    | requestAnimation = False
                    , initialized = False
                  }
                ,
                  Cmd.none
                )
            else
                ( model, Cmd.none )


type alias Config =
    { flexible : Maybe Float
    , waterfall : Maybe Float
    , backgroundImage : Maybe String
    , fixedLastRow : Bool
    }


defaultConfig : Config
defaultConfig =
    { flexible = Nothing
    , waterfall = Nothing
    , backgroundImage = Nothing
    , fixedLastRow = False
    }


type alias Property m =
    Options.Property Config m


view : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
view lift model options nodes =
    let
        ({ config } as summary)=
            Internal.collect defaultConfig options

        initOn event =
            Options.on event (Json.map (Init >> lift) decodeGeometry)

        scrollTop =
            case config.flexible of
                Just scrollTop ->
                    Just scrollTop
                Nothing ->
                    config.waterfall

        ( flexibleBehavior, backgroundImage ) =
             case (scrollTop, model.geometry) of
                 (Just scrollTop, Just geometry) ->
                    let
                        calculations =
                            calculate config geometry scrollTop

                        backgroundImage =
                            case config.backgroundImage of
                                Just url ->
                                    [ styled Html.div
                                      [ css "background-image" ("url(" ++ url ++ ")")
                                      , css "background-size" "cover"
                                      , css "transition" "opacity 0.2s ease"
                                      , css "position" "absolute"
                                      , css "top" "0"
                                      , css "left" "0"
                                      , css "width" "100%"
                                      , css "height" "100%"
                                      , css "opacity"
                                        ( if calculations.flexibleExpansionRatio > 0 then
                                              "1"
                                          else
                                              "0"
                                        )
                                      ]
                                      []
                                    ]
                                Nothing ->
                                    []
                    in
                        (
                          if calculations.flexibleExpansionRatio >= 1 then
                              cs "mdc-toolbar--flexible-space-maximized"
                          else if calculations.flexibleExpansionRatio <= 0 then
                              cs "mdc-toolbar--flexible-space-minimized"
                          else
                              Options.nop 

                        , backgroundImage
                        )
                 _ ->
                    ( Options.nop, [] )
    in
    Internal.apply summary
    Html.header
    ( cs "mdc-toolbar"
    :: when (config.flexible /= Nothing)
       ( Options.many
         [ cs "mdc-toolbar--flexible"
         , cs "mdc-toolbar--flexible-default-behavior"
         ]
       )
    :: when (config.waterfall /= Nothing)
       ( cs "mdc-toolbar--waterfall" )
    :: initOn "elm-mdc-init"
    :: when (model.requestAnimation)
       ( cs "elm-mdc-toolbar--uninitialized" )
    :: flexibleBehavior
    :: options
    )
    []
    ( nodes ++ backgroundImage )


fixed : Property m
fixed =
    cs "mdc-toolbar--fixed"


waterfall : Float -> Property m
waterfall scrollTop =
    Internal.option (\ config -> { config | waterfall = Just scrollTop } )


flexible : Float -> Property m
flexible scrollTop =
    Internal.option (\ config -> { config | flexible = Just scrollTop } )


backgroundImage : String -> Property m
backgroundImage backgroundImage =
    Internal.option (\ config -> { config | backgroundImage = Just backgroundImage } )


fixedLastRow : Property m
fixedLastRow =
    Internal.option (\ config -> { config | fixedLastRow = True })


icon : List (Property m) -> String -> Html m
icon options icon =
    styled Html.div
    ( cs "mdc-toolbar__icon"
    :: cs "material-icons"
    :: options
    )
    [ text icon
    ]


icon_ : List (Property m) -> List (Html m) -> Html m
icon_ options =
    styled Html.div
    ( cs "mdc-toolbar__icon"
    :: cs "material-icons"
    :: options
    )


menu : Property m
menu =
    cs "mdc-toolbar__icon--menu"


title : List (Property m) -> List (Html m) -> Html m
title options =
    styled Html.span
    ( cs "mdc-toolbar__title"
    :: options
    )


-- TODO: title font-size (flexible)


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


fixedAdjust : Property m
fixedAdjust =
    cs "mdc-toolbar-fixed-adjust"


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


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
    [
      Window.resizes (always Resize)

    , if model.requestAnimation then
          AnimationFrame.times (always AnimationFrame)
      else
          Sub.none
    ]


subs : (Material.Msg.Msg m -> m) -> Store s -> Sub m
subs =
    Component.subs Material.Msg.ToolbarMsg .toolbar subscriptions


decodeGeometry : Decoder Geometry
decodeGeometry =
    let
      getRowHeight =
          -- TODO: mobile
          Json.succeed 56

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
