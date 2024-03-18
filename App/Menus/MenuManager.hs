module App.Menus.MenuManager where

import Control.Concurrent ( threadDelay )
import System.IO ( hFlush, stdout )
import App.Util.PrintUtil( printTxt )
import App.Util.GetInfos( getUsernameCadastro, getPasswordCadastro, getUsernameLogin, getPasswordLogin)

menuInicial :: IO()
menuInicial = do
    printTxt "./App/Menus/MenuInicial.txt"
    putStr "Selecione uma opção: "
    hFlush stdout
    userChoice <- getLine
    optionsMenuInicial userChoice


optionsMenuInicial :: String -> IO()
optionsMenuInicial userChoice 
    | userChoice == "E" || userChoice == "e"    = menuLogin
    | userChoice == "C" || userChoice == "c"    = cadastraUser
    | userChoice == "B" || userChoice == "b"    = print ""
    | userChoice == "S" || userChoice == "s"    = print ""
    | otherwise = do
        putStrLn "\nOpção Inválida!"
        threadDelay 700000
        menuInicial

menuLogin :: IO()
menuLogin = do
    printTxt "./App/Menus/MenuLogin.txt"
    login <- getUsernameLogin
    senha <- getPasswordLogin

    print (login ++ senha)

menuCadastro :: IO()
menuCadastro = do
    printTxt "./App/Menus/MenuLogin.txt"
    username <- getUsernameCadastro
    name <- getNameCadastro
    bio <- getBioCadastro
    password <- getPasswordCadastro
    
    print(username + name +  bio + senha)

