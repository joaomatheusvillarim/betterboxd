module App.Betterboxd where

import App.Models.Movie (Movie, idtM, tittle, rating, genres, year, actors, directors,comentarios, createMovie)
import App.Models.User ( User, createUser, idt, user, nome, bio, senha )
import App.Controllers.MovieController (getMovies, getMoviesByGenre, getMoviesByTittle, appendComment)
import App.Controllers.UserController (getUsers, appendUser, getUserLogged, getUserBy, hasUsername, getNextIdt, stringToUser)
import App.Data.CsvManager ( writeCSV )
import qualified Data.Maybe

cadastraUsuario :: String -> String -> String -> String -> IO()
cadastraUsuario nome user bio senha = appendUser [nome, user, bio, senha]

isLoginValid :: String -> String -> Bool
isLoginValid usern psswrd = Data.Maybe.isJust usuarioInformado && (senha (Data.Maybe.fromJust usuarioInformado) == psswrd)
    where usuarioInformado = getUserBy (getUsers 0) user usern

doLogin :: String -> IO()
doLogin userName = do
    let usuario = Data.Maybe.fromJust $ getUserBy (getUsers 0) user userName
    writeCSV "./App/Data/Temp.csv" [[idt usuario]]


searchMovieByTittle :: String -> [Movie]
searchMovieByTittle str = take 10 (getMoviesByTittle str (getMovies 0))

showMovies :: [Movie] -> Int -> String
showMovies [] _     = ""
showMovies (x:[]) n = (show n) ++ ". " ++ (tittle x) ++ ", " ++  show (year x)
showMovies (x:xs) n = (show n) ++ ". " ++ (tittle x) ++ ", " ++  show (year x) ++ "\n" ++ showMovies xs (n+1)

commentMovie :: User -> Int -> String -> Movie -> IO()
commentMovie usr nStar comment mvie = do
    appendComment (idt usr) nStar comment mvie
