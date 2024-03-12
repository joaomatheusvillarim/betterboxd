module App.Models.Movie where

import qualified Data.Map as Map
import System.IO

type Username = String
type MovieDatabase = [Movie]
type UserMovies = [Movie]
type UserProfile = Map.Map Username UserMovies

defaultFilePath = "App/data/movies.csv"

data Movie = Movie  { movieName :: String
                    , director :: String
                    , duration :: Int
                    , genre :: String
                    , rating :: Double
                    } deriving (Show)


createMovie :: Username -> String -> String -> Int -> String -> Double -> IO ()
createMovie username movieName director duration genre rating = do
    let newMovie = Movie movieName director duration genre rating
    appendFile defaultFilePath (movieToCSV username newMovie ++ "\n")

--a chamada da função fica saveMovies movies



saveMovieToUser :: Username -> Movie -> IO ()
saveMovieToUser username movie = do
    appendFile defaultFilePath (movieToCSV username movie ++ "\n")


movieToCSV :: Username -> Movie -> String
movieToCSV username (Movie name director duration genre rating) =
    username ++ "," ++ name ++ "," ++ director ++ "," ++ show duration ++ "," ++ genre ++ "," ++ show rating

