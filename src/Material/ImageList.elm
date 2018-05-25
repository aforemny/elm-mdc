module Material.ImageList exposing
    ( container
    , image
    , item
    , label
    , masonry
    , overlayLabel
    , Property
    , view
    )


{-|
An Image List consists of several items, each containing an image and optionally supporting content (i.e. a text label).


# Resources

- [Image List - Material Components for the Web](https://material.io/develop/web/components/image-lists/)
- [Material Design guidelines: Image lists](https://material.io/design/components/image-lists.html)
- [Demo](https://aforemny.github.io/elm-mdc/#toolbar)


# Example

```elm
import Html exposing (text)
import Material.ImageList as ImageList

ImageList.view (lift << Mdc) [0] model.mdc
  [ css "width" "300px" ]
  (List.repeat 15 someItem)


someItem =
  ImageList.item
    [ css "width" "calc(100% / 5 - 4.2px)"
    , css "margin" "2px"
    ]
    ( ImageList.container
          []
          [ styled Html.div
                [ ImageList.image
                , css "background-color" "black"
                ]
                []
          ]
    )
    []
```


# Usage

@docs Property
@docs view
@docs item
@docs container
@docs label
@docs overlayLabel
@docs masonry
@docs image
-}


import Html exposing (Html)
import Material
import Material.Component exposing (Index)
import Material.Internal.ImageList.Implementation as ImageList



{-| ImageList property.
-}
type alias Property m =
    ImageList.Property m


{-| ImageList view.
-}
view :
    (Material.Msg m -> m)
    -> Index
    -> Material.Model m
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    ImageList.view


{-| Item in an image list.

Make sure the second argument is a container.
-}

item : List (Property m) -> Html m -> List (Html m) -> Html m
item options image supporting =
    ImageList.item options image supporting


{-| Container of image inside an item. Do not use containers for a
masonry image list.
-}
container : List (Property m) -> List (Html m) -> Html m
container options image =
    ImageList.container options image


{-| Label supporting an image.
-}
label : List (Property m) -> List (Html m) -> Html m
label =
    ImageList.label


{-| Supporting content will be positioned in a scrim overlaying each
image (instead of positioned separately under each image).
-}
overlayLabel : Property m
overlayLabel =
    ImageList.overlayLabel


{-| The Masonry Image List variant presents images vertically arranged
into several columns. Use CSS columns to determine how columns to
display. In this layout, images may be any combination of aspect ratios
-}
masonry : Property m
masonry =
    ImageList.masonry


{-| The image inside an image aspect container
-}
image : Property m
image =
    ImageList.image
