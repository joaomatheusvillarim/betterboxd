module App.Models.Lista where

import App.Models.Movie (Movie)

data Lista = Lista  { idtL :: String
                    , nomeLista :: String
                    , filmes :: [Movie]
                    } deriving (Show)


createLista ::  String -> String -> [Movie] -> Lista
createLista idtf str mvies = Lista   {
                                  idtL = idtf
                                , nomeLista = str
                                , filmes = mvies
                                }
