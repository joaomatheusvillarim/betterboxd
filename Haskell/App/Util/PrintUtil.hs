module App.Util.PrintUtil where

import App.Data.CsvManager (readUTF8)
    
-- Exibe no terminal o conteudo de um arquivo .txt a partir de seu FilePath
printTxt :: FilePath -> IO ()
printTxt filePath = do
    putStrLn "\ESC[2J"
    content <- readUTF8 filePath
    putStr content
