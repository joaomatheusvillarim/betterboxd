module App.Util.PrintUtil where
    
-- Exibe no terminal o conteudo de um arquivo .txt a partir de seu FilePath
printTxt :: FilePath -> IO ()
printTxt filePath = do
    putStrLn "\ESC[2J"
    content <- readFile filePath
    putStr content
