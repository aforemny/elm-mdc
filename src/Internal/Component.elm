module Internal.Component exposing
    ( Index
    , Indexed
    , indexed
    , render
    , subs
    , react
    , generalise
    )

import Dict exposing (Dict)
import Internal.Index
import Internal.Msg exposing (Msg(..))
import Internal.Options as Options exposing (Property)


type alias Index
    = Internal.Index.Index


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


render :
    (Index -> store -> model)
    -> ((msg -> m) -> model -> List (Property c m) -> a)
    -> (Index -> msg -> Msg m)
    -> (Msg m -> m)
    -> Index
    -> store
    -> List (Property c m)
    -> a
render get_model view ctor =
    \ lift idx store options ->
        view (lift << ctor idx) (get_model idx store) (Options.dispatch lift :: options)


type alias Update msg m model =
    (msg -> m) -> msg -> model -> ( Maybe model, Cmd m )


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
