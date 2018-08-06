module Demo.Lists exposing (Model, Msg, defaultModel, update, view)

import Demo.Page as Page exposing (Page)
import Html exposing (Html, text)
import Html.Attributes as Html
import Material
import Material.Checkbox as Checkbox
import Material.FormField as FormField
import Material.Icon as Icon
import Material.List as Lists
import Material.Options as Options exposing (cs, css, styled, when)
import Material.Ripple as Ripple
import Material.Typography as Typography


type alias Model m =
    { mdc : Material.Model m
    , rtl : Bool
    }


defaultModel : Model m
defaultModel =
    { mdc = Material.defaultModel
    , rtl = False
    }


type Msg m
    = Mdc (Material.Msg m)
    | ToggleRtl


update : (Msg m -> m) -> Msg m -> Model m -> ( Model m, Cmd m )
update lift msg model =
    case msg of
        Mdc msg_ ->
            Material.update (lift << Mdc) msg_ model

        ToggleRtl ->
            ( { model | rtl = not model.rtl }, Cmd.none )


view : (Msg m -> m) -> Page m -> Model m -> Html m
view lift page model =
    let
        h2 options =
            styled Html.h2
                (css "margin" "24px"
                    :: options
                )

        h3 options =
            styled Html.h3
                (css "margin-top" "20px"
                    :: css "margin-bottom" "16px"
                    :: options
                )

        section options =
            styled Html.section
                (css "padding" "24px"
                    :: options
                )

        demoWrapper options =
            styled Html.section
                (css "margin" "24px"
                    :: when model.rtl
                        (Options.attribute (Html.dir "rtl"))
                    :: options
                )
    in
    page.body "Lists"
        [ inlineCss
        , Page.hero []
            [ twoLineAvatarPlusTextPlusIconExample
            ]
        , styled Html.div
            [ cs "preamble"
            , css "max-width" "600px"
            , css "margin-top" "48px"
            , css "margin-left" "72px"
            , Typography.body1
            ]
            [ styled Html.div
                [ css "margin-top" "20px"
                , css "margin-bottom" "20px"
                ]
                [ text """NOTE: For the purposes of this demo, we've set a max-width of
600px on all mdc-list elements, and surrounded them by a 1px border. This is
not included in the base css, which has the list take up as much width as
possible (since it's a block element)."""
                ]
            , FormField.view []
                [ Checkbox.view (lift << Mdc)
                    "lists-interactive-lists-toggle-rtl"
                    model.mdc
                    [ Options.onClick (lift ToggleRtl)
                    , Checkbox.checked model.rtl
                    ]
                    []
                , Html.label []
                    [ text "Toggle RTL"
                    ]
                ]
            ]
        , demoWrapper []
            [ h2 [] [ Html.text "Single-Line list" ]
            , section []
                [ h3 [] [ Html.text "Text only, non-interactive (no states)" ]
                , singleLine
                    [ Lists.nonInteractive
                    ]
                ]
            , section []
                [ h3 [] [ Html.text "Text only (dense)" ]
                , singleLine [ Lists.dense ]
                ]
            , section []
                [ h3 [] [ Html.text "Graphic" ]
                , Html.aside [] [ Html.p [] [ Html.em [] [ Html.text "Note: The grey background is styled using demo placeholder styles" ] ] ]
                , startDetail []
                ]
            , section []
                [ h3 [] [ Html.text "Graphic (dense)" ]
                , startDetail [ Lists.dense ]
                ]
            , section []
                [ h3 [] [ Html.text "Graphic Example - Icon with Text" ]
                , startDetailExample
                ]
            , section []
                [ h3 [] [ Html.text "Avatar List" ]
                , avatarList []
                ]
            , section []
                [ h3 [] [ Html.text "Avatar List (dense)" ]
                , avatarList [ Lists.dense ]
                ]
            , section []
                [ h3 [] [ Html.text "Example - Avatar with Text" ]
                , avatarListExample
                ]
            , section []
                [ h3 [] [ Html.text "Metadata" ]
                , endDetail []
                ]
            , section []
                [ h3 [] [ Html.text "Metadata (Dense)" ]
                , endDetail [ Lists.dense ]
                ]
            , section []
                [ h3 [] [ Html.text "Avatar + Metadata" ]
                , avatarPlusEndDetail []
                ]
            , section []
                [ h3 [] [ Html.text "Avatar + Metadata (dense)" ]
                , avatarPlusEndDetail [ Lists.dense ]
                ]
            , section []
                [ h3 [] [ Html.text "Example - Avatar with Text and Icon" ]
                , avatarWithTextAndIconExample
                ]
            ]
        , demoWrapper []
            [ h2 [] [ Html.text "Two-line List" ]
            , section []
                [ h3 [] [ Html.text "Text-Only" ]
                , twoLine []
                ]
            , section []
                [ h3 [] [ Html.text "Text-Only (dense)" ]
                , twoLine [ Lists.dense ]
                ]
            , section []
                [ h3 [] [ Html.text "Graphic" ]
                , startDetail_ []
                ]
            , section []
                [ h3 [] [ Html.text "Graphic (dense)" ]
                , startDetail_ [ Lists.dense ]
                ]
            , section []
                [ h3 [] [ Html.text "Avatar List" ]
                , avatarList_ []
                ]
            , section []
                [ h3 [] [ Html.text "Avatar List (dense)" ]
                , avatarList_ [ Lists.dense ]
                ]
            , section []
                [ h3 [] [ Html.text "Metadata" ]
                , endDetail_ []
                ]
            , section []
                [ h3 [] [ Html.text "Metadata (dense)" ]
                , endDetail_ [ Lists.dense ]
                ]
            , section []
                [ h3 [] [ Html.text "Example - Two-line avatar + text + icon" ]
                , twoLineAvatarPlusTextPlusIconExample
                ]
            ]
        , demoWrapper []
            [ h2 [] [ Html.text "List Dividers" ]
            , section []
                [ h3 [] [ Html.text "Full-Width Dividers" ]
                , fullWidthDividers
                ]
            , section []
                [ h3 [] [ Html.text "Inset Dividers" ]
                , insetDividers
                ]
            ]
        , demoWrapper []
            [ h2 [] [ Html.text "List Groups" ]
            , section []
                [ h3 [] [ Html.text "Basic Usage" ]
                , basicGroups
                ]
            , section []
                [ h3 [] [ Html.text "Example - Two-line Lists, Avatars, Metadata, Inset Dividers" ]
                , groupsExample
                ]
            ]
        , demoWrapper []
            [ h2 [] [ Html.text "Interactive Lists (with ink ripple)" ]
            , section []
                [ h3 [] [ Html.text "Example - Interactive List" ]
                , interactiveList lift "lists-interactive-list" model
                ]
            ]
        ]


inlineCss : Html m
inlineCss =
    Html.node "style"
        [ Html.type_ "text/css"
        ]
        [ Html.text """
.hero .mdc-list {
  background-color: #fff;
  box-shadow: 0px 2px 4px -1px rgba(0, 0, 0, 0.2), 0px 4px 5px 0px rgba(0, 0, 0, 0.14), 0px 1px 10px 0px rgba(0, 0, 0, 0.12);
}
.mdc-list, .mdc-list-group {
  max-width: 600px;
  border: 1px solid rgba(0,0,0,.1);
}
.mdc-list-group > .mdc-list {
  max-width: auto;
  border: none;
}
.gray-bg {
  background-color: rgba(0,0,0,.26);
}
.mdc-list-item__graphic {
  color: rgba(0,0,0,.54);
}
""" ]


singleLine : List (Lists.Property m) -> Html m
singleLine options =
    Lists.ul options
        (Lists.li [] [ Html.text "Single-line item" ]
            |> List.repeat 3
        )


startDetail : List (Lists.Property m) -> Html m
startDetail options =
    Lists.ul options
        (Lists.li []
            [ Lists.graphic [ cs "gray-bg" ] []
            , Html.text "Single-line item"
            ]
            |> List.repeat 3
        )


startDetailExample : Html m
startDetailExample =
    Lists.ul []
        [ Lists.li []
            [ Lists.graphicIcon [] "network_wifi"
            , Html.text "Wi-Fi"
            ]
        , Lists.li []
            [ Lists.graphicIcon [] "bluetooth"
            , Html.text "Bluetooth"
            ]
        , Lists.li []
            [ Lists.graphicIcon [] "data_usage"
            , Html.text "Data Usage"
            ]
        ]


avatarList : List (Lists.Property m) -> Html m
avatarList options =
    Lists.ul
        (Lists.avatarList
            :: options
        )
        [ Lists.li []
            [ Lists.graphic [ cs "gray-bg" ] []
            , Html.text "Single-line item"
            ]
        , Lists.li []
            [ Lists.graphic [ cs "gray-bg" ] []
            , Html.text "Single-line item"
            ]
        , Lists.li []
            [ Lists.graphic [ cs "gray-bg" ] []
            , Html.text "Single-line item"
            ]
        ]


avatarListExample : Html m
avatarListExample =
    Lists.ul
        [ Lists.avatarList
        ]
        [ Lists.li []
            [ Lists.graphicImage [] "images/animal1.svg"
            , Html.text "Panda"
            ]
        , Lists.li []
            [ Lists.graphicImage [] "images/animal2.svg"
            , Html.text "Sleuth"
            ]
        , Lists.li []
            [ Lists.graphicImage [] "images/animal3.svg"
            , Html.text "Brown Bear"
            ]
        ]


endDetail : List (Lists.Property m) -> Html m
endDetail options =
    Lists.ul options
        [ Lists.li []
            [ Html.text "Single-line item"
            , Lists.meta [] [ text "$10.00" ]
            ]
        , Lists.li []
            [ Html.text "Single-line item"
            , Lists.meta [] [ text "$20.00" ]
            ]
        , Lists.li []
            [ Html.text "Single-line item"
            , Lists.meta [] [ text "$30.00" ]
            ]
        ]


avatarPlusEndDetail : List (Lists.Property m) -> Html m
avatarPlusEndDetail options =
    Lists.ul
        (Lists.avatarList
            :: options
        )
        [ Lists.li []
            [ Lists.graphic [ cs "gray-bg" ] []
            , Html.text "Single-line item"
            , Lists.meta [] [ text "$10.00" ]
            ]
        , Lists.li []
            [ Lists.graphic [ cs "gray-bg" ] []
            , Html.text "Single-line item"
            , Lists.meta [] [ text "$20.00" ]
            ]
        , Lists.li []
            [ Lists.graphic [ cs "gray-bg" ] []
            , Html.text "Single-line item"
            , Lists.meta [] [ text "$30.00" ]
            ]
        ]


avatarWithTextAndIconExample : Html m
avatarWithTextAndIconExample =
    let
        item src text icon =
            let
                url =
                    "images/" ++ src
            in
            Lists.li []
                [ Lists.graphicImage [] url
                , Html.text text
                , Lists.metaIcon
                    [ css "text-decoration" "none"
                    , css "color" "#ff4081"
                    ]
                    icon
                ]
    in
    Lists.ul
        [ Lists.avatarList
        ]
        [ item "animal3.svg" "Brown Bear" "favorite"
        , item "animal1.svg" "Panda" "favorite_border"
        , item "animal2.svg" "Sleuth" "favorite_border"
        ]


twoLine : List (Lists.Property m) -> Html m
twoLine options =
    Lists.ul
        (Lists.twoLine
            :: options
        )
        (Lists.li []
            [ Lists.text []
                [ Html.text "Two-line item"
                , Lists.secondaryText []
                    [ Html.text "Secondary text"
                    ]
                ]
            ]
            |> List.repeat 3
        )


startDetail_ : List (Lists.Property m) -> Html m
startDetail_ options =
    Lists.ul
        (Lists.twoLine
            :: options
        )
        (Lists.li []
            [ Lists.graphic [ cs "gray-bg" ] []
            , Lists.text []
                [ Html.text "Two-line item"
                , Lists.secondaryText []
                    [ Html.text "Secondary text"
                    ]
                ]
            ]
            |> List.repeat 3
        )


avatarList_ : List (Lists.Property m) -> Html m
avatarList_ options =
    Lists.ul
        (Lists.twoLine
            :: Lists.avatarList
            :: options
        )
        (Lists.li []
            [ Lists.graphic [ cs "gray-bg" ] []
            , Lists.text []
                [ Html.text "Two-line item"
                , Lists.secondaryText []
                    [ Html.text "Secondary text"
                    ]
                ]
            ]
            |> List.repeat 3
        )


endDetail_ : List (Lists.Property m) -> Html m
endDetail_ options =
    Lists.ul
        (Lists.twoLine
            :: options
        )
        [ Lists.li []
            [ Lists.text []
                [ Html.text "Two-line item"
                , Lists.secondaryText []
                    [ Html.text "Secondary text"
                    ]
                ]
            , Lists.meta [] [ text "$10.00" ]
            ]
        , Lists.li []
            [ Lists.text []
                [ Html.text "Two-line item"
                , Lists.secondaryText []
                    [ Html.text "Secondary text"
                    ]
                ]
            , Lists.meta [] [ text "$20.00" ]
            ]
        , Lists.li []
            [ Lists.text []
                [ Html.text "Two-line item"
                , Lists.secondaryText []
                    [ Html.text "Secondary text"
                    ]
                ]
            , Lists.meta [] [ text "$30.00" ]
            ]
        ]


twoLineAvatarPlusTextPlusIconExample : Html m
twoLineAvatarPlusTextPlusIconExample =
    let
        item primary secondary =
            Lists.li []
                [ Lists.graphic []
                    [ Icon.view [] "folder"
                    ]
                , Lists.text []
                    [ Html.text primary
                    , Lists.secondaryText []
                        [ Html.text secondary
                        ]
                    ]
                , Lists.metaIcon [] "info"
                ]
    in
    styled Html.div
        [ css "min-width" "340px"
        , css "max-width" "600px"
        ]
        [ Html.node "style"
            [ Html.type_ "text/css"
            ]
            [ Html.text """
#two-line-avatar-text-icon-demo .mdc-list-item__start-detail {
  display: inline-flex;
  justify-content: center;
  align-items: center;
  color: white;
  background-color: rgba(0,0,0,.26);
}
#two-line-avatar-text-icon-demo .mdc-list-item__end-detail {
  color: rgba(0,0,0,.26);
}
.mdc-theme--dark #two-line-avatar-text-icon-demo .mdc-list-item__start-detail {
  color: #303030;
  background-color: rgba(255,255,255,.7);
}
.mdc-theme--dark #two-line-avatar-text-icon-demo .mdc-list-item__end-detail {
  color: rgba(255,255,255,.7);
}
"""
            ]
        , Lists.ul
            [ Lists.twoLine
            , Lists.avatarList
            , Options.attribute (Html.id "two-line-avatar-text-icon-demo")
            ]
            [ item "Photos" "Jan 9, 2014"
            , item "Recipes" "Jan 17, 2014"
            , item "Work" "Jan 28, 2014"
            ]
        ]


fullWidthDividers : Html m
fullWidthDividers =
    Lists.ul []
        (List.concat
            [ Lists.li [] [ Html.text "Single-line item - section 1" ]
                |> List.repeat 3
            , [ Lists.divider [] []
              ]
            , Lists.li [] [ Html.text "Single-line item - section 2" ]
                |> List.repeat 2
            ]
        )


insetDividers : Html m
insetDividers =
    Lists.ul
        [ Lists.avatarList
        ]
        (List.concat
            [ Lists.li []
                [ Lists.graphic [ cs "gray-bg" ] []
                , Html.text "Single-line item - section 1"
                ]
                |> List.repeat 3
            , [ Lists.divider [ Lists.inset ] []
              ]
            , Lists.li []
                [ Lists.graphic [ cs "gray-bg" ] []
                , Html.text "Single-line item - section 2"
                ]
                |> List.repeat 2
            ]
        )


basicGroups : Html m
basicGroups =
    Lists.group []
        [ Lists.subheader [] [ Html.text "List 1" ]
        , Lists.ul []
            (Lists.li [] [ Html.text "Single-line item" ]
                |> List.repeat 3
            )
        , Lists.divider [] []
        , Lists.subheader [] [ Html.text "List 2" ]
        , Lists.ul []
            (Lists.li [] [ Html.text "Single-line item" ]
                |> List.repeat 3
            )
        ]


groupsExample : Html m
groupsExample =
    let
        file =
            item "insert_drive_file"

        folder =
            item "folder"

        item icon primary secondary =
            Lists.li []
                [ Lists.graphic []
                    [ Icon.view [] icon
                    ]
                , Lists.text []
                    [ Html.text primary
                    , Lists.secondaryText []
                        [ Html.text secondary
                        ]
                    ]
                , Lists.metaIcon [] "info"
                ]
    in
    [ Html.node "style"
        [ Html.type_ "text/css"
        ]
        [ Html.text """
.two-line-avatar-text-icon-demo .mdc-list-item__start-detail {
  display: inline-flex;
  justify-content: center;
  align-items: center;
  color: white;
  background-color: rgba(0,0,0,.26);
}
.two-line-avatar-text-icon-demo .mdc-list-item__end-detail {
  color: rgba(0,0,0,.26);
}
.mdc-theme--dark .two-line-avatar-text-icon-demo .mdc-list-item__start-detail {
  color: #303030;
  background-color: rgba(255,255,255,.7);
}
.mdc-theme--dark .two-line-avatar-text-icon-demo .mdc-list-item__end-detail {
  color: rgba(255,255,255,.7);
}
"""
        ]
    , Lists.group []
        [ Lists.subheader []
            [ Html.text "Folders"
            ]
        , Lists.ul
            [ Lists.twoLine
            , Lists.avatarList
            , cs "two-line-avatar-text-icon-demo"
            ]
            [ folder "Photos" "Jan 9, 2014"
            , folder "Recipes" "Jan 17, 2014"
            , folder "Work" "Jan 28, 2014"
            ]
        , Lists.divider [ Lists.inset ] []
        , Lists.subheader []
            [ Html.text "Files"
            ]
        , Lists.ul
            [ Lists.twoLine
            , Lists.avatarList
            , cs "two-line-avatar-text-icon-demo"
            ]
            [ file "Vacation Itinerary" "Jan 10, 2014"
            , file "Recipes" "Jan 17, 2014"
            , file "Kitchen Remodel" "Jan 20, 2014"
            ]
        ]
    ]
        |> Html.div []


interactiveList : (Msg m -> m) -> Material.Index -> Model m -> Html m
interactiveList lift index model =
    Lists.ul []
        [ let
            ripple =
                Ripple.bounded (lift << Mdc) (index ++ "-ripple-0") model.mdc []
          in
          Lists.li
            [ ripple.interactionHandler
            , ripple.properties
            ]
            [ Lists.graphicIcon [] "network_wifi"
            , Html.text "Wi-Fi"
            , ripple.style
            ]
        , let
            ripple =
                Ripple.bounded (lift << Mdc) (index ++ "-ripple-1") model.mdc []
          in
          Lists.li
            [ ripple.interactionHandler
            , ripple.properties
            ]
            [ Lists.graphicIcon [] "bluetooth"
            , Html.text "Bluetooth"
            , ripple.style
            ]
        , let
            ripple =
                Ripple.bounded (lift << Mdc) (index ++ "-ripple-2") model.mdc []
          in
          Lists.li
            [ ripple.interactionHandler
            , ripple.properties
            ]
            [ Lists.graphicIcon [] "data_usage"
            , Html.text "Data Usage"
            , ripple.style
            ]
        ]
