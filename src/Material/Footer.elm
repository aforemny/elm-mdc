module Material.Footer
  exposing
    ( Type(..), Property, Content(..), Footer, Element
    , mini, mega, footer
    , left, right, top, bottom, middle
    , wrap
    , logo, text, socialButton
    , href, link, onClick
    , dropdown
    , heading
    , links
    , linkItem
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

Refer to [this site](http://debois.github.io/elm-mdl#/footer)
for a live demo.

# Types

@docs Type
@docs Content, Footer, Element
@docs Property

# Helpers

@docs wrap
@docs link, onClick, href

# Appearance

@docs footer, mini, mega

# Sections

@docs left, right, top, bottom, middle

# Content

@docs links, logo, text, socialButton, dropdown, heading, linkItem

-}

import Html exposing (..)
import Html.Attributes as Html
import Html.Events as Events
import Material.Options as Options exposing (Style, cs)
import String
import Regex
import Material.Options.Internal as Internal exposing (attribute)


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


{-| TODO
-}
type FooterProperty
  = FooterProperty


{-| TODO
-}
type alias Property m =
  Options.Property FooterProperty m


{-| TODO
-}
type Content a
  = HtmlContent (Html a)
  | Content (Footer a)


{-| Helpers alias to wrap a Html element function
-}
type alias Element a =
  List (Html.Attribute a) -> List (Html.Html a) -> Html.Html a


{-| Internal type alias for content within a footer
-}
type alias Footer a =
  { styles : List (Property a)
  , content : List (Content a)
  , elem : Element a
  }


{-| onClick for Links and Buttons.
-}
onClick : m -> Property m
onClick =
  Events.onClick >> attribute


{-| href for Links.
-}
href : String -> Property m
href =
  Html.href >> attribute


{-| Wraps a normal HTML value into `Content`
-}
wrap : Html m -> Content m
wrap =
  HtmlContent


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



-- INTERNAL HELPERS


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
    styles' =
      List.map (applyPrefix tp) styles
  in
    Options.styled elem
      styles'
      (List.map (contentToHtml tp) content)


contentToHtml : Type -> Content a -> Html a
contentToHtml tp content =
  case content of
    HtmlContent html ->
      html

    Content c ->
      (toHtml tp c)



-- End of helpers


{-| Creates a section with the given class name
that gets prefixed by the footer
-}
section : String -> List (Property m) -> List (Content m) -> Content m
section section styles content =
  Content
    { styles = (prefixedClass section :: styles)
    , content = content
    , elem = Html.div
    }


{-| Creates a footer `left-section`
-}
left : List (Property m) -> List (Content m) -> Content m
left =
  section "left-section"


{-| Creates a footer `right-section`
-}
right : List (Property m) -> List (Content m) -> Content m
right =
  section "right-section"


{-| Creates a footer `top-section`
-}
top : List (Property m) -> List (Content m) -> Content m
top =
  section "top-section"


{-| Creates a footer `middle-section`
-}
middle : List (Property m) -> List (Content m) -> Content m
middle =
  section "middle-section"


{-| Creates a footer `bottom-section`
-}
bottom : List (Property m) -> List (Content m) -> Content m
bottom =
  section "bottom-section"


{-| Creates a footer of `Type`
-}
footer : Type -> List (Property m) -> List (Content m) -> Html m
footer tp config content =
  let
    pref =
      prefix tp
  in
    Options.styled Html.footer
      (cs pref :: config)
      (List.map (contentToHtml tp) content)


{-| Creates a footer of `Type` `Mini`
-}
mini : List (Property m) -> List (Content m) -> Html m
mini =
  footer Mini


{-| Creates a footer of `Type` `Mega`
-}
mega : List (Property m) -> List (Content m) -> Html m
mega =
  footer Mega


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
link : List (Property m) -> List (Html m) -> Html m
link styles contents =
  Options.styled a
    styles
    contents


li : List (Property m) -> List (Html m) -> Content m
li styles content =
  wrap
    <| Options.styled Html.li
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


{-| Creates a footer `dropdown` section
-}
dropdown : List (Property m) -> List (Content m) -> Content m
dropdown styles content =
  Content
    { styles = (prefixedClass "drop-down-section" :: styles)
    , content = content
    , elem = Html.div
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


{-| Wraps `Html.text` element to `Content`
-}
text : String -> Content m
text =
  Html.text >> wrap


{-| Creates a `social-button` with the proper prefix based on the `Type`
-}
socialButton : List (Property m) -> List (Content m) -> Content m
socialButton styles content =
  Content
    { styles = (socialBtn :: styles)
    , content = content
    , elem = Html.button
    }
