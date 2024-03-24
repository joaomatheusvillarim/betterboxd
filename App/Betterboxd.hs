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

-- pega a lista de filmes e pega do index do
movieAtIndex :: Int -> [Movie] -> Maybe Movie
movieAtIndex _ [] = Nothing
movieAtIndex index (movie:rest)
    | index == 1 = Just movie
    | otherwise = movieAtIndex (index - 1) rest
--
printMovieInfo :: Movie -> IO ()
printMovieInfo movie = do
    putStrLn $ replicate 80 '*'
    putStrLn ""
    putStrLn $ replicate 30 ' ' ++ "Informações do Filme"
    putStrLn ""
    putStrLn $ replicate 80 '*'
    putStrLn $ " Título:        " ++ tittle movie
    putStrLn $ " Rating:        " ++ show (rating movie)
    putStrLn $ " Ano:           " ++ show (year movie)
    putStrLn $ " Atores:        " ++ unwords (actors movie)
    putStrLn $ " Diretor:       " ++ unwords (directors movie)
    putStrLn $ replicate 80 '*'
    putStrLn " Comentários:"
    putStrLn $ replicate 80 '*'
    if null (comentarios movie)
        then putStrLn "  - Nenhum comentário disponível."
        else mapM_ (\(usuario, avaliacao, comentario) ->
                putStrLn $ " " ++ usuario ++ " - " ++ stars avaliacao ++ " " ++ comentario)
              (comentarios movie)
    putStrLn $ replicate 80 '*'
    where
        stars :: Int -> String
        stars n = replicate n '★' ++ replicate (5 - n) '☆'

