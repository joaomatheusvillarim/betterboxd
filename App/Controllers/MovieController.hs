module App.Controllers.MovieController where

import Data.List
import Data.Char
import App.Models.Movie (Movie, idt, tittle, rating, genres, year, actors, directors, createMovie)
import App.Data.CsvManager ( Matriz, readCSV, writeCSV, appendCSV, editMatriz)
import App.Util.StringsOp (splitOn)

merge :: [Movie] -> [Movie] -> [Movie]
merge [] ys         = ys
merge xs []         = xs
merge (x:xs) (y:ys) 
    | (rating x) > (rating y)       = x:merge xs (y:ys)
    | otherwise                     = y:merge (x:xs) ys

halve :: [Movie] -> ([Movie],[Movie])
halve xs = (take metade xs, drop metade xs)
           where metade = length xs `div` 2

msort :: [Movie] -> [Movie]
msort []  = []
msort [x] = [x]
msort  xs = merge (msort left) (msort right)
            where (left,right) = halve xs

stringToMovie :: [String] -> Movie
stringToMovie [idt, tittle, rating, genres, year, actors, directors] = createMovie idt tittle (read rating) (stringToList genres) (read year) (stringToList actors) (stringToList directors)

matrizToMovie :: Matriz -> [Movie]
matrizToMovie (x:[]) = [stringToMovie x]
matrizToMovie (x:xs) = stringToMovie x : (matrizToMovie xs)

stringToList :: String -> [String]
stringToList str = (splitOn ',' (init (tail str) ))

getMovies :: Int -> [Movie]
getMovies n = matrizToMovie ( readCSV "./App/Data/Movies.csv" )

{- 'Comedy', 'Drama', 'Romance', 'Sci-Fi', 'Horror', 'Documentary', 'Biography', 'History', 'Adventure', 'Action', 'Fantasy', 'Crime',
 'Kids & Family', 'Animation', 'LGBTQ+', 'Musical', 'War', 'Mystery & Thriller', 'Music', 'Holiday', 'Western', 'Sports', 'Anime' -}
 
getMoviesByGenre :: String -> [Movie] -> [Movie]
getMoviesByGenre _ []      = []
getMoviesByGenre str (x:[])
    |elem str (genres x)   = [x]
    |otherwise             = []
getMoviesByGenre str (x:xs)
    |elem str (genres x)   = x : (getMoviesByGenre str xs)
    |otherwise             = getMoviesByGenre str xs

getBestMoviesByGenre :: String -> Int -> [Movie] -> [Movie]
getBestMoviesByGenre str qnt movies = take qnt $ msort (getMoviesByGenre str movies)

getMoviesByTittle :: String -> [Movie] -> [Movie]
getMoviesByTittle _ []          = []
getMoviesByTittle str (x:[])
    | isInfixOf (map toLower str) (map toLower (tittle x))      = [x]
    | otherwise                                                 = []
getMoviesByTittle str (x:xs)
    | isInfixOf (map toLower str) (map toLower (tittle x))      = x : (getMoviesByTittle str xs)
    | otherwise                                                 = getMoviesByTittle str xs