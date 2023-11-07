module Backend exposing (..)

import Bridge exposing (..)
import Effect.Command as Command exposing (Command)
import Effect.Lamdera exposing (ClientId, SessionId)
import Html
import Types exposing (BackendModel, BackendMsg(..), ToFrontend(..))


type alias Model =
    BackendModel


app =
    Effect.Lamdera.backend
        { init = init
        , update = update
        , updateFromFrontend = updateFromFrontend
        , subscriptions = \m -> Effect.Lamdera.onConnect OnConnect
        }


init : ( Model, Command restriction toMsg BackendMsg )
init =
    ( { smashedLikes = 0 }
    , Command.none
    )


update : BackendMsg -> Model -> ( Model, Command restriction toMsg BackendMsg )
update msg model =
    case msg of
        OnConnect sid cid ->
            ( model, Effect.Lamdera.sendToFrontend cid <| NewSmashedLikes model.smashedLikes )


updateFromFrontend : SessionId -> ClientId -> ToBackend -> Model -> ( Model, Command restriction toMsg BackendMsg )
updateFromFrontend sessionId clientId msg model =
    case msg of
        SmashedLikeButton ->
            let
                newSmashedLikes =
                    model.smashedLikes + 1
            in
            ( { model | smashedLikes = newSmashedLikes }, Effect.Lamdera.broadcast <| NewSmashedLikes newSmashedLikes )
