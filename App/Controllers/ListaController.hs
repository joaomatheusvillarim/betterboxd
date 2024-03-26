module App.Controllers.ListaController where

import App.Models.Movie (Movie, idtM)
import App.Models.Lista(Lista, idtL, nomeLista, filmes, createLista)
import App.Controllers.MovieController(getMoviesById, getMovies, moviesToIdString)
import App.Data.CsvManager (Matriz, readCSV, writeCSV, appendCSV, editMatriz, editarIndice, appendLinhaCSV, editarLinhaCSV)
import App.Util.StringsOp (splitOn, hGetContents2, concatStrings)
import App.Models.Lista(Lista, idtL, nomeLista, filmes, createLista)
import App.Util.SortSearch (searchBy, searchsBy)
import System.IO

stringToLista :: [String] -> Lista
stringToLista [id, nome]            = createLista id nome []
stringToLista [id, nome, filmes]    = createLista id nome (getMoviesById (splitOn ',' filmes) (getMovies 0))

listaToString :: Lista -> String
listaToString l = idtL l ++ ";" ++ nomeLista l ++ ";" ++ moviesToIdString (filmes l)

matrizToLista :: [[String]] -> [Lista]
matrizToLista [x]       = [stringToLista x]
matrizToLista (x:xs)    = stringToLista x : (matrizToLista xs)

getListas :: Int -> [Lista]
getListas n = matrizToLista ( readCSV "./App/Data/Listas.csv" )

createListaData :: String -> IO()
createListaData nome = appendLinhaCSV "./App/Data/Listas.csv" (nome ++ ";")

appendMovieToLista :: Lista -> Movie -> IO()
appendMovieToLista lista movie = editarLinhaCSV "./App/Data/Listas.csv" (read (idtL lista)) newLinha
    where newLinha = (listaToString lista) ++ "," ++ (idtM movie)

getListaById :: String -> [Lista] -> Maybe Lista
getListaById str listas = searchBy idtL listas str

getListasById :: [String] -> [Lista] -> [Lista]
getListasById str listas = searchsBy idtL listas str

listasToIdL :: [Lista] -> String
listasToIdL []      = ""
listasToIdL [x]     = idtL x
listasToIdL (x:xs)  = idtL x ++ ","

getLastId :: Int -> String
getLastId n = idtL (last (getListas 0))

exibeListas :: [Lista] -> Int -> String
exibeListas [] _        = ""
exibeListas [x] n       = (show n) ++ ". " ++ nomeLista x 
exibeListas (x:xs) n    = (show n) ++ ". " ++ nomeLista x ++ "\n" ++ exibeListas xs (n + 1)