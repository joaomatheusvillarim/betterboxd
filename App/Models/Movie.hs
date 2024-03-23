module App.Models.Movie where

data Movie = Movie  { idt :: String
                    , tittle :: String
                    , rating :: Int
                    , genres :: [String]
                    , year :: Int
                    , actors :: [String]
                    , directors :: [String]
                    } deriving (Show)


createMovie :: String -> String -> Int -> [String] -> Int -> [String] -> [String] -> Movie
createMovie idt tittle rating genres year actors directors = Movie  {
                                                                      idt = idt
                                                                    , tittle = tittle
                                                                    , rating = rating
                                                                    , genres = genres
                                                                    , year = year
                                                                    , actors = actors
                                                                    , directors = directors
                                                                    }
