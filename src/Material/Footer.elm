module Material.Footer
    exposing
        ( FooterProperty
        , Property
        , Content
        , mini
        , mega
        , left
        , right
        , top
        , bottom
        , middle
        , html
        , logo
        , socialButton
        , href
        , link
        , dropdown
        , heading
        , links
        , linkItem
        , Section
        , TopSection
        , MiddleSection
        , BottomSection
        , MegaFooter
        , MiniFooter
        )

{-| From the [Material Design Lite documentation](https://getmdl.io/components/index.html#layout-section/footer):

> The Material Design Lite (MDL) footer component is a comprehensive container
> intended to present a substantial amount of related content in a visually
> attractive and logically intuitive area. Although it is called "footer", it
> may be placed at any appropriate location on a device screen, either before or
> after other content.
>
> An MDL footer component takes two basic forms: mega-footer and mini-footer. As
> the names imply, mega-footers contain more (and more complex) content than
> mini-footers. A mega-footer presents multiple sections of content separated by
> horizontal rules, while a mini-footer presents a single section of content. Both
> footer forms have their own internal structures, including required and optional
> elements, and typically include both informational and clickable content, such
> as links.
>
> Footers, as represented by this component, are a fairly new feature in user
> interfaces, and allow users to view discrete blocks of content in a coherent and
> consistently organized way. Their design and use is an important factor in the
> overall user experience.

See also the
[Material Design Specification](https://material.google.com/layout/structure.html).

Refer to [this site](http://debois.github.io/elm-mdl/#footers)
for a live demo.

# Types

@docs Content
@docs FooterProperty
@docs Property

@docs MegaFooter, MiniFooter

@docs Section
@docs TopSection, MiddleSection, BottomSection

# Helpers

@docs html
@docs link, href

# Appearance

@docs mini, mega

# Sections

@docs left, right, top, bottom, middle

# Content

@docs links, logo, socialButton, dropdown, heading, linkItem

-}

import Html exposing (..)
import Html.Attributes as Html
import Material.Options as Options exposing (Style, cs)
import String
import Regex
import Material.Options.Internal as Internal


{-| The type of the footer
-}
type Type
    = Mini
    | Mega


prefix : Type -> String
prefix tp =
    case tp of
        Mini ->
            "mdl-mini-footer"

        Mega ->
            "mdl-mega-footer"


separator : String
separator =
    "__"


{-| `FooterProperty`
-}
type FooterProperty
    = FooterProperty


{-| Properties for footers
-}
type alias Property m =
    Options.Property FooterProperty m


{-| Opaque Footer content
-}
type Content a
    = HtmlContent (Html a)
    | Content (Footer a)


{-| Internal type alias for content within a footer
-}
type alias Footer a =
    { styles : List (Property a)
    , content : List (Content a)
    , elem : Element a
    }


{-| Helpers alias to html a Html element function
-}
type alias Element a =
    List (Html.Attribute a) -> List (Html.Html a) -> Html.Html a


{-| Strongly typed `Section` in a footer
-}
type Section a
    = Section (Content a)


{-| Strongly typed `TopSection` in a footer
-}
type TopSection a
    = TopSection
        { left : Maybe (Section a)
        , right : Maybe (Section a)
        , props : List (Property a)
        }


{-| Strongly typed `BottomSection` in a footer
-}
type BottomSection a
    = BottomSection
        { props : List (Property a)
        , content : List (Content a)
        }


{-| Strongly typed `MiddleSection` in a footer
-}
type MiddleSection a
    = MiddleSection
        { props : List (Property a)
        , content : List (Content a)
        }


{-| MiniFooter consists of two sections
-}
type alias MiniFooter a =
    { left : Maybe (Section a)
    , right : Maybe (Section a)
    }


{-| MegaFooter consists of three sections
-}
type alias MegaFooter a =
    { top : Maybe (TopSection a)
    , bottom : Maybe (BottomSection a)
    , middle : Maybe (MiddleSection a)
    }


{-| Creates a footer `top-section`
-}
top : List (Property m) -> MiniFooter m -> Maybe (TopSection m)
top props { left, right } =
    Just <|
        TopSection
            { left = left
            , right = right
            , props = props
            }


{-| Creates a footer `bottom-section`
-}
bottom : List (Property m) -> List (Content m) -> Maybe (BottomSection m)
bottom props content =
    Just <|
        BottomSection
            { props = props
            , content = content
            }


{-| Create a dropdown section `checkbox`
-}
checkbox : Content m
checkbox =
    HtmlContent <|
        Html.input
            [ Html.class "mdl-mega-footer__heading-checkbox"
            , Html.type_ "checkbox"
              -- For some reason Html.checked True did not work (did not show up in dom)
            , Html.attribute "checked" ""
            ]
            []


{-| Creates a footer `dropdown` section
-}
dropdown : List (Property m) -> List (Content m) -> Content m
dropdown props content =
    Content
        { styles = (cs "mdl-mega-footer__drop-down-section" :: props)
        , content = (checkbox :: content)
        , elem = Html.div
        }


{-| Creates a footer `middle-section`
-}
middle : List (Property m) -> List (Content m) -> Maybe (MiddleSection m)
middle props content =
    Just <|
        MiddleSection
            { props = props
            , content = content
            }


{-| Creates a footer of `Type` `Mega`
-}
mega : List (Property m) -> MegaFooter m -> Html m
mega props { top, bottom, middle } =
    let
        tp =
            Mega

        pref =
            prefix tp

        sep =
            separator

        topContent =
            case top of
                Nothing ->
                    []

                Just (TopSection { props, left, right }) ->
                    [ Options.styled Html.div
                        (cs (pref ++ sep ++ "top-section") :: props)
                        ((leftHtml tp left) ++ (rightHtml tp right))
                    ]

        middleContent =
            case middle of
                Nothing ->
                    []

                Just (MiddleSection { props, content }) ->
                    [ Options.styled Html.div
                        (cs (pref ++ sep ++ "middle-section") :: props)
                        (List.map (contentToHtml tp) content)
                    ]

        bottomContent =
            case bottom of
                Nothing ->
                    []

                Just (BottomSection { props, content }) ->
                    [ Options.styled Html.div
                        (cs (pref ++ sep ++ "bottom-section") :: props)
                        ([] ++ (List.map (contentToHtml tp) content))
                    ]
    in
        Options.styled Html.footer
            (cs pref :: props)
            (topContent ++ middleContent ++ bottomContent)


{-| Creates a footer `left-section`
-}
left : List (Property m) -> List (Content m) -> Maybe (Section m)
left styles content =
    (Just << Section) <|
        Content
            { styles = styles
            , content = content
            , elem = Html.div
            }


{-| Creates a footer `right-section`
-}
right : List (Property m) -> List (Content m) -> Maybe (Section m)
right styles content =
    (Just << Section) <|
        Content
            { styles = styles
            , content = content
            , elem = Html.div
            }


{-| Creates a footer of `Type` `Mini`
-}
mini : List (Property m) -> MiniFooter m -> Html m
mini props { left, right } =
    let
        tp =
            Mini

        pref =
            prefix tp

        leftContent =
            leftHtml tp left

        rightContent =
            rightHtml tp right
    in
        Options.styled Html.footer
            (cs pref :: props)
            (leftContent ++ rightContent)


{-| href for Links.
-}
href : String -> Property m
href =
    Html.href >> Internal.attribute


{-| Wraps a normal HTML value into `Content`
-}
html : Html m -> Content m
html =
    HtmlContent



-- INTERNAL HELPERS


tempPrefix : String
tempPrefix =
    "{{prefix}}"


prefixRegex : Regex.Regex
prefixRegex =
    Regex.regex tempPrefix


prefixedClass : String -> Property m
prefixedClass cls =
    Options.cs (tempPrefix ++ cls)


removePrefix : String -> String
removePrefix =
    Regex.replace Regex.All prefixRegex (\_ -> "")


applyPrefix : Type -> Property m -> Property m
applyPrefix tp prop =
    let
        pref =
            prefix tp

        sep =
            separator
    in
        case prop of
            Internal.Class s ->
                if (String.startsWith tempPrefix s) then
                    Options.cs (pref ++ sep ++ (removePrefix s))
                else
                    prop

            Internal.Many props ->
                Options.many <| List.map (applyPrefix tp) props

            _ ->
                prop


toHtml : Type -> Footer a -> Html a
toHtml tp { styles, content, elem } =
    let
        styles_ =
            List.map (applyPrefix tp) styles
    in
        Options.styled elem
            styles_
            (List.map (contentToHtml tp) content)


contentToHtml : Type -> Content a -> Html a
contentToHtml tp content =
    case content of
        HtmlContent html ->
            html

        Content c ->
            (toHtml tp c)


sectionContent : Type -> String -> Content m -> Html m
sectionContent tp section content =
    let
        pref =
            prefix tp

        sep =
            separator
    in
        case content of
            HtmlContent html ->
                Options.styled Html.div
                    (cs (pref ++ sep ++ section) :: [])
                    [ html ]

            Content { styles, content, elem } ->
                Options.styled elem
                    (cs (pref ++ sep ++ section) :: styles)
                    (List.map (contentToHtml tp) content)


leftHtml : Type -> Maybe (Section a) -> List (Html a)
leftHtml tp left =
    case left of
        Just (Section content) ->
            [ sectionContent tp "left-section" content ]

        Nothing ->
            []


rightHtml : Type -> Maybe (Section a) -> List (Html a)
rightHtml tp right =
    case right of
        Just (Section content) ->
            [ sectionContent tp "right-section" content ]

        Nothing ->
            []



-- END OF INTERNAL HELPERS


socialBtn : Property m
socialBtn =
    prefixedClass "social-btn"


{-| Creates a footer logo
-}
logo : List (Property m) -> List (Content m) -> Content m
logo styles content =
    Content
        { styles = (cs "mdl-logo" :: styles)
        , content = content
        , elem = Html.div
        }


{-| Creates a `link-list`
-}
links : List (Property m) -> List (Content m) -> Content m
links styles content =
    Content
        { styles = (prefixedClass "link-list" :: styles)
        , content = content
        , elem = Html.ul
        }


{-| Creates a link
-}
link : List (Property m) -> List (Html m) -> Content m
link styles contents =
    html <|
        Options.styled a
            styles
            contents


li : List (Property m) -> List (Html m) -> Content m
li styles content =
    html <|
        Options.styled Html.li
            styles
            content


{-| Creates a link wrapped in a `li`-element
-}
linkItem : List (Property m) -> List (Content m) -> Content m
linkItem styles content =
    Content
        { styles = []
        , content = [ Content { styles = styles, content = content, elem = Html.a } ]
        , elem = Html.li
        }


headingClass : Property m
headingClass =
    prefixedClass "heading"


{-| Creates a footer `heading` element
-}
heading : List (Property m) -> List (Content m) -> Content m
heading styles content =
    Content
        { styles = headingClass :: styles
        , content = content
        , elem = Html.h1
        }


{-| Creates a `social-button` with the proper prefix based on the `Type`
-}
socialButton : List (Property m) -> List (Content m) -> Content m
socialButton styles content =
    Content
        { styles = (socialBtn :: styles)
        , content = content
        , elem = Html.button
        }
