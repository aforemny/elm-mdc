module Demo.Lists exposing (..)

import Demo.Code as Code
import Demo.Page as Page
import Html.Attributes as Html
import Html exposing (Html)
import Material
import Material.Button as Button
import Material.Color as Color
import Material.Grid as Grid
import Material.Helpers as Helpers
import Material.Icon as Icon
import Material.List as Lists
import Material.Options as Options exposing (div, styled, cs, css, when)
import Material.Ripple as Ripple
import Material.Toggles as Toggles
import Material.Typography as Typography
import Platform.Cmd exposing (Cmd, none)
import Set exposing (Set)
import String


-- MODEL


type alias Model =
    { mdl : Material.Model
    }


model : Model
model =
    { mdl = Material.model
    }



-- UPDATE


type Msg
    = Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Mdl msg_ ->
            Material.update Mdl msg_ model


-- VIEW

inlineCss =
    Html.node "style"
    [ Html.type_ "text/css"
    ]
    [ Html.text """
section {
  padding: 24px;
}
.mdc-list, .mdc-list-group {
  max-width: 600px;
  border: 1px solid rgba(0,0,0,.1);
}
.mdc-list-group > .mdc-list {
  max-width: auto;
  border: none;
}
.mdc-theme--dark .mdc-list {
  border: none;
}
section.mdc-theme--dark {
  background-color: #303030;
}
.mdc-theme--dark > h3 {
  color: white;
}
.gray-bg {
  background-color: rgba(0,0,0,.26);
}
i.mdc-list-item__start-detail {
  color: rgba(0,0,0,.54);
}
.mdc-theme--dark i.mdc-list-item__start-detail {
  color: rgba(255,255,255,.7);
}
""" ]


singleLine options =
    Lists.ul options
    ( Lists.li [] [ Html.text "Single-line item" ]
      |> List.repeat 3
    )


startDetail options =
    Lists.ul options
    ( Lists.li []
      [ Lists.startDetail [ cs "gray-bg" ] []
      , Html.text "Single-line item"
      ]
        |> List.repeat 3
    )


startDetailExample =
    Lists.ul []
    [ Lists.li []
      [ Lists.startDetailIcon "network_wifi" []
      , Html.text "Wi-Fi"
      ]
    , Lists.li []
      [ Lists.startDetailIcon "bluetooth" []
      , Html.text "Bluetooth"
      ]
    , Lists.li []
      [ Lists.startDetailIcon "data_usage" []
      , Html.text "Data Usage"
      ]
    ]


avatarList options =
    Lists.ul
    ( Lists.avatar
    :: options
    )
    [ Lists.li []
      [ Lists.startDetail [ cs "gray-bg" ] []
      , Html.text "Single-line item"
      ]
    , Lists.li []
      [ Lists.startDetail [ cs "gray-bg" ] []
      , Html.text "Single-line item"
      ]
    , Lists.li []
      [ Lists.startDetail [ cs "gray-bg" ] []
      , Html.text "Single-line item"
      ]
    ]


avatarListExample =
    Lists.ul
    [ Lists.avatar
    ]
    [ Lists.li []
      [ Lists.avatarImage "https://material-components-web.appspot.com/images/animal1.svg" []
      , Html.text "Panda"
      ]
    , Lists.li []
      [ Lists.avatarImage "https://material-components-web.appspot.com/images/animal2.svg" []
      , Html.text "Sleuth"
      ]
    , Lists.li []
      [ Lists.avatarImage "https://material-components-web.appspot.com/images/animal3.svg" []
      , Html.text "Brown Bear"
      ]
    ]


endDetail options =
    Lists.ul options
    ( Lists.li []
      [ Html.text "Single-line item"
      , Lists.endDetail [ cs "gray-bg" ] []
      ]
        |> List.repeat 3
    )


avatarPlusEndDetail options =
    Lists.ul
    ( Lists.avatar
    :: options
    )
    ( Lists.li []
      [ Lists.startDetail [ cs "gray-bg" ] []
      , Html.text "Single-line item"
      , Lists.endDetail [ cs "gray-bg" ] []
      ]
        |> List.repeat 3
    )


avatarWithTextAndIconExample =
    let
        item src text icon =
            let
                url =
                    "https://material-components-web.appspot.com/images/" ++ src
            in
            Lists.li []
            [ Lists.avatarImage url []
            , Html.text text
            , Lists.endDetailIcon icon
              [ css "text-decoration" "none"
              , css "color" "#ff4081"
              ]
            ]
    in
    Lists.ul
    [ Lists.avatar
    ]
    [ item "animal3.svg" "Brown Bear" "favorite"
    , item "animal1.svg" "Panda" "favorite_border"
    , item "animal2.svg" "Sleuth" "favorite_border"
    ]


twoLine options =
    Lists.ul
    ( Lists.twoLine
    :: options
    )
    ( Lists.li []
      [ Lists.text []
        [ Html.text "Two-line item"
        , Lists.secondary []
          [ Html.text "Secondary text"
          ]
        ]
      ]
      |> List.repeat 3
    )


startDetail_ options =
    Lists.ul
    ( Lists.twoLine
    :: options
    )
    ( Lists.li []
      [ Lists.startDetail [ cs "gray-bg" ] []
      , Lists.text []
        [ Html.text "Two-line item"
        , Lists.secondary []
          [ Html.text "Secondary text"
          ]
        ]
      ]
      |> List.repeat 3
    )


avatarList_ options =
    Lists.ul
    ( Lists.twoLine
    :: Lists.avatar
    :: options
    )
    ( Lists.li []
      [ Lists.startDetail [ cs "gray-bg" ] []
      , Lists.text []
        [ Html.text "Two-line item"
        , Lists.secondary []
          [ Html.text "Secondary text"
          ]
        ]
      ]
      |> List.repeat 3
    )


endDetail_ options =
    Lists.ul
    ( Lists.twoLine
    :: options
    )
    ( Lists.li []
      [ Lists.text []
        [ Html.text "Two-line item"
        , Lists.secondary []
          [ Html.text "Secondary text"
          ]
        ]
      , Lists.endDetail [ cs "gray-bg" ] []
      ]
      |> List.repeat 3
    )


twoLineAvatarPlusTextPlusIconExample =
    let
        item primary secondary =
            Lists.li []
            [ Lists.startDetail []
              [ Icon.view "folder" []
              ]
            , Lists.text []
              [ Html.text primary
              , Lists.secondary []
                [ Html.text secondary
                ]
              ]
            , Lists.endDetailIcon "info" []
            ]
    in
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
      , Lists.avatar
      , Options.id "two-line-avatar-text-icon-demo"
      ]
      [ item "Photos" "Jan 9, 2014"
      , item "Recipes" "Jan 17, 2014"
      , item "Work" "Jan 28, 2014"
      ]
    ]
    |> Html.div []


fullWidthDividers =
    Lists.ul []
    ( List.concat
      [ Lists.li [] [ Html.text "Single-line item - section 1" ]
        |> List.repeat 3
      , [ Lists.divider []
        ]
      , Lists.li [] [ Html.text "Single-line item - section 2" ]
        |> List.repeat 2
      ]
    )


insetDividers =
    Lists.ul
    [ Lists.avatar
    ]
    ( List.concat
      [ Lists.li []
        [ Lists.startDetail [ cs "gray-bg" ] []
        , Html.text "Single-line item - section 1"
        ]
          |> List.repeat 3
      , [ Lists.divider [ Lists.inset ]
        ]
      , Lists.li []
        [ Lists.startDetail [ cs "gray-bg" ] []
        , Html.text "Single-line item - section 2"
        ]
          |> List.repeat 2
      ]
    )


basicGroups =
    Lists.group []
    [ Lists.subheader [] [ Html.text "List 1" ]
    , Lists.ul []
      ( Lists.li [] [ Html.text "Single-line item" ]
        |> List.repeat 3
      )
    , Lists.divider []
    , Lists.subheader [] [ Html.text "List 2" ]
    , Lists.ul []
      ( Lists.li [] [ Html.text "Single-line item" ]
        |> List.repeat 3
      )
    ]


groupsExample =
    let
        file =
            item "insert_drive_file"

        folder =
            item "folder"

        item icon primary secondary =
            Lists.li []
            [ Lists.startDetail []
              [ Icon.view icon []
              ]
            , Lists.text []
              [ Html.text primary
              , Lists.secondary []
                [ Html.text secondary
                ]
              ]
            , Lists.endDetailIcon "info" []
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
        , Lists.avatar
        , cs "two-line-avatar-text-icon-demo"
        ]
        [ folder "Photos" "Jan 9, 2014"
        , folder "Recipes" "Jan 17, 2014"
        , folder "Work" "Jan 28, 2014"
        ]
      , Lists.divider [ Lists.inset ]
      , Lists.subheader []
        [ Html.text "Files"
        ]
      , Lists.ul
        [ Lists.twoLine
        , Lists.avatar
        , cs "two-line-avatar-text-icon-demo"
        ]
        [ file "Vacation Itinerary" "Jan 10, 2014"
        , file "Recipes" "Jan 17, 2014"
        , file "Kitchen Remodel" "Jan 20, 2014"
        ]
      ]
    ]
    |> Html.div []


interactiveList =
    -- TODO: ripple
    Lists.ul []
    [ Lists.li []
      [ Lists.startDetailIcon "network_wifi" []
      , Html.text "Wi-Fi"
      ]
    , Lists.li []
      [ Lists.startDetailIcon "bluetooth" []
      , Html.text "Bluetooth"
      ]
    , Lists.li []
      [ Lists.startDetailIcon "data_usage" []
      , Html.text "Data Usage"
      ]
    ]


view : Model -> Html Msg
view model =
    Page.body1_ "Lists" srcUrl intro references []
    [ inlineCss

    , Html.section []
      [ Html.h2 [] [ Html.text "Single-Line list" ]

      , Html.section []
        [ Html.h3 [] [ Html.text "Text only" ]
        , singleLine []
        ]

      , Html.section []
        [ Html.h3 [] [ Html.text "Text only (Dense)" ]
        , singleLine [ Lists.dense ]
        ]

      , styled Html.section
        [ cs "mdc-theme--dark"
        ]
        [ Html.h3 [] [ Html.text "Text only (dark)" ]
        , singleLine []
        ]

      , Html.section []
        [ Html.h3 [] [ Html.text "Start Detail" ]
        , Html.aside [] [ Html.p [] [ Html.em [] [ Html.text "Note: The grey background is styled using demo placeholder styles" ] ] ]
        , startDetail []
        ]

      , Html.section []
        [ Html.h3 [] [ Html.text "Start Detail (Dense)" ]
        , startDetail [ Lists.dense ]
        ]

      , Html.section []
        [ Html.h3 [] [ Html.text "Start Detail Example - Icon with Text" ]
        , startDetailExample
        ]

      , styled Html.section
        [ cs "mdc-theme--dark"
        ]
        [ Html.h3 [] [ Html.text "Start Detail Example - Icon with Text (dark)" ]
        , startDetailExample
        ]

      , Html.section []
        [ Html.h3 [] [ Html.text "Avatar List" ]
        , avatarList []
        ]

      , Html.section []
        [ Html.h3 [] [ Html.text "Avatar List (Dense)" ]
        , avatarList [ Lists.dense ]
        ]

      , Html.section []
        [ Html.h3 [] [ Html.text "Example - Avatar with Text" ]
        , avatarListExample
        ]

      , styled Html.section
        [ cs "mdc-theme--dark"
        ]
        [ Html.h3 [] [ Html.text "Example - Avatar with Text (dark)" ]
        , avatarListExample
        ]

      , Html.section []
        [ Html.h3 [] [ Html.text "End Detail" ]
        , endDetail []
        ]

      , Html.section []
        [ Html.h3 [] [ Html.text "End Detail (Dense)" ]
        , endDetail [ Lists.dense ]
        ]

      , Html.section []
        [ Html.h3 [] [ Html.text "Avatar + End Detail" ]
        , avatarPlusEndDetail []
        ]

      , Html.section []
        [ Html.h3 [] [ Html.text "Avatar + End Detail (Dense)" ]
        , avatarPlusEndDetail [ Lists.dense ]
        ]

      , Html.section []
        [ Html.h3 [] [ Html.text "Example - Avatar with Text and Icon" ]
        , avatarWithTextAndIconExample
        ]

      , styled Html.section
        [ cs "mdc-theme--dark"
        ]
        [ Html.h3 [] [ Html.text "Example - Avatar with Text and Icon (Dark)" ]
        , avatarWithTextAndIconExample
        ]
      ]

    , Html.section []
      [ Html.h2 [] [ Html.text "Two-line List" ]

      , Html.section []
        [ Html.h3 [] [ Html.text "Text-Only" ]
        , twoLine []
        ]

      , Html.section []
        [ Html.h3 [] [ Html.text "Text-Only (Dense)" ]
        , twoLine [ Lists.dense ]
        ]

      , Html.section []
        [ Html.h3 [] [ Html.text "Start Detail" ]
        , startDetail_ []
        ]

      , Html.section []
        [ Html.h3 [] [ Html.text "Start Detail (Dense)" ]
        , startDetail_ [ Lists.dense ]
        ]

      , Html.section []
        [ Html.h3 [] [ Html.text "Avatar List" ]
        , avatarList_ []
        ]

      , Html.section []
        [ Html.h3 [] [ Html.text "Avatar List (Dense)" ]
        , avatarList_ [ Lists.dense ]
        ]

      , Html.section []
        [ Html.h3 [] [ Html.text "End Detail" ]
        , endDetail_ []
        ]

      , Html.section []
        [ Html.h3 [] [ Html.text "End Detail (Dense)" ]
        , endDetail_ [ Lists.dense ]
        ]

      , Html.section []
        [ Html.h3 [] [ Html.text "Example - Two-line avatar + text + icon" ]
        , twoLineAvatarPlusTextPlusIconExample
        ]

      , styled Html.section
        [ cs "mdc-theme--dark"
        ]
        [ Html.h3 [] [ Html.text "Example - Two-line avatar + text + icon (Dark)" ]
        , twoLineAvatarPlusTextPlusIconExample
        ]
      ]

    , Html.section []
      [ Html.h2 [] [ Html.text "List Dividers" ]
      ,
        Html.section []
        [ Html.h3 [] [ Html.text "Full-Width Dividers" ]
        , fullWidthDividers
        ]

      , Html.section []
        [ Html.h3 [] [ Html.text "Inset Dividers" ]
        , insetDividers
        ]
      ]

    , Html.section []
      [ Html.h2 [] [ Html.text "List Groups" ]
      ,
        Html.section []
        [ Html.h3 [] [ Html.text "Basic Usage" ]
        , basicGroups
        ]

      , Html.section []
        [ Html.h3 [] [ Html.text "Example - Two-line Lists, Avatars, end detail, inset dividers" ]
        , groupsExample
        ]

      , styled Html.section
        [ cs "mdc-theme--dark"
        ]
        [ Html.h3 [] [ Html.text "Example - Two-line Lists, Avatars, end detail, inset dividers (Dark)" ]
        , groupsExample
        ]
      ]

    , Html.section []
      [ Html.h2 [] [ Html.text "Interactive Lists (with ink ripple)" ]
      ,
        Html.section []
        [ Html.h3 [] [ Html.text "Example - Interactive List" ]
        , interactiveList
        ]

      , styled Html.section
        [ cs "mdc-theme--dark"
        ]
        [ Html.h3 [] [ Html.text "Example - Interactive List (Dark)" ]
        , interactiveList
        ]
      ]
    ]


intro : Html m
intro =
    Page.fromMDL "https://www.getmdl.io/components/index.html#lists-section" """
> Lists present multiple line items vertically as a single continuous element.
> Refer to the [Material Design
Spec](https://material.google.com/components/lists.html) to know more about the
content options.  """


srcUrl : String
srcUrl =
    "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Lists.elm"


references : List ( String, String )
references =
    [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-List"
    , Page.mds "https://material.google.com/components/lists.html"
    , Page.mdl "https://www.getmdl.io/components/index.html#lists-section"
    ]
