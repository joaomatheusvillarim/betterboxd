module App.Util.StringsOp where
import System.IO

--Concatena uma lista de Strings, utilizando um conectivo informado
concatStrings :: [String] -> String -> String
concatStrings [] _      = ""
concatStrings [x] _     = x
concatStrings (x:xs) c  = x ++ c ++ ( concatStrings xs c )

--Separa uma String em uma lista de Strings, utilizando um Char como separador
splitOn :: Char -> String -> [String]
splitOn _ []    = []
splitOn d s     = x : splitOn d (drop 1 y)
    where (x,y) = span (/= d) s

--Separa uma Lista de Strings em uma Matriz, utilizando um Char como separador
splitList :: Char -> [String] -> [[String]]
splitList _ []      = []
splitList c (x:[])  = [splitOn c  x]
splitList c (x:xs) = splitOn c  x : splitList c xs

hGetContents2 :: Handle -> IO String
hGetContents2 h = do
  eof <- hIsEOF h
  if eof
    then
      return []
    else do
      c <- hGetChar h
      fmap (c:) $ hGetContents2 h