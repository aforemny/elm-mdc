module Material.ImageList
    exposing
        ( Property
        , divImage
        , image
        , imageAspectContainer
        , item
        , label
        , masonry
        , src
        , supporting
        , view
        , withTextProtection
        )

{-| An Image List consists of several items, each containing an image and
optionally supporting content (i.e. a text label).


# Resources

  - [Image List - Internal.Components for the Web](https://material.io/develop/web/components/image-lists/)
  - [Material Design guidelines: Image lists](https://material.io/design/components/image-lists.html)
  - [Demo](https://aforemny.github.io/elm-mdc/#image-list)


# Example

    import Html exposing (text)
    import Material.ImageList as ImageList


    ImageList.view []
        [ ImageList.item []
            [ ImageList.imageAspectContainer
                []
                [ ImageList.image
                    [ ImageList.src "…"
                    ]
                    []
                ]
            , ImageList.supporting
                []
                [ ImageList.label [] [ text "Text label" ]
                ]
            ]
        ]


# Usage

@docs Property
@docs view
@docs masonry
@docs withTextProtection
@docs item


## Image items

@docs imageAspectContainer
@docs image
@docs src
@docs divImage


## Item label

@docs supporting
@docs label

-}

import Html exposing (Html)
import Internal.ImageList.Implementation as ImageList


{-| ImageList property.
-}
type alias Property m =
    ImageList.Property m


{-| ImageList view.
-}
view : List (Property m) -> List (Html m) -> Html m
view =
    ImageList.view


{-| Item in an image list.
-}
item : List (Property m) -> List (Html m) -> Html m
item =
    ImageList.item


{-| Container of image inside an item.

Do not use containers for a masonry image list.

-}
imageAspectContainer : List (Property m) -> List (Html m) -> Html m
imageAspectContainer =
    ImageList.imageAspectContainer


{-| Label supporting an image.
-}
label : List (Property m) -> List (Html m) -> Html m
label =
    ImageList.label


{-| Supporting content will be positioned in a scrim overlaying each
image (instead of positioned separately under each image).
-}
withTextProtection : Property m
withTextProtection =
    ImageList.withTextProtection


{-| The Masonry Image List variant presents images vertically arranged
into several columns. Use CSS columns to determine how columns to
display. In this layout, images may be any combination of aspect ratios
-}
masonry : Property m
masonry =
    ImageList.masonry


{-| The image inside an image aspect container
-}
image : List (Property m) -> List (Html m) -> Html m
image =
    ImageList.image


{-| The image inside an image aspect container
-}
divImage : List (Property m) -> List (Html m) -> Html m
divImage =
    ImageList.divImage


{-| An image's supporting element.
-}
supporting : List (Property m) -> List (Html m) -> Html m
supporting =
    ImageList.supporting


{-| An image's HTML `src` attribute.

For `divImage` use `Options.css "background-image"`.

-}
src : String -> Property m
src =
    ImageList.src
