module Demo.Helper.ResourceLink exposing (links, view)

import Html exposing (Html, text)
import Html.Attributes as Html exposing (class)
import Material
import Material.List as Lists
import Material.Options as Options exposing (cs, css, styled)
import Material.Typography as Typography


{-| Render the customary three links.
-}
links :
    (Material.Msg m -> m)
    -> Material.Model m
    -> String
    -> String
    -> String
    -> Html m
links lift mdc guidelines documentation package =
    let
        guidelines_url =
            if String.contains "/" guidelines then
                guidelines ++ ".html"

            else if String.contains ".html" guidelines then
                "components/" ++ guidelines

            else
                "components/" ++ guidelines ++ ".html"

        guidelines_id =
            guidelines
                |> String.replace "." "-"
                |> String.replace "#" "-"
                |> String.replace "/" "-"

        documentation_id =
            String.replace "/" "-" documentation
    in
    styled Html.div
        [ cs "resources"
        , css "padding-top" "1px" ] -- Prevent margin collapse
        [ styled Html.h2
            [ Typography.headline6
            , css "border-bottom" "1px solid rgba(0,0,0,.87)"
            ]
            [ text "Resources"
            ]
        , if guidelines /= "" then
            view lift
                ("guidelines-" ++ guidelines_id)
                mdc
                { link = "https://material.io/design/" ++ guidelines_url
                , title = "Material Design Guidelines"
                , icon = "images/material.svg"
                , altText = "Material Design Guidelines icon"
                }

          else
            text ""
        , view lift
            ("documentation-" ++ documentation_id)
            mdc
            { link = "https://material.io/develop/web/components/" ++ documentation ++ "/"
            , title = "Documentation"
            , icon = "images/ic_drive_document_24px.svg"
            , altText = "Documentation icon"
            }
        , view lift
            ("package-" ++ package)
            mdc
            { link = "https://github.com/material-components/material-components-web/tree/master/packages/" ++ package
            , title = "Source Code (Material Components Web)"
            , icon = "images/ic_code_24px.svg"
            , altText = "Source Code"
            }
        ]


view :
    (Material.Msg m -> m)
    -> Material.Index
    -> Material.Model m
    ->
        { link : String
        , title : String
        , icon : String
        , altText : String
        }
    -> Html m
view lift index mdc { link, title, icon, altText } =
    Lists.aRippled lift
        index
        mdc
        [ Options.attribute (Html.href link)
        , Options.attribute (Html.target "_blank")
        , Lists.listItemClass
        ]
        [ Lists.graphic []
            [ styled Html.img
                [ cs "resources-icon"
                , Options.attribute (Html.src icon)
                , Options.attribute (Html.alt altText)
                ]
                []
            ]
        , text title
        ]
