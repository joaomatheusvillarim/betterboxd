module App.Data.CsvManager where

import System.IO.Unsafe(unsafeDupablePerformIO)

type Matriz = [[String]]

splitOn :: Eq a => a -> [a] -> [[a]]
splitOn d [] = []
splitOn d s = x : splitOn d (drop 1 y)
    where (x,y) = span (/= d) s

splitList :: Char -> [String] -> Matriz
splitList _ [] = []
splitList c (x:[]) = [splitOn c  x]
splitList c (x:xs) = splitOn c  x : splitList c xs

matrizToString :: Matriz -> String
matrizToString []       = ""
matrizToString [x]      = concatStrings x ";"
matrizToString (x:xs)   = concatStrings x ";" ++ "\n" ++ matrizToString xs

concatStrings :: [String] -> String -> String
concatStrings [] _      = ""
concatStrings [x] _     = x
concatStrings (x:xs) c  = x ++ c ++ ( concatStrings xs c )

writeCSV :: FilePath -> Matriz -> IO()
writeCSV path matriz = writeFile path ( matrizToString matriz )

readCSV :: FilePath -> Matriz
readCSV path = do
    let content = unsafeDupablePerformIO (readFile path)
    splitList ';' (lines content)

getRow :: Matriz -> Int -> [String]
getRow mtx i = mtx !! i

