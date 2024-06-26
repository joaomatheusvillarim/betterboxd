module App.Controllers.MovieController where

import Data.List
import Data.Char
import App.Util.SortSearch (msort, searchBy, searchsBy, mostFrequentElement, secondMostFrequentElement, removeFrom)
import App.Models.Movie (Movie, idtM, tittle, rating, genres, year, actors, directors, createMovie, comentarios)
import App.Data.CsvManager ( Matriz, readCSV, writeCSV, appendCSV, editMatriz, editarIndice, editarLinhaCSV)
import App.Util.StringsOp (splitOn, stringToTuples, hGetContents2, concatStrings)
import qualified Data.Maybe
import System.IO

stringToMovie :: [String] -> Movie
stringToMovie [idtM, tittle, rating, genres, year, actors, directors, comentarios] = createMovie idtM tittle (read rating) (stringToList genres) (read year) (stringToList actors) (stringToList directors) (stringToTuples comentarios)

matrizToMovie :: Matriz -> [Movie]
matrizToMovie [x] = [stringToMovie x]
matrizToMovie (x:xs) = stringToMovie x : (matrizToMovie xs)

stringToList :: String -> [String]
stringToList str = (splitOn ',' (init (tail str) ))

getMovies :: Int -> [Movie]
getMovies n = matrizToMovie ( readCSV "./App/Data/Movies.csv" )

getMovieById :: String -> [Movie] -> Maybe Movie
getMovieById str mvies = searchBy idtM mvies str

getMoviesById :: [String] -> [Movie] -> [Movie]
getMoviesById ids mvies = searchsBy idtM mvies ids

getMoviesByGenre :: String -> [Movie] -> [Movie]
getMoviesByGenre _ []      = []
getMoviesByGenre str (x:xs)
    |elem str (genres x)   = x : (getMoviesByGenre str xs)
    |otherwise             = getMoviesByGenre str xs

getBestMoviesByGenre :: String -> Int -> [Movie] -> [Movie]
getBestMoviesByGenre str qnt movies = take qnt $ msort rating (getMoviesByGenre str movies)

getMoviesByTittle :: String -> [Movie] -> [Movie]
getMoviesByTittle _ []                                          = []
getMoviesByTittle str (x:xs)
    | isInfixOf (map toLower str) (map toLower (tittle x))      = x : (getMoviesByTittle str xs)
    | otherwise                                                 = getMoviesByTittle str xs


appendComment :: String -> Int -> String -> Movie -> IO()
appendComment idUser nStars comment mvie = editarLinhaCSV "./App/Data/Movies.csv" (read (idtM mvie) - 1) newLine
    where   updatedComments = "[" ++ commentToString ((idUser, nStars, comment) : (comentarios mvie)) ++ "]"
            newLine = idtM mvie ++ ";" ++ tittle mvie ++ ";" ++ show (rating mvie) ++ ";[" ++ (concatStrings (genres mvie) ",") ++ "];" ++ show (year mvie) ++ ";[" ++ (concatStrings (actors mvie) ",") ++ "]" ++ ";[" ++ (concatStrings (directors mvie) ",") ++ "];" ++ updatedComments


updteComment :: [(String, Int, String)] -> Movie -> IO()
updteComment newComments mvie = editarLinhaCSV "./App/Data/Movies.csv" (read (idtM mvie) - 1) newLine
    where newLine = idtM mvie ++ ";" ++ tittle mvie ++ ";" ++ show (rating mvie) ++ ";[" ++ (concatStrings (genres mvie) ",") ++ "];" ++ show (year mvie) ++ ";[" ++ (concatStrings (actors mvie) ",") ++ "]" ++ ";[" ++ (concatStrings (directors mvie) ",") ++ "];" ++ "[" ++ commentToString (newComments) ++ "]"

editComment :: [(String, Int, String)] -> (String, Int, String) -> [(String, Int, String)]
editComment [] _ = []
editComment ((x, y, z) : xs) (a, b, c)
    | a == x        = (a, b, c) : editComment xs (a,b,c)
    | otherwise     = (x, y, z) : editComment xs (a,b,c)

commentToString :: [(String, Int, String)] -> String
commentToString []              = ""
commentToString [(x, y, z)]     = "(" ++ x ++ "-" ++ show y ++ "-" ++ z ++ ")"
commentToString ((x, y, z):xs)  = "(" ++ x ++ "-" ++ show y ++ "-" ++ z ++ ")" ++ "@" ++ commentToString xs

moviesToIdString :: [Movie] -> String
moviesToIdString []     = ""
moviesToIdString [x]    = idtM x
moviesToIdString (x:xs) = idtM x ++ "," ++ moviesToIdString xs

movieAtIndex :: Int -> [Movie] -> Maybe Movie
movieAtIndex _ [] = Nothing
movieAtIndex index (movie:rest)
    | index == 1 = Just movie
    | otherwise = movieAtIndex (index - 1) rest

showMovies :: [Movie] -> Int -> String
showMovies [] _     = ""
showMovies (x:[]) n = (show n) ++ ". " ++ (tittle x) ++ ", " ++  show (year x)
showMovies (x:xs) n = (show n) ++ ". " ++ (tittle x) ++ ", " ++  show (year x) ++ "\n" ++ showMovies xs (n+1)

searchMovieByID :: String -> Movie
searchMovieByID str = (getMovies 0) !! ((read str) - 1)

searchMovieByTittle :: String -> [Movie]
searchMovieByTittle str = take 10 (getMoviesByTittle str (getMovies 0))

mostFrequentGender :: [Movie] -> String
mostFrequentGender []       = ""
mostFrequentGender mvies    = mostFrequentElement  genres mvies

secondMostFrequentGender :: [Movie] -> String
secondMostFrequentGender []         = ""
secondMostFrequentGender mvies      = secondMostFrequentElement  genres mvies

mostFrequentActor :: [Movie] -> String
mostFrequentActor []    = ""
mostFrequentActor mvies = mostFrequentElement  actors mvies

mostFrequentDirector :: [Movie] -> String
mostFrequentDirector []     = ""
mostFrequentDirector mvies  = mostFrequentElement  directors mvies 

recomendaMovies :: [Movie] -> [Movie] -> [Movie]
recomendaMovies mviesFavoritos mviesAssistidos  = getBestMoviesByGenre segundoGeneroFav 10 (removeFrom idtM indicacaoParcial (mviesFavoritos ++ mviesAssistidos))
    where   generoFavorito      = mostFrequentGender mviesFavoritos
            segundoGeneroFav    = secondMostFrequentGender mviesFavoritos
            indicacaoParcial    = getMoviesByGenre generoFavorito (getMovies 0) 