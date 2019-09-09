module Material.ImageList exposing
    ( Property
    , view
    , masonry
    , withTextProtection
    , item
    , imageAspectContainer
    , image
    , src
    , divImage
    , supporting
    , label
    , node
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
@docs node


## Image items

@docs imageAspectContainer
@docs image
@docs divImage
@docs src


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


{-| Change the default node of an element inside an `item`. The
default is to use a "div" or "span" as the documentation has it, but
sometimes another element makes more sense.
-}
node : String -> Property m
node =
    ImageList.node


{-| The image inside an image aspect container

Images in an Image List typically use the img element. However, if
your assets don’t have the same aspect ratio as specified for list
items, they will become distorted. In these cases, you can use a div
element in place of img, and set the background-image of each.

You can use a `div` element by setting the `node` property to "div" or
use the `divImage` element.

-}
image : List (Property m) -> List (Html m) -> Html m
image =
    ImageList.image


{-| Convenience function to use "div" instead of "img" as the HTML element.

-For `divImage` use `Options.css "background-image"`.

-}

divImage : List (Property m) -> List (Html m) -> Html m
divImage options nodes =
    image ( node "div" :: options ) nodes



{-| An image's supporting element. This is the usual container for `label`.
-}
supporting : List (Property m) -> List (Html m) -> Html m
supporting =
    ImageList.supporting


{-| An image's HTML `src` attribute.

-}
src : String -> Property m
src =
    ImageList.src
