module App.Data.CsvManager where

import System.IO.Unsafe(unsafeDupablePerformIO)

type Matriz = [[String]]

--Separa uma String em uma lista de Strings, utilizando um Char como separador
splitOn :: Char -> String -> [String]
splitOn d []    = []
splitOn d s     = x : splitOn d (drop 1 y)
    where (x,y) = span (/= d) s

--Separa uma Lista de Strings em uma Matriz, utilizando um Char como separador
splitList :: Char -> [String] -> Matriz
splitList _ []      = []
splitList c (x:[])  = [splitOn c  x]
splitList c (x:xs) = splitOn c  x : splitList c xs

--Converte uma Matriz de Strings para uma única String
matrizToString :: Matriz -> String
matrizToString []       = ""
matrizToString [x]      = concatStrings x ";"
matrizToString (x:xs)   = concatStrings x ";" ++ "\n" ++ matrizToString xs

--Concatena uma lista de Strings, utilizando um conectivo informado
concatStrings :: [String] -> String -> String
concatStrings [] _      = ""
concatStrings [x] _     = x
concatStrings (x:xs) c  = x ++ c ++ ( concatStrings xs c )

--Escreve em um arquivo CSV a partir de seu FilePath, e de uma Matriz de Strings
writeCSV :: FilePath -> Matriz -> IO()
writeCSV path matriz = writeFile path ( matrizToString matriz )

--Le um arquivo CSV, retornando uma Matriz
readCSV :: FilePath -> Matriz
readCSV path = do
    let content = unsafeDupablePerformIO (readFile path)
    splitList ';' (lines content)

--Retorna a linha i de uma Matriz
getRow :: Matriz -> Int -> [String]
getRow mtx i = mtx !! i

