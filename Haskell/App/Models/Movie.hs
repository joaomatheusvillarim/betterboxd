module App.Models.Movie where

data Movie = Movie  { idtM :: String
                    , tittle :: String
                    , rating :: Int
                    , genres :: [String]
                    , year :: Int
                    , actors :: [String]
                    , directors :: [String]
                    , comentarios :: [(String, Int, String)]
                    } deriving (Show)


createMovie :: String -> String -> Int -> [String] -> Int -> [String] -> [String] -> [(String, Int, String)] -> Movie
createMovie idt tittle rating genres year actors directors av = Movie  {
                                                                      idtM = idt
                                                                    , tittle = tittle
                                                                    , rating = rating
                                                                    , genres = genres
                                                                    , year = year
                                                                    , actors = actors
                                                                    , directors = directors
                                                                    , comentarios = av
                                                                    }
