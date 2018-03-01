module Material.Component
    exposing
        ( Index
        , Indexed
        , indexed
        , render
        , render1
        , subs
        , react1
        , react
        , generalise
        )

{-|
@docs Indexed, Store
@docs indexed, render
@docs subs
-}

import Dict exposing (Dict)
import Material.Msg exposing (Index, Msg(..))

{-| Type of indices. An index has to be `comparable`

For example:
An index can be a list of `Int` rather than just an `Int` to
support nested dynamically constructed elements: Use indices `[0]`, `[1]`, ...
for statically known top-level components, then use `[0,0]`, `[0,1]`, ...
for a dynamically generated list of components.
-}
type alias Index
    = Material.Msg.Index


{-| Indexed families of things.
-}
type alias Indexed x =
    Dict Index x


indexed :
    (store -> Indexed model)
    -> (Indexed model -> store -> store)
    -> model
    -> ( Index -> store -> model, Index -> store -> model -> store )
indexed get_model set_model model0 =
    let
        get_ idx store =
            get_model store
                |> Dict.get idx
                |> Maybe.withDefault model0

        set_ idx store model =
            set_model (Dict.insert idx model (get_model store)) store
    in
        ( get_, set_ )


{-| TODO
-}
render1 :
    (store -> model)
    -> ((msg -> m) -> model -> x)
    -> (msg -> Msg m)
    -> (Msg m -> m)
    -> store
    -> x
render1 get_model view ctor =
    \lift store ->
        view (lift << ctor) (get_model store)


{-| TODO
-}
render :
    (Index -> store -> model)
    -> ((msg -> m) -> model -> x)
    -> (Index -> msg -> Msg m)
    -> (Msg m -> m)
    -> Index
    -> store
    -> x
render get_model view ctor =
    \lift idx store ->
        view (lift << ctor idx) (get_model idx store) 


type alias Update msg m model =
    (msg -> m) -> msg -> model -> ( Maybe model, Cmd m )


react1 :
    (store -> model)
    -> (store -> model -> store)
    -> (msg -> mdcmsg)
    -> Update msg m model
    -> (mdcmsg -> m)
    -> msg
    -> store
    -> ( Maybe store, Cmd m )
react1 get set ctor update lift msg store =
    update (lift << ctor) msg (get store)
        |> Tuple.mapFirst (Maybe.map (set store))


react :
    (Index -> store -> model)
    -> (Index -> store -> model -> store)
    -> (Index -> msg -> mdcmsg)
    -> Update msg m model
    -> (mdcmsg -> m)
    -> msg
    -> Index
    -> store
    -> ( Maybe store, Cmd m )
react get set ctor update lift msg idx store =
    update (lift << ctor idx) msg (get idx store)
        |> Tuple.mapFirst (Maybe.map (set idx store))


generalise :
    (msg -> model -> ( model, Cmd msg ))
    -> Update msg m model
generalise update lift msg model =
    update msg model
        |> Tuple.mapFirst Just
        |> Tuple.mapSecond (Cmd.map lift)


subs :
    (Index -> msg -> mdcmsg)
    -> (store -> Indexed model)
    -> (model -> Sub msg)
    -> (mdcmsg -> m)
    -> store
    -> Sub m
subs ctor get subscriptions lift model =
    model
        |> get
        |> Dict.foldl
            (\idx model ss ->
                Sub.map (lift << ctor idx) (subscriptions model) :: ss
            )
            []
        |> Sub.batch
