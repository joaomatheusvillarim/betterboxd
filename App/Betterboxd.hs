module App.Betterboxd where

import App.Models.Movie (Movie, idtM, tittle, rating, genres, year, actors, directors,comentarios, createMovie)
import App.Models.User ( User, createUser, idt, user, nome, bio, senha, listas )
import App.Util.StringsOp (concatStrings)
import App.Controllers.ListaController (createListaData, exibeListas, getLastLista)
import App.Controllers.MovieController (getMovies, getMoviesByGenre, getMoviesByTittle, appendComment, updteComment, editComment)
import App.Controllers.UserController (getUsers, appendUser, getUserLogged, getUserBy, hasUsername, getNextIdt, stringToUser, editUser, appendListaToUser)
import App.Data.CsvManager ( writeCSV )
import qualified Data.Maybe
import System.IO
import App.Models.Lista (Lista)

cadastraUsuario :: String -> String -> String -> String -> IO()
cadastraUsuario nome user bio senha = do
    createListaData ("Favoritos de " ++ nome)
    createListaData ("Filmes Loggados de " ++ nome)
    createListaData ("Recomendados para " ++ nome)
    appendUser [user, nome, bio, senha]

isLoginValid :: String -> String -> Bool
isLoginValid usern psswrd = Data.Maybe.isJust usuarioInformado && (senha (Data.Maybe.fromJust usuarioInformado) == psswrd)
    where usuarioInformado = getUserBy (getUsers 0) user usern

doLogin :: String -> IO()
doLogin userName = do
    let usuario = Data.Maybe.fromJust $ getUserBy (getUsers 0) user userName
    writeCSV "./App/Data/Temp.csv" [[idt usuario]]

searchMovieByID :: String -> Movie
searchMovieByID str = (getMovies 0) !! ((read str) - 1)

searchMovieByTittle :: String -> [Movie]
searchMovieByTittle str = take 10 (getMoviesByTittle str (getMovies 0))

showMovies :: [Movie] -> Int -> String
showMovies [] _     = ""
showMovies (x:[]) n = (show n) ++ ". " ++ (tittle x) ++ ", " ++  show (year x)
showMovies (x:xs) n = (show n) ++ ". " ++ (tittle x) ++ ", " ++  show (year x) ++ "\n" ++ showMovies xs (n+1)

commentMovie :: User -> Int -> String -> Movie -> IO()
commentMovie usr nStar comment mvie = do
    appendComment (idt usr) nStar comment mvie

changeComment :: Movie -> (String, Int, String) -> IO()
changeComment mvie (a, b, c) = updteComment novosComment mvie
    where novosComment = editComment (comentarios mvie) (a,b,c)

-- pega a lista de filmes e pega do index do
movieAtIndex :: Int -> [Movie] -> Maybe Movie
movieAtIndex _ [] = Nothing
movieAtIndex index (movie:rest)
    | index == 1 = Just movie
    | otherwise = movieAtIndex (index - 1) rest

printMovieInfo :: Movie -> IO ()
printMovieInfo movie = do
    putStrLn "\ESC[2J"
    putStrLn $ replicate 80 '*'
    putStrLn ""
    putStrLn $ replicate 30 ' ' ++ "Informações do Filme"
    putStrLn ""
    putStrLn $ replicate 80 '*'
    putStrLn $ " Título:        " ++ tittle movie
    putStrLn $ " Rating:        " ++ show (rating movie)
    putStrLn $ " Ano:           " ++ show (year movie)
    putStrLn $ " Atores:        " ++ concatStrings (actors movie) ", "
    putStrLn $ " Diretor:       " ++ concatStrings (directors movie) ", "
    putStrLn $ replicate 80 '*'
    putStrLn " Comentários:"
    if null (comentarios movie)
        then putStrLn "  - Nenhum comentário disponível."
        else mapM_ (\(usuario, avaliacao, comentario) ->
                putStrLn $ " " ++ nome (Data.Maybe.fromJust (getUserBy (getUsers 0) idt usuario)) ++ " - " ++ stars avaliacao ++ " " ++ comentario)
              (comentarios movie)
    putStrLn $ replicate 80 '*'
    where
        stars :: Int -> String
        stars n = replicate n '*' ++ replicate (5 - n) '°'

verificaComentUnico :: String -> [(String, Int, String)] -> Bool
verificaComentUnico _ []            = True
verificaComentUnico str [(x, y, z)] = str /= x
verificaComentUnico str ((x, y, z):xs)
    | str == x      = False
    | otherwise     = verificaComentUnico str xs

exibePerfil :: User -> String
exibePerfil usr = do
    "\n" ++ replicate 41 '=' ++ "\n" ++ "            Perfil de Usuário          " ++ "\n"
    ++ replicate 41 '=' ++ "\nNome:     " ++ nome usr
    ++ "\n" ++ "Username: " ++ user usr
    ++ "\n" ++ "Bio:      " ++ bio usr
    ++ "\n" ++ replicate 41 '-' 
    ++ "\n" ++ "             Listas de Filmes"
    ++ "\n" ++ replicate 41 '-' ++ "\n" ++ exibeListas (listas usr) 1
    ++ "\n" ++ replicate 41 '-'

criaLista :: String -> User -> IO()
criaLista str usr = do
    createListaData str
    appendListaToUser (getLastLista 0) usr
