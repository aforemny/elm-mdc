module Material.Progress
    exposing
        ( progress
        , indeterminate
        , buffered
        )

{-| From the [Material Design Lite documentation](http://www.getmdl.io/components/#loading-section):

> The Material Design Lite (MDL) progress component is a visual indicator of
> background activity in a web page or application. A progress indicator
> consists of a (typically) horizontal bar containing some animation that
> conveys a sense of motion. While some progress devices indicate an
> approximate or specific percentage of completion, the MDL progress component
> simply communicates the fact that an activity is ongoing and is not yet
> complete.

> Progress indicators are an established but non-standardized feature in user
> interfaces, and provide users with a visual clue to an application's status.
> Their design and use is therefore an important factor in the overall user
> experience. See the progress component's Material Design specifications page
> for details.

Refer to
[this site](https://debois.github.io/elm-mdl/#loading)
for a live demo.

# Render
@docs indeterminate, progress, buffered

-}

import Html exposing (Html)
import Material.Options as Options exposing (cs, css, nop, div)


{-| An indeterminate progress bar.
-}
indeterminate : Html m
indeterminate =
    bar True False 0 100


{-| A progress bar. First argument is completion in percent (0–100).
-}
progress : Float -> Html m
progress p =
    bar False False p 100


{-| A buffered progress bar. First argument is completion in percent (0-100),
second argument indicates buffer completion in percent (0-100).
-}
buffered : Float -> Float -> Html m
buffered p b =
    bar False True p b


{-| Bar helper used for all spinners.
Note. They use specific default values for each type.
-}
bar : Bool -> Bool -> Float -> Float -> Html m
bar indeterminate buffered p b =
    div
        [ cs "mdl-progress mdl-js-progress is-upgraded"
        , if indeterminate then
            cs "mdl-progress__indeterminate"
          else
            nop
        ]
        [ -- width defaults to 0%
          div
            [ cs "progressbar bar bar1"
            , css "width" (percentage p)
            ]
            []
        , -- width defaults to 100%
          div
            [ cs "bufferbar bar bar2"
            , css "width" (percentage b)
            ]
            []
        , -- width defaults to 0%
          div
            [ cs "auxbar bar bar3"
            , css "width"
                (percentage <|
                    if buffered then
                        (100 - b)
                    else
                        0
                )
            ]
            []
        ]


{-| Format a float as CSS percentage.
-}
percentage : Float -> String
percentage p =
    toString p ++ "%"
