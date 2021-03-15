module Internal.Tooltip.Implementation exposing
    ( Property
    , actions
    , button
    , content
    , contentLink
    , hide
    , interactive
    , persistent
    , react
    , rich
    , shown
    , title
    , view
    , wrapper
    )

import Browser.Dom as Dom
import Html as Html exposing (Html, text, div)
import Html.Attributes as Html
import Internal.Helpers exposing (delayedCmd)
import Internal.Component as Component exposing (Index, Indexed)
import Internal.Msg
import Internal.Options as Options exposing (aria, cs, css, role, styled, when)
import Internal.Tooltip.Model exposing (..)
import Internal.Tooltip.XPosition as XPosition exposing (XPosition)
import Internal.Tooltip.YPosition as YPosition exposing (YPosition)
import Json.Decode as Decode exposing (Decoder)
import Set exposing (Set)
import Svg
import Svg.Attributes as Svg
import Task


update : (Msg m -> m) -> Msg m -> Model -> ( Maybe Model, Cmd m )
update lift msg model =
    case msg of
        NoOp ->
            ( Nothing, Cmd.none )

        ShowPlainTooltip anchor_id tooltip_id ->
            ( Nothing, delayedCmd showDelayMs <| lift <| DoShowPlainTooltip anchor_id tooltip_id )

        DoShowPlainTooltip anchor_id tooltip_id ->
            if model.state == Hidden then
                ( Just { model | state = Showing, isRich = False, inTransition = False, parentRect = Nothing, anchorRect = Nothing, tooltip = Nothing }
                , Cmd.batch
                      [ getElement lift tooltip_id GotTooltipElement
                      , getElement lift anchor_id GotAnchorElement
                      ]
                )
            else
                ( Nothing, Cmd.none )

        ShowRichTooltip wrapper_id anchor_id tooltip_id ->
            ( Nothing, delayedCmd showDelayMs <| lift <| DoShowRichTooltip wrapper_id anchor_id tooltip_id )

        DoShowRichTooltip wrapper_id anchor_id tooltip_id ->
            if model.state == Hidden then
                ( Just { model | state = Showing, isRich = True, inTransition = False, parentRect = Nothing, anchorRect = Nothing, tooltip = Nothing }
                , Cmd.batch
                      [ getElement lift tooltip_id GotTooltipElement
                      , getElement lift anchor_id GotAnchorElement
                      , getElement lift wrapper_id GotParentElement
                      ]
                )
            else
                ( Nothing, Cmd.none )

        Show ->
            case ( model.parentRect, model.anchorRect, model.tooltip ) of
                ( Nothing, Just anchorRect, Just a_tooltip ) ->
                    ( Just <| if not model.isRich then positionPlainTooltip model anchorRect a_tooltip else model, Cmd.none )
                ( Just parentRect, Just anchorRect, Just a_tooltip ) ->
                    ( Just <| positionRichTooltip model parentRect anchorRect a_tooltip, Cmd.none )
                ( _, _, _ ) ->
                    ( Just model, Cmd.none )

        GotParentElement el ->
            let
                e = el.element
            in
                update lift Show { model | parentRect = Just <| ParentRect e.x e.y }

        GotAnchorElement el ->
            let
                e = el.element
            in
                update lift Show { model | anchorRect = Just <| ClientRect e.x (e.x + e.width) e.y (e.y + e.height) e.width e.height }

        GotTooltipElement el ->
            let
                e = el.element
            in
                update lift Show  { model | tooltip = Just <| Tooltip e.width e.height el.viewport.width el.viewport.height model.isRich }

        StartHide ->
            if model.state == Shown && not model.inTransition then
                ( Nothing, delayedCmd hideDelayMs <| lift <| DoStartHide )
            else
                ( Nothing, Cmd.none )

        DoStartHide ->
            ( Just { model | state = Hide, inTransition = True }, Cmd.none )

        TransitionEnd ->
            if model.inTransition then
                ( Just { model | inTransition = False, state = if model.state == Hide then Hidden else model.state }, Cmd.none )
            else
                ( Nothing, Cmd.none )



positionPlainTooltip : Model -> ClientRect -> Tooltip -> Model
positionPlainTooltip model anchorRect a_tooltip =
    let
        { top, yTransformOrigin, left, xTransformOrigin } = calculateTooltipStyles model.xTooltipPos model.yTooltipPos anchorRect a_tooltip

        -- MDC calls `getCorrectPropertyName()`, not sure why
        transformProperty = "transform"
    in
        { model | state = Shown, inTransition = True, xTransformOrigin = xTransformOrigin, yTransformOrigin = yTransformOrigin, left = left, top = top }



positionRichTooltip : Model -> ParentRect -> ClientRect -> Tooltip -> Model
positionRichTooltip model parentRect anchorRect a_tooltip =
    let
        -- getComputedStyleProperty is used instead of getTooltipSize since
        -- getTooltipSize returns the offSetWidth, which includes the border and
        -- padding. What we need is the width of the tooltip without border and
        -- padding.
        -- TODO: how do we do this in Elm?
        -- width = getComputedStyleProperty "width"

        { top, yTransformOrigin, left, xTransformOrigin } = calculateTooltipStyles model.xTooltipPos model.yTooltipPos anchorRect a_tooltip

        -- MDC calls `getCorrectPropertyName()`, not sure why
        transformProperty = "transform"

        leftAdjustment = left - parentRect.left
        topAdjustment = top - parentRect.top

    in
        { model | state = Shown, inTransition = True, xTransformOrigin = xTransformOrigin, yTransformOrigin = yTransformOrigin, left = leftAdjustment, top = topAdjustment }



{-|
Calculates the position of the tooltip. A tooltip will be placed
beneath the anchor element and aligned either with the 'start'/'end'
edge of the anchor element or the 'center'.

Tooltip alignment is selected such that the tooltip maintains a
threshold distance away from the viewport (defaulting to 'center'
alignment). If the placement of the anchor prevents this threshold
distance from being maintained, the tooltip is positioned so that it
does not collide with the viewport.

Users can specify an alignment, however, if this alignment results in
the tooltip colliding with the viewport, this specification is
overwritten.
-}
type alias TooltipStyles =
    { top : Float
    , yTransformOrigin : YTransformOrigin
    , left: Float
    , xTransformOrigin: XTransformOrigin
    }

calculateTooltipStyles : XPosition -> YPosition -> ClientRect -> Tooltip -> TooltipStyles
calculateTooltipStyles xTooltipPos yTooltipPos anchorRect a_tooltip =
    let
        top = calculateYTooltipDistance yTooltipPos anchorRect a_tooltip
        left = calculateXTooltipDistance xTooltipPos anchorRect a_tooltip
    in
        TooltipStyles top.distance top.transformOrigin left.distance left.transformOrigin



{-
Calculates the `left` distance for the tooltip.

Returns the distance value and a string indicating the x-axis
transform- origin that should be used when animating the tooltip.
-}
type alias XTooltipDistance =
    { distance: Float
    , transformOrigin : XTransformOrigin
    }

calculateXTooltipDistance : XPosition -> ClientRect -> Tooltip -> XTooltipDistance
calculateXTooltipDistance xTooltipPos anchorRect a_tooltip =
    let
        tooltipWidth = a_tooltip.width

        isLTR = True

        startPos =
            if a_tooltip.isRich then
                if isLTR then
                    anchorRect.left - tooltipWidth
                else
                    anchorRect.right
            else
                if isLTR then
                    anchorRect.left
                else
                    anchorRect.right - tooltipWidth

        endPos =
            if a_tooltip.isRich then
                if isLTR then
                    anchorRect.right
                else
                    anchorRect.left - tooltipWidth
            else
                if isLTR then
                    anchorRect.right - tooltipWidth
                else
                    anchorRect.left

        centerPos = anchorRect.left + (anchorRect.width - tooltipWidth) / 2

        startTransformOrigin =
            if a_tooltip.isRich then
                if isLTR then
                    Right
                else
                    Left
            else
                if isLTR then
                    Left
                else
                    Right

        endTransformOrigin =
            if a_tooltip.isRich then
                if isLTR then
                    Left
                else
                    Right
            else
                if isLTR then
                    Right
                else
                    Left

        positionOptions =
            if a_tooltip.isRich then
                determineValidPositionOptions a_tooltip [ startPos, endPos ]
            else
                determineValidPositionOptions a_tooltip [ centerPos, startPos, endPos ]
    in

        if xTooltipPos == XPosition.Start && Set.member startPos positionOptions then
            { distance = startPos, transformOrigin = startTransformOrigin }
        else
            if xTooltipPos == XPosition.End && Set.member endPos positionOptions then
                    { distance = endPos, transformOrigin = endTransformOrigin }
            else
                if xTooltipPos == XPosition.Center && Set.member centerPos positionOptions then
                    -- This code path is only executed if calculating
                    -- the distance for plain tooltips. In this
                    -- instance, centerPos will always be defined.
                    { distance = centerPos, transformOrigin = Center }
                else
                    -- If no user position is supplied, rich tooltips
                    -- default to end pos, then start position. Plain
                    -- tooltips default to center, start, then end.
                    let
                        possiblePositions =
                            if a_tooltip.isRich then
                                [ { distance = endPos, transformOrigin = endTransformOrigin}
                                , { distance = startPos, transformOrigin = startTransformOrigin }
                                ]
                            else
                                [ { distance = centerPos, transformOrigin = Center }
                                , { distance = startPos, transformOrigin = startTransformOrigin }
                                , { distance = endPos, transformOrigin = endTransformOrigin}
                                ]

                        maybe_validPosition =
                            possiblePositions
                                |> List.filter (\{distance} -> Set.member distance positionOptions)
                                |> List.head
                    in
                        case maybe_validPosition of
                            Just validPosition -> validPosition
                            Nothing ->
                                -- Indicates that all potential positions
                                -- would result in the tooltip colliding
                                -- with the viewport. This would only
                                -- occur when the anchor element itself
                                -- collides with the viewport, or the
                                -- viewport is very narrow. In this case,
                                -- we allow the tooltip to be mis-aligned
                                -- from the anchor element.
                                if anchorRect.left < 0 then
                                    { distance = minViewportTooltipThreshold, transformOrigin = Left }
                                else
                                    let
                                        viewportWidth = a_tooltip.viewportWidth
                                        distance = viewportWidth - (tooltipWidth + minViewportTooltipThreshold)
                                    in
                                        { distance = distance, transformOrigin = Right }


{-
Given the values for the horizontal alignments of the tooltip, calculates
which of these options would result in the tooltip maintaining the required
threshold distance vs which would result in the tooltip staying within the
viewport.

A Set of values is returned holding the distances that would honor the
above requirements. Following the logic for determining the tooltip
position, if all alignments violate the threshold, then the returned Set
contains values that keep the tooltip within the viewport.
-}

determineValidPositionOptions : Tooltip -> List Float -> Set Float
determineValidPositionOptions a_tooltip positions =
    let
        posWithinThreshold =
            positions
                |> List.filter (\position -> positionHonorsViewportThreshold a_tooltip position)
                |> Set.fromList

        posWithinViewport =
            positions
                |> List.filter (\position -> not (positionHonorsViewportThreshold a_tooltip position) && positionDoesntCollideWithViewport a_tooltip position)
                |> Set.fromList
    in
        if not ( Set.isEmpty posWithinThreshold ) then
            posWithinThreshold
        else
            posWithinViewport


positionHonorsViewportThreshold : Tooltip -> Float -> Bool
positionHonorsViewportThreshold a_tooltip leftPos =
    let
        viewportWidth = a_tooltip.viewportWidth
        tooltipWidth = a_tooltip.width
    in
        leftPos + tooltipWidth <= viewportWidth - minViewportTooltipThreshold &&
        leftPos >= minViewportTooltipThreshold

positionDoesntCollideWithViewport : Tooltip -> Float -> Bool
positionDoesntCollideWithViewport a_tooltip leftPos =
    let
        viewportWidth = a_tooltip.viewportWidth
        tooltipWidth = a_tooltip.width
    in
        leftPos + tooltipWidth <= viewportWidth && leftPos >= 0



type alias YTooltipDistance =
    { distance : Float
    , transformOrigin : YTransformOrigin
    }

calculateYTooltipDistance : YPosition -> ClientRect -> Tooltip -> YTooltipDistance
calculateYTooltipDistance yTooltipPos anchorRect a_tooltip =
    let
        belowYPos = anchorRect.bottom + anchorGap

        aboveYPos = anchorRect.top - (anchorGap + a_tooltip.height)

        yPositionOptions = determineValidYPositionOptions a_tooltip aboveYPos belowYPos
    in
        if yTooltipPos == YPosition.Above && Set.member aboveYPos yPositionOptions then
            { distance = aboveYPos, transformOrigin = Bottom }
        else
            if yTooltipPos == YPosition.Below && Set.member belowYPos yPositionOptions then
                { distance = belowYPos, transformOrigin = Top }
            else
                if Set.member belowYPos yPositionOptions then
                    { distance = belowYPos, transformOrigin = Top }
                else
                    {- Indicates that all potential positions would
                     result in the tooltip colliding with the
                     viewport. This would only occur when the viewport
                     is very short. -}
                    { distance = belowYPos, transformOrigin = Top }


determineValidYPositionOptions : Tooltip -> Float -> Float -> Set Float
determineValidYPositionOptions a_tooltip aboveAnchorPos belowAnchorPos =
    let
        above_in_viewport = yPositionHonorsViewportThreshold a_tooltip aboveAnchorPos
        below_in_viewport = yPositionHonorsViewportThreshold a_tooltip belowAnchorPos

        posWithinThreshold =
            [ if above_in_viewport then
                  [ aboveAnchorPos ]
              else
                  []
            , if yPositionHonorsViewportThreshold a_tooltip belowAnchorPos then
                  [ belowAnchorPos ]
              else
                  []
            ]
                |> List.concat
                |> Set.fromList

        posWithinViewport =
            [ if not above_in_viewport && yPositionDoesntCollideWithViewport a_tooltip aboveAnchorPos then
                  [ aboveAnchorPos ]
              else
                  []
            , if not below_in_viewport && yPositionDoesntCollideWithViewport a_tooltip belowAnchorPos then
                  [ belowAnchorPos ]
              else
                  []
            ]
                |> List.concat
                |> Set.fromList

    in
        if not ( Set.isEmpty posWithinThreshold ) then
            posWithinThreshold
        else
            posWithinViewport


yPositionHonorsViewportThreshold : Tooltip -> Float -> Bool
yPositionHonorsViewportThreshold a_tooltip yPos =
    yPos + a_tooltip.height + minViewportTooltipThreshold <= a_tooltip.viewportHeight &&
        yPos >= minViewportTooltipThreshold


yPositionDoesntCollideWithViewport : Tooltip -> Float -> Bool
yPositionDoesntCollideWithViewport a_tooltip yPos =
    yPos + a_tooltip.height <= a_tooltip.viewportHeight && yPos >= 0



{-| Attempt to retrieve the dimension of the given element.
-}
getElement : (Msg m -> m) -> String -> (Dom.Element -> Msg m) -> Cmd m
getElement lift id_ msg =
    Task.attempt
        (\result ->
             case result of
                 Ok r -> lift (msg r)
                 Err _ -> lift NoOp)
        (Dom.getElement id_)




type alias Config =
    { show : Bool
    , rich : Bool
    , interactive : Bool
    , persistent : Bool
    }


defaultConfig : Config
defaultConfig =
    { show = False
    , rich = False
    , interactive = False
    , persistent = False
    }


shown : Property m
shown =
    Options.option (\config -> { config | show = True })


rich : Property m
rich =
    Options.option (\config -> { config | rich = True })


interactive : Property m
interactive =
    Options.option (\config -> { config | interactive = True })


persistent : Property m
persistent =
    Options.option (\config -> { config | persistent = True })


content : Property m
content =
    element "content"


contentLink : Property m
contentLink =
    element "content-link"


title : Property m
title =
    element "title"


numbers =
    { boundedAnchorGap = 4
    , unboundedAnchorGap = 8
    , minViewportTooltipThreshold = 8
    , hideDelayMs = 600
    , showDelayMs = 500
    , minHeight = 24
    , maxWiddth = 200
    }


showDelayMs =
    numbers.showDelayMs

hideDelayMs =
    numbers.hideDelayMs

anchorGap =
    numbers.boundedAnchorGap

minViewportTooltipThreshold =
      numbers.minViewportTooltipThreshold


type alias Property m =
    Options.Property Config m



-- VIEW TOOLTIPS


tooltip : Index -> (Msg m -> m) -> Model -> List (Property m) -> List (Html m) -> Html m
tooltip domId lift model options nodes =
    let
        ({ config } as summary) =
            Options.collect defaultConfig options

        show = config.show || model.state == Shown

        hide_ = model.state == Hide

    in
    Options.apply summary
        div
        [ Options.id domId
        , block
        , modifier "rich" |> when config.rich
        , role "tooltip" |> when ( not config.interactive )
        , role "dialog" |> when config.interactive
        , aria "hidden" <| if not show then "true" else "false"
        , aria "tabindex" "-1" |> when config.persistent
        , modifier "showing" |> when ( model.state == Showing )
        , modifier "shown" |> when show
        , modifier "showing-transition" |> when ( show && model.inTransition )
        , modifier "hide" |> when hide_
        , modifier "hide-transition" |> when ( hide_ && model.inTransition )
        , css "transform-origin" "left top" |> when show
        , css "left" (String.fromFloat model.left ++ "px")
        , css "top" (String.fromFloat model.top ++ "px")
        , Options.on "transitionend" (Decode.succeed (lift TransitionEnd))
        ]
        []
        [ styled Html.div
              [ element "surface" ]
              nodes
        ]



-- RICH TOOLTIPS

wrapper : List (Property m) -> List (Html m) -> Html m
wrapper options nodes =
    styled div
        ( cs "mdc-tooltip-wrapper--rich" :: options )
        nodes


actions : List (Property m) -> List (Html m) -> Html m
actions options nodes =
    styled div
        ( element "rich-actions" :: options )
        nodes


button : List (Property m) -> List (Html m) -> Html m
button options nodes =
    styled Html.button
        ( element "action" :: options )
        nodes



-- EXTERNALLY VISIBLE MESSAGES TO CHANGE STATE

{-| Message to hide tooltip.
-}
hide : Index -> Internal.Msg.Msg m
hide tooltip_id =
    Internal.Msg.TooltipMsg tooltip_id StartHide



-- HOOK INTO COMPONENT MODEL

type alias Store s =
    { s | tooltip : Indexed Model }


getSet :
    { get : Index -> { a | tooltip : Indexed Model } -> Model
    , set :
        Index
        -> { a | tooltip : Indexed Model }
        -> Model
        -> { a | tooltip : Indexed Model }
    }
getSet =
    Component.indexed .tooltip (\x y -> { y | tooltip = x }) defaultModel


react :
    (Internal.Msg.Msg m -> m)
    -> Msg m
    -> Index
    -> Store s
    -> ( Maybe (Store s), Cmd m )
react =
    Component.react getSet.get getSet.set Internal.Msg.TooltipMsg update


view :
    (Internal.Msg.Msg m -> m)
    -> Index
    -> Store s
    -> List (Property m)
    -> List (Html m)
    -> Html m
view =
    \lift domId store options ->
        Component.render getSet.get
            (tooltip domId)
            Internal.Msg.TooltipMsg
            lift
            domId
            store
            options


{- Make it easier to work with BEM conventions
-}
block : Property m
block =
    cs blockName

element : String -> Property m
element module_ =
    cs ( blockName ++ "__" ++ module_ )

modifier : String -> Property m
modifier modifier_ =
    cs ( blockName ++ "--" ++ modifier_ )

blockName : String
blockName =
    "mdc-tooltip"
