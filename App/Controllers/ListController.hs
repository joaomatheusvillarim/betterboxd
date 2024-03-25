module App.Controllers.ListController where

import App.Models.Movie (Movie)
import App.Data.CsvManager (Matriz, readCSV, writeCSV, appendCSV, editMatriz)
import App.Util.StringsOp (splitOn)

data MovieList = MovieList { listName :: String, movies :: [Movie] }

addToMovieList :: MovieList -> Movie -> MovieList
addToMovieList list movie = list { movies = movie : movies list }

removeFromMovieList :: MovieList -> Movie -> MovieList
removeFromMovieList list movie = list { movies = filter (/= movie) (movies list) }

createMovieList :: String -> [Movie] -> MovieList
createMovieList name movies = MovieList { listName = name, movies = movies }

getMoviesFromList :: MovieList -> [Movie]
getMoviesFromList list = movies list

createMovieList :: String -> [Movie] -> MovieList
createMovieList name movies = MovieList { listName = name, movies = movies }

favoritesList :: MovieList
favoritesList = MovieList { listName = "Favorites", movies = [] }

saveMovieList :: MovieList -> IO ()
saveMovieList list = appendCSV "./App/Data/Lists.csv" [listName list, show (map idtM (movies list))]

loadMovieLists :: IO [MovieList]
loadMovieLists = do
    csvData <- readCSV "./App/Data/Lists.csv"
    return $ map (\[name, ids] -> createMovieList name (map (\id -> getMovieById id allMovies) (splitOn ',' ids))) csvData

getMovieById :: Int -> [Movie] -> Movie
getMovieById id movies = head [movie | movie <- movies, idtM movie == id]

allMovies :: IO [Movie]
allMovies = do
    csvData <- readCSV "./App/Data/Movies.csv"
    return $ matrizToMovie csvData

matrizToMovie :: Matriz -> [Movie]
matrizToMovie = map stringToMovie

stringToMovie :: [String] -> Movie
stringToMovie [idtM, tittle, rating, genres, year, actors, directors, comentarios] = createMovie idtM tittle (read rating) (stringToList genres) (read year) (stringToList actors) (stringToList directors) (stringToTuples comentarios)

stringToList :: String -> [String]
stringToList str = splitOn ',' (init (tail str))

stringToTuples :: String -> [(String, String)]
stringToTuples str = map (\[a, b] -> (a, b)) (map (splitOn ':') (splitOn ',' str))
