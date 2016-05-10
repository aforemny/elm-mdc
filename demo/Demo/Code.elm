module Demo.Code where

import Html exposing (Html, text)
import Signal exposing (Address)
import Effects exposing (Effects)
import String
import Markdown

import Material.Options exposing (css, div, stylesheet)
import Material.Helpers as Helpers


type State 
  = Idle 
  | First String
  | Showing String
  | FadingIn String
  | FadingOut (String, String)


type alias Model = State


model : Model 
model = Idle

type Action 
  = Set String
  | Timeout String


delay : Float
delay = 
  200


later : String -> Effects Action 
later s = 
  Helpers.delay delay (Timeout s)


update : Action -> State -> (State, Effects Action)
update action state = 
  let
    guard b x = 
      if b then 
        x
      else
        (state, Effects.none)
  in
    case action of 
      Set s -> 
        case state of 
          Idle ->              
            (First s, Effects.tick (always (Timeout s)))

          First _ -> 
            (First s, Effects.none)
            
          Showing s' -> 
            guard (s /= s') ( FadingOut (s', s), later s' )

          FadingIn s' ->       
            guard (s /= s') ( FadingOut (s', s), later s )

          FadingOut (s', _) -> 
            (FadingOut (s', s), Effects.none)

      Timeout s -> 
        case state of 
          Idle -> 
            ( state, Effects.none ) -- Can't happen

          First _ -> 
            ( FadingIn s, later s )

          Showing s' -> 
            ( state, Effects.none ) -- Also can't happen

          FadingIn s' -> 
            guard (s == s') ( Showing s, Effects.none )

          FadingOut (s', s'') -> 
            guard (s == s') ( FadingIn s'', later s'' )


-- Shenanigans to strip extra whitespace from code examples. 


lead : Int -> String -> Int
lead k str = 
  case String.uncons str of 
    Just (' ', str') -> 
      lead (k+1) str'

    _ -> 
      k


dropWhile : (a -> Bool) -> List a -> List a
dropWhile f xs =
  case xs of
    [] -> 
      xs
    (x :: xs') as xs -> 
      if f x then dropWhile f xs' else xs

trim : String -> String
trim s = 
  let
    -- Drop initial empty lines
    lines = 
      String.trimRight s
        |> String.lines 
        |> dropWhile (String.trim >> (==) "")
    -- Find the amount of lead space on the first line
    k = 
      List.head lines 
        |> Maybe.map (lead 0)
        |> Maybe.withDefault 0
  in
    -- Remove that amount of space from every line
    lines 
      |> List.map (String.dropLeft k)
      |> String.join "\n"


code : String -> Html
code str = 
  Markdown.toHtml <| "```elm\n" ++ trim str ++ "\n```"


-- VIEW


view : Address Action -> State -> Html
view addr state = 
  let 
    opacity =
      case state of 
        Idle -> 0
        First _ -> 0
        FadingIn _ -> 1.0
        FadingOut _ -> 0 
        Showing _ -> 1.0
    body = 
      case state of 
        Idle -> text ""
        First s -> code s
        FadingIn s -> code s
        FadingOut (s, _) -> code s
        Showing s -> code s
  in
    div 
      [ css "transition" ("opacity " ++ toString delay ++ "ms ease-in-out")
      , css "opacity" (toString opacity)
      ]
      [ body ]






