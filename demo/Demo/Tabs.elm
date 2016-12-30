module Demo.Tabs exposing (..)

import Platform.Cmd exposing (Cmd, none)
import Html exposing (..)
import Markdown
import Material.Options as Options exposing (css)
import Material.Icon as Icon
import Material.Tabs as Tabs
import Material
import Demo.Page as Page
import Demo.Code as Code


-- MODEL


type alias Model =
    { mdl : Material.Model
    , tab : Int
    }


model : Model
model =
    { mdl = Material.model
    , tab = 1
    }



-- ACTION, UPDATE


type Msg
    = SelectTab Int
    | Mdl (Material.Msg Msg)


update : Msg -> Model -> ( Model, Cmd Msg )
update action model =
    case action of
        SelectTab idx ->
            ( { model | tab = idx }, Cmd.none )

        Mdl msg_ ->
            Material.update Mdl msg_ model



-- VIEW


aboutTab : Html Msg
aboutTab =
    """
From the [Material Design specification](https://material.google.com/components/tabs.html#tabs-usage):

> Use tabs to organize content at a high level, for example, to present different sections of a newspaper. Don’t use tabs for carousels or pagination of content. Those use cases involve viewing content, not navigating between groups of content.
>
> For more detail about using tabs for navigating top-level views, see “Tabs” in Patterns > Navigation.
>
> Don't use tabs with content that supports the swipe gesture, because swipe gestures are used for navigating between tabs. For example, avoid using tabs in a map where content is pannable, or a list where items can be dismissed with a swipe.
>
> Fixed tabs should be used with a limited number of tabs and when consistent placement will aid muscle memory. Scrollable tabs should be used when there are many or a variable number of tabs.
    """
        |> Markdown.toHtml []


exampleTab : Html Msg
exampleTab =
    Code.code []
        """
     Tabs.render Mdl [0] model.mdl
      [ Tabs.ripple
      , Tabs.onSelectTab SelectTab
      , Tabs.activeTab model.tab
      ]
      [ Tabs.label
          [ Options.center ]
          [ Icon.i "info_outline"
          , Options.span [ css "width" "4px" ] []
          , text "About tabs"
          ]
      , Tabs.label
          [ Options.center ]
          [ Icon.i "code"
          , Options.span [ css "width" "4px" ] []
          , text "Example"
          ]
      ]
      [ case model.tab of
          0 -> aboutTab
          _ -> exampleTab
      ]
     """


view : Model -> Html Msg
view model =
    [ Tabs.render Mdl
        [ 0 ]
        model.mdl
        [ Tabs.ripple
        , Tabs.onSelectTab SelectTab
        , Tabs.activeTab model.tab
        ]
        [ Tabs.label
            [ Options.center ]
            [ Icon.i "info_outline"
            , Options.span [ css "width" "4px" ] []
            , text "About tabs"
            ]
        , Tabs.label
            [ Options.center ]
            [ Icon.i "code"
            , Options.span [ css "width" "4px" ] []
            , text "Example"
            ]
        ]
        [ Options.div
            [ css "margin" "24px auto"
            , css "align-items" "flex-start"
            , Options.center
            , css "overflow-y" "auto"
            , css "height" "512px"
            ]
            [ case model.tab of
                0 ->
                    aboutTab

                _ ->
                    exampleTab
            ]
        ]
    ]
        |> Page.body2 "Tabs" srcUrl intro references


intro : Html m
intro =
    Page.fromMDL "https://getmdl.io/components/index.html#layout-section/tabs" """
> The Material Design Lite (MDL) tab component is a user interface element that
> allows different content blocks to share the same screen space in a mutually
> exclusive manner. Tabs are always presented in sets of two or more, and they
> make it easy to explore and switch among different views or functional aspects
> of an app, or to browse categorized data sets individually. Tabs serve as
> "headings" for their respective content; the active tab — the one whose content
> is currently displayed — is always visually distinguished from the others so the
> user knows which heading the current content belongs to.
>
> Tabs are an established but non-standardized feature in user interfaces, and
> allow users to view different, but often related, blocks of content (often
> called panels). Tabs save screen real estate and provide intuitive and logical
> access to data while reducing navigation and associated user confusion. Their
> design and use is an important factor in the overall user experience. See the
> tab component's Material Design specifications page for details.
"""


srcUrl : String
srcUrl =
    "https://github.com/debois/elm-mdl/blob/master/demo/Demo/Tabs.elm"


references : List ( String, String )
references =
    [ Page.package "http://package.elm-lang.org/packages/debois/elm-mdl/latest/Material-Tabs"
    , Page.mds "https://material.google.com/components/tabs.html"
    , Page.mdl "https://getmdl.io/components/index.html#layout-section/tabs"
    ]
