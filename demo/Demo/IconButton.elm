module Demo.IconButton exposing (Model, Msg(..), defaultModel, update, view)

import Demo.Helper.Hero as Hero
import Demo.Helper.ResourceLink as ResourceLink
import Demo.Page as Page exposing (Page)
import Dict exposing (Dict)
import Html exposing (Html, text)
import Html.Attributes as Html exposing (src)
import Material
import Material.IconButton as IconButton
import Material.Options as Options exposing (styled, when)
import Material.Typography as Typography


type alias Model m =
    { mdc : Material.Model m
    , iconToggles : Dict Material.Index Bool
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , iconToggles = Dict.empty
    }


type Msg m
    = Mdc (Material.Msg m)
    | Toggle Material.Index


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        Toggle index ->
            let
                iconToggles =
                    Dict.update index
                        (\state ->
                            Just <|
                                case state of
                                    Just True ->
                                        False

                                    _ ->
                                        True
                        )
                        model.iconToggles
            in
            ( { model | iconToggles = iconToggles }, Cmd.none )


iconToggle :
    (Msg m -> m)
    -> Material.Index
    -> Model m
    -> String
    -> String
    -> Html m
iconToggle lift index model offIcon onIcon =
    let
        isOn =
            Dict.get index model.iconToggles
                |> Maybe.withDefault False
    in
    IconButton.view (lift << Mdc)
        index
        model.mdc
        [ IconButton.icon { on = onIcon, off = offIcon }
        , Options.onClick (lift (Toggle index))
        , when isOn IconButton.on
        ]
        []


iconButton :
    (Msg m -> m)
    -> Material.Index
    -> Model m
    -> String
    -> Html m
iconButton lift index model icon =
    iconToggle lift index model icon icon


iconImageToggle :
    (Msg m -> m)
    -> Material.Index
    -> Model m
    -> String
    -> String
    -> Html m
iconImageToggle lift index model offIcon onIcon =
    let
        isOn =
            Dict.get index model.iconToggles
                |> Maybe.withDefault False
    in
    IconButton.view (lift << Mdc)
        index
        model.mdc
        [ Options.onClick (lift (Toggle index))
        , when isOn IconButton.on
        ]
        [ styled Html.img
            [ IconButton.iconElement
            , IconButton.onIconElement
            , Options.attribute (Html.src onIcon)
            ]
            []
        , styled Html.img
            [ IconButton.iconElement
            , Options.attribute (Html.src offIcon)
            ]
            []
        ]


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    page.body
        [ Hero.view
              [ Hero.header "Icon Button"
              , Hero.intro "Icons are appropriate for buttons that allow a user to take actions or make a selection, such as adding or removing a star to an item."
              , Hero.component []
                  [ iconToggle lift
                        "icon-toggle-hero-icon-toggle"
                        model
                        "favorite_border"
                        "favorite"
                  ]
              ]
        , ResourceLink.links (lift << Mdc) model.mdc "buttons.html#toggle-button" "buttons/icon-buttons" "mdc-icon-button"
        , Page.demos
            [ styled Html.h3 [ Typography.subtitle1 ] [ text "Icon Button" ]
            , iconButton lift "icon-button-icon-button" model "wifi"
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Icon Toggle Button" ]
            , iconToggle lift "icon-button-icon-toggle" model "favorite_border" "favorite"
            , styled Html.h3 [ Typography.subtitle1 ] [ text "Image Icon Toggle Button" ]
            , iconImageToggle lift "icon-button-icon-image-toggle" model "images/ic_button_24px.svg" "images/ic_card_24px.svg"
            ]
        ]
