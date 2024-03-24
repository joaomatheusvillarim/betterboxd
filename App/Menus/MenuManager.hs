module App.Menus.MenuManager where

import Control.Concurrent ( threadDelay )
import System.IO ( hFlush, stdout )
import App.Util.PrintUtil( printTxt )
import App.Util.GetInfos( getUsernameCadastro, getPasswordCadastro, getUsernameLogin, getPasswordLogin, getNameCadastro, getBioCadastro)
import App.Betterboxd ( cadastraUsuario, isLoginValid, doLogin, searchMovieByTittle , showMovies)

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
    | userChoice == "C" || userChoice == "c"    = menuCadastro
    | userChoice == "B" || userChoice == "b"    = menuBusca1
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

    if isLoginValid login senha then do
        doLogin login
        menuPrincipal
    
    else do
        putStrLn "\nLogin Inválido!"
        threadDelay 700000
        menuInicial

menuCadastro :: IO()
menuCadastro = do
    printTxt "./App/Menus/MenuLogin.txt"
    user <- getUsernameCadastro
    nome <- getNameCadastro
    bio <- getBioCadastro
    senha <- getPasswordCadastro

    cadastraUsuario nome user bio senha

menuPrincipal :: IO()
menuPrincipal = do
    printTxt "./App/Menus/MenuPrincipal.txt"
    putStr "Selecione uma opção: "
    hFlush stdout
    userChoice <- getLine
    optionsMenuPrincipal userChoice

optionsMenuPrincipal :: String -> IO()
optionsMenuPrincipal userChoice
    | userChoice == "V" || userChoice == "v"    = print ""
    | userChoice == "B" || userChoice == "b"    = menuBusca1
    | userChoice == "R" || userChoice == "r"    = print ""
    | userChoice == "S" || userChoice == "s"    = print ""
    | otherwise = do
        putStrLn "\nOpção Inválida!"
        threadDelay 700000
        menuPrincipal

menuBusca1 :: IO()
menuBusca1 = do
    printTxt "./App/Menus/MenuBusca/MenuBusca1.txt"
    putStr "Selecione uma opção: "
    hFlush stdout
    userChoice <- getLine
    optionsMenuBusca1 userChoice

optionsMenuBusca1 :: String -> IO()
optionsMenuBusca1 userChoice
    | userChoice == "F" || userChoice == "f"    = menuBuscaFilme1
    | userChoice == "L" || userChoice == "l"    = print ""
    | userChoice == "P" || userChoice == "p"    = print ""
    | userChoice == "S" || userChoice == "s"    = print ""
    | otherwise = do
        putStrLn "\nOpção Inválida!"
        threadDelay 700000
        menuBusca1


menuBuscaFilme1 :: IO()
menuBuscaFilme1 = do
    printTxt "./App/Menus/MenuBusca/MenuBuscaFilme.txt"
    hFlush stdout
    userChoice <- getLine
    menuBuscaFilme2 userChoice

menuBuscaFilme2 :: String -> IO()
menuBuscaFilme2 str = do
    let filmes = showMovies (searchMovieByTittle str) 1
    printTxt "./App/Menus/MenuBusca/MenuBuscaFilme2.txt"
    putStrLn filmes
    putStr "\nId: "
    userChoice <- getLine
    --JOIN FILME
    putStrLn userChoice
