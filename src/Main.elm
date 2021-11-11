-- Show the current time in your time zone.
--
-- Read how it works:
--   https://guide.elm-lang.org/effects/time.html
--
-- For an analog clock, check out this SVG example:
--   https://elm-lang.org/examples/clock
--
module Main exposing (..)

import Browser

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Task
import Time

-- MAIN


main =
  Browser.element
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Model =
  { zone : Time.Zone
  , time : Time.Posix
  }


init : () -> (Model, Cmd Msg)
init _ =
  ( Model Time.utc (Time.millisToPosix 0)
  , Task.perform AdjustTimeZone Time.here
  )



-- UPDATE

flag : String -> String
flag doing =
  doing

type Msg
  = Tick Time.Posix
  | AdjustTimeZone Time.Zone
  | Pause



update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Pause ->
      let
        a = Time.millisToPosix 0
      in
      ( { model | time = a }
      , Cmd.none
      )
    Tick newTime ->
      ( { model | time = newTime }
      , Cmd.none
      )

    AdjustTimeZone newZone ->
      ( { model | zone = newZone }
      , Cmd.none
      )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model
  = Time.every 1000 Tick


-- VIEW


view : Model -> Html Msg
view model =
  let
    hour   = String.fromInt (Time.toHour   model.zone model.time)
    minute = String.fromInt (Time.toMinute model.zone model.time)
    second = String.fromInt (Time.toSecond model.zone model.time)
  in
  div []
    [
      h1 [ Html.Attributes.style "color" "red" ] [ Html.text (hour ++ ":" ++ minute ++ ":" ++ second) ]
      , button [ onClick Pause ] [ Html.text("stop") ]
    ]


-- view model =
--   svg
--     [ Svg.Attributes.width "120"
--     , Svg.Attributes.height "120"
--     , viewBox "0 0 120 120"
--     ]
--     [ circle
--         [ cx "50"
--         , cy "50"
--         , r "50"
--         , Svg.Attributes.color "#93C54B"
--         ]
--         []
--         ,line
--         [x1 "50", y1 "50", x2 "50", y2 "50", stroke "#2a2a2a", strokeWidth "0.5"
--         ]
--         []
--         ,line
--         [x1 "10", y1 "10", x2 "10", y2 "10", stroke "#2a2a2a", strokeWidth "0.5"]
--         []
--   ]
