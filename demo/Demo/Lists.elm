module Demo.Lists exposing (Model, defaultModel, Msg, update, view)

import Demo.Page as Page exposing (Page)
import Html.Attributes as Html
import Html exposing (Html, text)
import Material
import Material.Checkbox as Checkbox
import Material.Icon as Icon
import Material.List as Lists
import Material.Options as Options exposing (div, styled, cs, css, when)
import Material.Ripple as Ripple
import Material.Typography as Typography


type alias Model =
    { mdl : Material.Model
      -- ^^ TODO: use namespace `mdc`
    , rtl : Bool
    }


defaultModel : Model
defaultModel =
    { mdl = Material.defaultModel
    , rtl = False
    }


type Msg m
    = Mdl (Material.Msg m)
    | ToggleRtl


update : (Msg m -> m) -> Msg m -> Model -> ( Model, Cmd m )
update lift msg model =
    case msg of
        Mdl msg_ ->
            Material.update (Mdl >> lift) msg_ model

        ToggleRtl ->
            ( { model | rtl = not model.rtl }, Cmd.none )


view : (Msg m -> m) -> Page m -> Model -> Html m
view lift page model =
    let
        h2 options =
          styled Html.h2
          ( css "margin" "24px"
          :: options
          )

        h3 options =
          styled Html.h3
          ( css "margin-top" "20px"
          :: css "margin-bottom" "16px"
          :: options
          )

        section options =
            styled Html.section
            ( css "padding" "24px"
            :: options
            )

        demoWrapper options =
            styled Html.section
            ( css "margin" "24px"
            :: when model.rtl
               ( Options.attribute ( Html.dir "rtl") )
            :: options
            )
    in
    page.body "Lists"
    [
      inlineCss

    , Page.hero []
      [
        twoLineAvatarPlusTextPlusIconExample
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

      , styled Html.div
        [ cs "mdc-form-field"
        ]
        [ Checkbox.render (Mdl >> lift) [0] model.mdl
          [ Options.onClick (lift ToggleRtl)
          , Checkbox.checked |> when model.rtl
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
        [ h3 [] [ Html.text "Text only" ]
        , singleLine []
        ]

      , section []
        [ h3 [] [ Html.text "Text only (Dense)" ]
        , singleLine [ Lists.dense ]
        ]

      , section
        [ cs "mdc-theme--dark"
        ]
        [ h3 [] [ Html.text "Text only (dark)" ]
        , singleLine []
        ]

      , section []
        [ h3 [] [ Html.text "Start Detail" ]
        , Html.aside [] [ Html.p [] [ Html.em [] [ Html.text "Note: The grey background is styled using demo placeholder styles" ] ] ]
        , startDetail []
        ]

      , section []
        [ h3 [] [ Html.text "Start Detail (Dense)" ]
        , startDetail [ Lists.dense ]
        ]

      , section []
        [ h3 [] [ Html.text "Start Detail Example - Icon with Text" ]
        , startDetailExample
        ]

      , section
        [ cs "mdc-theme--dark"
        ]
        [ h3 [] [ Html.text "Start Detail Example - Icon with Text (dark)" ]
        , startDetailExample
        ]

      , section []
        [ h3 [] [ Html.text "Avatar List" ]
        , avatarList []
        ]

      , section []
        [ h3 [] [ Html.text "Avatar List (Dense)" ]
        , avatarList [ Lists.dense ]
        ]

      , section []
        [ h3 [] [ Html.text "Example - Avatar with Text" ]
        , avatarListExample
        ]

      , section
        [ cs "mdc-theme--dark"
        ]
        [ h3 [] [ Html.text "Example - Avatar with Text (dark)" ]
        , avatarListExample
        ]

      , section []
        [ h3 [] [ Html.text "End Detail" ]
        , endDetail []
        ]

      , section []
        [ h3 [] [ Html.text "End Detail (Dense)" ]
        , endDetail [ Lists.dense ]
        ]

      , section []
        [ h3 [] [ Html.text "Avatar + End Detail" ]
        , avatarPlusEndDetail []
        ]

      , section []
        [ h3 [] [ Html.text "Avatar + End Detail (Dense)" ]
        , avatarPlusEndDetail [ Lists.dense ]
        ]

      , section []
        [ h3 [] [ Html.text "Example - Avatar with Text and Icon" ]
        , avatarWithTextAndIconExample
        ]

      , section
        [ cs "mdc-theme--dark"
        ]
        [ h3 [] [ Html.text "Example - Avatar with Text and Icon (Dark)" ]
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
        [ h3 [] [ Html.text "Text-Only (Dense)" ]
        , twoLine [ Lists.dense ]
        ]

      , section []
        [ h3 [] [ Html.text "Start Detail" ]
        , startDetail_ []
        ]

      , section []
        [ h3 [] [ Html.text "Start Detail (Dense)" ]
        , startDetail_ [ Lists.dense ]
        ]

      , section []
        [ h3 [] [ Html.text "Avatar List" ]
        , avatarList_ []
        ]

      , section []
        [ h3 [] [ Html.text "Avatar List (Dense)" ]
        , avatarList_ [ Lists.dense ]
        ]

      , section []
        [ h3 [] [ Html.text "End Detail" ]
        , endDetail_ []
        ]

      , section []
        [ h3 [] [ Html.text "End Detail (Dense)" ]
        , endDetail_ [ Lists.dense ]
        ]

      , section []
        [ h3 [] [ Html.text "Example - Two-line avatar + text + icon" ]
        , twoLineAvatarPlusTextPlusIconExample
        ]

      , section
        [ cs "mdc-theme--dark"
        ]
        [ h3 [] [ Html.text "Example - Two-line avatar + text + icon (Dark)" ]
        , twoLineAvatarPlusTextPlusIconExample
        ]
      ]

    , demoWrapper []
      [ h2 [] [ Html.text "List Dividers" ]
      ,
        section []
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
      ,
        section []
        [ h3 [] [ Html.text "Basic Usage" ]
        , basicGroups
        ]

      , section []
        [ h3 [] [ Html.text "Example - Two-line Lists, Avatars, end detail, inset dividers" ]
        , groupsExample
        ]

      , section
        [ cs "mdc-theme--dark"
        ]
        [ h3 [] [ Html.text "Example - Two-line Lists, Avatars, end detail, inset dividers (Dark)" ]
        , groupsExample
        ]
      ]

    , demoWrapper []
      [ h2 [] [ Html.text "Interactive Lists (with ink ripple)" ]
      ,
        section []
        [ h3 [] [ Html.text "Example - Interactive List" ]
        , interactiveList lift [0] model
        ]

      , section
        [ cs "mdc-theme--dark"
        ]
        [ h3 [] [ Html.text "Example - Interactive List (Dark)" ]
        , interactiveList lift [1] model
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


singleLine : List (Options.Style m) -> Html m
singleLine options =
    Lists.ul options
    ( Lists.li [] [ Html.text "Single-line item" ]
      |> List.repeat 3
    )


startDetail : List (Options.Style m) -> Html m
startDetail options =
    Lists.ul options
    ( Lists.li []
      [ Lists.startDetail [ cs "gray-bg" ] []
      , Html.text "Single-line item"
      ]
        |> List.repeat 3
    )


startDetailExample : Html m
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


avatarList : List (Options.Style m) -> Html m
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


avatarListExample : Html m
avatarListExample =
    Lists.ul
    [ Lists.avatar
    ]
    [ Lists.li []
      [ Lists.avatarImage "images/animal1.svg" []
      , Html.text "Panda"
      ]
    , Lists.li []
      [ Lists.avatarImage "images/animal2.svg" []
      , Html.text "Sleuth"
      ]
    , Lists.li []
      [ Lists.avatarImage "images/animal3.svg" []
      , Html.text "Brown Bear"
      ]
    ]


endDetail : List (Options.Style m) -> Html m
endDetail options =
    Lists.ul options
    ( Lists.li []
      [ Html.text "Single-line item"
      , Lists.endDetail [ cs "gray-bg" ] []
      ]
        |> List.repeat 3
    )


avatarPlusEndDetail : List (Options.Style m) -> Html m
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


avatarWithTextAndIconExample : Html m
avatarWithTextAndIconExample =
    let
        item src text icon =
            let
                url =
                    "images/" ++ src
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


twoLine : List (Options.Style m) -> Html m
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


startDetail_ : List (Options.Style m) -> Html m
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


avatarList_ : List (Options.Style m) -> Html m
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


endDetail_ : List (Options.Style m) -> Html m
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


twoLineAvatarPlusTextPlusIconExample : Html m
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
      , Lists.avatar
      , Options.id "two-line-avatar-text-icon-demo"
      ]
      [ item "Photos" "Jan 9, 2014"
      , item "Recipes" "Jan 17, 2014"
      , item "Work" "Jan 28, 2014"
      ]
    ]


fullWidthDividers : Html m
fullWidthDividers =
    Lists.ul []
    ( List.concat
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
    [ Lists.avatar
    ]
    ( List.concat
      [ Lists.li []
        [ Lists.startDetail [ cs "gray-bg" ] []
        , Html.text "Single-line item - section 1"
        ]
          |> List.repeat 3
      , [ Lists.divider [ Lists.inset ] []
        ]
      , Lists.li []
        [ Lists.startDetail [ cs "gray-bg" ] []
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
      ( Lists.li [] [ Html.text "Single-line item" ]
        |> List.repeat 3
      )
    , Lists.divider [] []
    , Lists.subheader [] [ Html.text "List 2" ]
    , Lists.ul []
      ( Lists.li [] [ Html.text "Single-line item" ]
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
      , Lists.divider [ Lists.inset ] []
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


interactiveList : (Msg msg -> msg) -> List Int -> Model -> Html msg
interactiveList lift idx model =
    Lists.ul []
    [
      let
          ( rippleOptions, rippleStyle ) =
              Ripple.bounded (lift << Mdl) (idx ++ [0]) model.mdl [] []
      in
      Lists.li
      [ rippleOptions
      ]
      [ Lists.startDetailIcon "network_wifi" []
      , Html.text "Wi-Fi"
      , rippleStyle
      ]
    ,
      let
          ( rippleOptions, rippleStyle ) =
              Ripple.bounded (lift << Mdl) (idx ++ [1]) model.mdl [] []
      in
      Lists.li
      [ rippleOptions
      ]
      [ Lists.startDetailIcon "bluetooth" []
      , Html.text "Bluetooth"
      , rippleStyle
      ]
    ,
      let
          ( rippleOptions, rippleStyle ) =
              Ripple.bounded (lift << Mdl) (idx ++ [2]) model.mdl [] []
      in
      Lists.li
      [ rippleOptions
      ]
      [ Lists.startDetailIcon "data_usage" []
      , Html.text "Data Usage"
      , rippleStyle
      ]
    ]
