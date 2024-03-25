module App.Data.CsvManager where

import App.Util.StringsOp( concatStrings, splitList )
import Control.Exception
import System.IO.Unsafe( unsafeDupablePerformIO )
import System.Environment
import System.IO

type Matriz = [[String]]

--Converte uma Matriz de Strings para uma única String
matrizToString :: Matriz -> String
matrizToString []       = ""
matrizToString [x]      = concatStrings x ";"
matrizToString (x:xs)   = concatStrings x ";" ++ "\n" ++ matrizToString xs

--Escreve em um arquivo CSV a partir de seu FilePath, e de uma Matriz de Strings
writeCSV :: FilePath -> Matriz -> IO()
writeCSV path matriz = writeFile path ( matrizToString matriz )

--Le um arquivo CSV, retornando uma Matriz
readCSV :: FilePath -> Matriz
readCSV path = do
    let content = unsafeDupablePerformIO (readUTF8 path)
    splitList ';' (lines content)

{- readUTF8 :: FilePath -> IO String
readUTF8 path = do
    handle <- openFile path ReadMode
    hSetEncoding handle utf8
    hGetContents handle -}

readUTF8 :: FilePath -> IO String
readUTF8 path = bracket
    (openFile path ReadMode)
    (\handle -> hClose handle)
    (\handle -> do
        hSetEncoding handle utf8
        contents <- hGetContents handle
        evaluate (length contents)  -- Avalia todo o conteúdo
        return contents
    )


--Adiciona uma nova Linha a um arquivo CSV
appendCSV :: FilePath -> [String] -> IO()
appendCSV path str = appendFile path ("\n" ++ newStr)
    where newStr = concatStrings str ";"

--Retorna a linha i de uma Matriz
getRow :: Matriz -> Int -> [String]
getRow mtx i = mtx !! i

--Edita uma linha especifica de uma Matriz
editMatriz :: Matriz -> Int -> [String] -> Matriz
editMatriz mat n newValue = x ++ [newValue] ++ ts
    where   (x, y)  = splitAt n mat
            ts      = tail y

editarIndice :: [String] -> Int -> String -> [String]
editarIndice [] _ _ = []
editarIndice (x:xs) indice novoConteudo
    | indice == 0 = novoConteudo : xs
    | otherwise = x : editarIndice xs (indice - 1) novoConteudo