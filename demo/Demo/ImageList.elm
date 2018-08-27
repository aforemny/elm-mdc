module Demo.ImageList exposing (Model, Msg(..), defaultModel, update, view)

import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Material
import Material.ImageList as ImageList
import Material.Options as Options exposing (cs, css, styled, when)
import Material.Typography as Typography


type alias Model m =
    { mdc : Material.Model m
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    }


type Msg m
    = Mdc (Material.Msg m)


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    let
        imageListHeroItem =
            ImageList.item
                [ css "width" "calc(100% / 5 - 4.2px)"
                , css "margin" "2px"
                ]
                [ ImageList.imageAspectContainer []
                    [ ImageList.divImage
                        [ css "background-color" "black"
                        ]
                        []
                    ]
                ]

        standardImages =
            [ "https://material-components.github.io/material-components-web-catalog/static/media/photos/3x2/1.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/3x2/2.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/3x2/3.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/3x2/4.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/3x2/5.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/3x2/6.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/3x2/7.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/3x2/8.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/3x2/9.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/3x2/10.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/3x2/11.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/3x2/12.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/3x2/13.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/3x2/14.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/3x2/15.jpg"
            ]

        masonryImages =
            [ "https://material-components.github.io/material-components-web-catalog/static/media/photos/3x2/16.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/2x3/1.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/3x2/1.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/2x3/2.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/2x3/3.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/3x2/2.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/2x3/4.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/3x2/3.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/2x3/5.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/3x2/4.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/2x3/6.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/3x2/5.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/2x3/7.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/3x2/6.jpg"
            , "https://material-components.github.io/material-components-web-catalog/static/media/photos/3x2/7.jpg"
            ]

        standardItem url =
            ImageList.item
                [ css "width" "calc(100% / 5 - 4.2px)"
                , css "margin" "2px"
                ]
                [ ImageList.imageAspectContainer
                    [ css "padding-bottom" "66.66667%"
                    ]
                    [ ImageList.image
                        [ ImageList.src url
                        ]
                        []
                    , ImageList.supporting []
                        [ ImageList.label [] [ text "Text label" ]
                        ]
                    ]
                ]

        masonryItem url =
            ImageList.item []
                [ ImageList.image
                    [ ImageList.src url
                    ]
                    []
                , ImageList.label [] [ text "Text label" ]
                ]

        standardImageList index =
            example "Standard Image List with Text Protection" <|
                ImageList.view
                    [ ImageList.withTextProtection
                    , css "max-width" "900px"
                    ]
                    (List.map standardItem standardImages)

        masonryImageList index =
            example "Masonry Image List"
                (ImageList.view
                    [ ImageList.masonry
                    , css "max-width" "900px"
                    , css "column-count" "5"
                    , css "column-gap" "16px"
                    ]
                    (List.map masonryItem masonryImages)
                )

        example title imageList =
            styled Html.div
                [ css "padding" "0 24px 16px"
                ]
                [ styled Html.div
                    [ Typography.title
                    , css "padding" "48px 16px 24px"
                    ]
                    [ text title
                    ]
                , imageList
                ]
    in
    page.body "Image List"
        [ Page.hero []
            [ ImageList.view
                [ css "width" "300px"
                ]
                (List.repeat 15 imageListHeroItem)
            ]
        , styled Html.div
            [ cs "demo-wrapper"
            ]
            [ styled Html.h1
                [ Typography.display2
                , css "padding-left" "36px"
                , css "padding-top" "64px"
                , css "padding-bottom" "8px"
                ]
                [ text "Demos"
                ]
            , standardImageList [ 1 ]
            , masonryImageList [ 2 ]
            ]
        ]
