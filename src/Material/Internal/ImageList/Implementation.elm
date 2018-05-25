module Material.Internal.ImageList.Implementation
    exposing
        ( container
        , image
        , item
        , label
        , masonry
        , overlayLabel
        , Property
        , react
        , view
        )

import Html exposing (Html, text)
import Material.Internal.Component as Component exposing (Indexed, Index)
import Material.Internal.Msg
import Material.Internal.Options as Options exposing (styled, cs, css, when, nop)
import Material.Internal.ImageList.Model exposing (Model, defaultModel, Config, defaultConfig, Msg(..))


cssClasses :
    { masonry : String
    , withTextProtection : String
    }
cssClasses =
    { masonry = "mdc-image-list--masonry"
    , withTextProtection = "mdc-image-list--with-text-protection"
    }


update : Msg -> Model -> ( Model, Cmd m )
update msg model =
    case msg of
        Init config ->
            ( { model | config = Just config }, Cmd.none )



-- VIEW


imageList : (Msg -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
imageList lift model options items =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options
    in
        Options.apply summary
            Html.ul
            (cs "mdc-image-list"
                :: (cs cssClasses.masonry |> when config.masonry)
                :: (cs cssClasses.withTextProtection |> when config.overlayLabel)
                :: options
            )
            []
            (items)



-- COMPONENT


type alias Store s =
    { s | imageList : Indexed Model }


( get, set ) =
    Component.indexed .imageList (\x y -> { y | imageList = x }) defaultModel


react :
    (Material.Internal.Msg.Msg m -> m)
    -> Msg
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react get set Material.Internal.Msg.ImageListMsg (Component.generalise update)



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
    Component.render get imageList Material.Internal.Msg.ImageListMsg


item : List (Property m) -> Html m -> List (Html m) -> Html m
item options container supporting =
    styled Html.li
        (cs "mdc-image-list__item"
            :: options
        )
        [ container
        , if List.isEmpty supporting then
            text ""
          else
            styled Html.div
                [ cs "mdc-image-list__supporting" ]
                supporting
        ]


container : List (Property m) -> List (Html m) -> Html m
container options image =
    styled Html.div
        (cs "mdc-image-list__image-aspect-container"
        :: options )
        image


label : List (Property m) -> List (Html m) -> Html m
label options text =
    styled Html.span
        ( cs "mdc-image-list__label"
        :: options
        )
        text


overlayLabel : Property m
overlayLabel =
    Options.option (\config -> { config | overlayLabel = True })


masonry : Property m
masonry =
    Options.option (\config -> { config | masonry = True })


image : Property m
image =
    cs "mdc-image-list__image"
