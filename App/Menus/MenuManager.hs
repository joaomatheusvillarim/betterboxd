module App.Menus.MenuManager where

import Control.Concurrent ( threadDelay )
import System.IO ( hFlush, stdout )
import App.Controllers.UserController (getUserLogged, getUserBy, getUsers, editUser)
import App.Util.PrintUtil( printTxt )
import App.Util.GetInfos( getUsernameCadastro, getPasswordCadastro, getUsernameLogin, getPasswordLogin, getNameCadastro, getBioCadastro, getNumberStars, getComentario)
import App.Models.Movie (Movie, idtM, comentarios)
import App.Models.User (User, idt, nome, user, bio, senha, listas, createUser)
import App.Betterboxd ( cadastraUsuario, isLoginValid, doLogin, searchMovieByTittle , showMovies, movieAtIndex, printMovieInfo, commentMovie, searchMovieByID, verificaComentUnico, changeComment, exibePerfil, criaLista)
import qualified Data.Maybe
import App.Models.Lista (Lista (idtL, filmes))
import App.Controllers.ListaController (exibeLista, appendMovieToLista, getListas, getListaById, removeMovieFromLista, editLista)

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
    | userChoice == "S" || userChoice == "s"    = putStrLn ""
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
    menuInicial

menuPrincipal :: IO()
menuPrincipal = do
    printTxt "./App/Menus/MenuPrincipal.txt"
    putStr "Selecione uma opção: "
    hFlush stdout
    userChoice <- getLine
    optionsMenuPrincipal userChoice

optionsMenuPrincipal :: String -> IO()
optionsMenuPrincipal userChoice
    | userChoice == "V" || userChoice == "v"    = menuPerfil (getUserLogged 0)
    | userChoice == "B" || userChoice == "b"    = menuBusca1
    | userChoice == "R" || userChoice == "r"    = print ""
    | userChoice == "S" || userChoice == "s"    = putStrLn ""
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
    | userChoice == "P" || userChoice == "p"    = print ""
    | userChoice == "V" || userChoice == "v"    = menuPrincipal
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
    let movies = searchMovieByTittle str

    if (length movies < 1) then do
        putStrLn "\nNenhum retorno válido"
        threadDelay 700000
        menuBuscaFilme1

    else do
        let filmesSTR = showMovies movies 1
        printTxt "./App/Menus/MenuBusca/MenuBuscaFilme2.txt"
        putStrLn filmesSTR
        putStr "\nId: "
        hFlush stdout
        userChoice <- getLine
        if ((read userChoice) < 1 || (read userChoice) > length movies) then do
            putStrLn "\nIndex inválido"
            threadDelay 700000
            menuBuscaFilme2 str

        else do
            printMovieInfo (movies !! ((read userChoice) -1))
            menuFilme (movies !! ((read userChoice) -1))

menuFilme :: Movie -> IO()
menuFilme mvie = do
    putStrLn ("(C)OMENTAR e avaliar filme\n" ++ "(A)LTERAR comentário\n" ++ "(V)OLTAR ao menu principal\n" )
    putStr "Selecione uma opção: "
    hFlush stdout
    userChoice <- getLine
    optionsMenuFilme userChoice mvie

optionsMenuFilme :: String -> Movie -> IO()
optionsMenuFilme userChoice mvie
    | userChoice == "C" || userChoice == "c"    = menuComentario mvie
    | userChoice == "A" || userChoice == "a"    = menuComentarioChange mvie
    | userChoice == "V" || userChoice == "v"    = menuPrincipal
    | otherwise = do
        putStrLn "\nOpção Inválida!"
        threadDelay 700000
        printMovieInfo mvie
        menuFilme mvie

menuComentario :: Movie -> IO()
menuComentario mvie = do
    if verificaComentUnico (idt userLogged) (comentarios mvie) then do
        nStars <- getNumberStars
        coment <- getComentario
        commentMovie userLogged nStars coment mvie
        printMovieInfo (searchMovieByID (idtM mvie))
        menuFilme (searchMovieByID (idtM mvie))
    else do
        putStrLn "\nVocê já avaliou este filme!"
        threadDelay 1400000
        printMovieInfo mvie
        menuFilme mvie
    where userLogged = getUserLogged 0

menuComentarioChange :: Movie -> IO()
menuComentarioChange mvie = do
    if verificaComentUnico (idt userLogged) (comentarios mvie) then do
        putStrLn "\nVocê ainda não avaliou este filme!"
        threadDelay 1400000
        printMovieInfo mvie
        menuFilme mvie

    else do
        nStars <- getNumberStars
        coment <- getComentario
        changeComment mvie (idt userLogged, nStars, coment)
        printMovieInfo (searchMovieByID (idtM mvie))
        menuFilme (searchMovieByID (idtM mvie))
    where userLogged = getUserLogged 0

menuPerfil :: User -> IO()
menuPerfil usr = do
    printTxt "./App/Menus/logo.txt"
    putStrLn (exibePerfil usr)
    putStrLn ""
    putStrLn "(A)DICIONAR Lista"
    putStrLn "(S)ELECIONAR Lista"
    putStrLn "(E)DITAR Dados"
    putStrLn "(V)OLTAR"
    putStrLn "\nSelecione uma opção: "
    hFlush stdout
    userChoice <- getLine
    menuPerfilOptions usr userChoice

menuPerfilOptions :: User -> String -> IO()
menuPerfilOptions usr userChoice
    | userChoice == "A" || userChoice == "a"    = menuCriacaoLista usr
    | userChoice == "S" || userChoice == "s"    = menuSelecaoLista usr
    | userChoice == "E" || userChoice == "e"    = menuEdicaoUsuario usr
    | userChoice == "V" || userChoice == "v"    = menuPrincipal
    | otherwise = do
        putStrLn "\nOpção Inválida!"
        threadDelay 700000
        menuPerfil usr

menuCriacaoLista :: User -> IO()
menuCriacaoLista usr = do
    printTxt "./App/Menus/MenuPerfil/CriacaoLista.txt"
    nome <- getLine
    criaLista nome usr
    menuPerfil (Data.Maybe.fromJust(getUserBy (getUsers 0) idt (idt usr)))

menuSelecaoLista :: User -> IO()
menuSelecaoLista usr = do
    let lists = listas usr
    putStrLn "\nId: "
    userChoice <- getLine
    
    if(length lists) < 1 then do
        putStrLn "\nVoce não tem nenhuma lista."
        threadDelay 1400000
        menuPerfil usr

    else do 
        if (length lists) < (read userChoice) || (read userChoice) < 1  then do
            putStrLn "\nERROR: ID inválido"
            threadDelay 1400000
            menuPerfil usr
        else do
            menuSelecaoLista2 usr (lists !! (read userChoice -1)) 



menuSelecaoLista2 :: User -> Lista -> IO()
menuSelecaoLista2 usr lista = do
    printTxt "./App/Menus/logo.txt"
    putStrLn (exibeLista lista)
    putStrLn (replicate 40 '=')
    putStrLn "(A)DICIONAR Filme"
    putStrLn "(S)ELECIONAR Filme"
    putStrLn "(R)EMOVER Filme"
    putStrLn "(V)OLTAR"
    putStrLn "\nSelecione uma opção: "
    hFlush stdout
    userChoice <- getLine
    menuSelecaoLista2Options usr lista userChoice


menuSelecaoLista2Options :: User -> Lista -> String -> IO()
menuSelecaoLista2Options usr lista userChoice
    | userChoice == "A" || userChoice == "a"    = menuBuscaFilmeLista usr lista
    | userChoice == "S" || userChoice == "s"    = menuSelecionaFilme usr lista
    | userChoice == "R" || userChoice == "r"    = menuRemoveFilmeLista usr lista
    | userChoice == "V" || userChoice == "v"    = menuPrincipal
    | otherwise = do
        putStrLn "\nOpção Inválida!"
        threadDelay 700000
        menuSelecaoLista2 usr lista

menuBuscaFilmeLista ::User -> Lista -> IO()
menuBuscaFilmeLista usr lista = do
    printTxt "./App/Menus/MenuBusca/MenuBuscaFilme.txt"
    hFlush stdout
    userChoice <- getLine
    menuBuscaFilme2Lista usr lista userChoice

menuBuscaFilme2Lista ::User -> Lista -> String -> IO()
menuBuscaFilme2Lista usr lista str = do
    let movies = searchMovieByTittle str

    if (length movies < 1) then do
        putStrLn "\nNenhum retorno válido"
        threadDelay 700000
        menuBuscaFilmeLista usr lista

    else do
        let filmesSTR = showMovies movies 1
        printTxt "./App/Menus/MenuBusca/MenuBuscaFilme2.txt"
        putStrLn filmesSTR
        putStr "\nId: "
        hFlush stdout
        userChoice <- getLine
        if ((read userChoice) < 1 || (read userChoice) > length movies) then do
            putStrLn "\nIndex inválido"
            threadDelay 700000
            menuBuscaFilme2Lista usr lista str

        else do
            appendMovieToLista lista (movies !! ((read userChoice) -1))
            menuSelecaoLista2 usr (Data.Maybe.fromJust (getListaById (idtL lista) (getListas 0)))


menuSelecionaFilme :: User -> Lista -> IO()
menuSelecionaFilme usr lista = do
    let movies = filmes lista
    putStr "\nId: "
    hFlush stdout
    userChoice <- getLine
    if ((read userChoice) < 1 || (read userChoice) > length movies) then do
        putStrLn "\nIndex inválido"
        threadDelay 700000
        menuSelecionaFilme usr lista
        
    else do
        printMovieInfo (movies !! ((read userChoice) -1))
        menuFilme (movies !! ((read userChoice) -1))

menuRemoveFilmeLista :: User -> Lista -> IO()
menuRemoveFilmeLista usr lista = do
    let movies = filmes lista
    putStr "\nId: "
    hFlush stdout
    userChoice <- getLine
    if ((read userChoice) < 1 || (read userChoice) > length movies) then do
        putStrLn "\nIndex inválido"
        threadDelay 700000
        menuRemoveFilmeLista usr lista
        
    else do
        editLista (removeMovieFromLista lista (idtM (movies !! ((read userChoice) -1))))
        menuSelecaoLista2 usr (Data.Maybe.fromJust (getListaById (idtL lista) (getListas 0)))


menuEdicaoUsuario :: User -> IO()
menuEdicaoUsuario usr = do
    printTxt "./App/Menus/MenuPerfil/Edicao.txt"
    putStrLn "\nSelecione uma opção: "
    hFlush stdout
    userChoice <- getLine
    menuEdicaoUsuarioOptions usr userChoice


menuEdicaoUsuarioOptions :: User -> String -> IO()
menuEdicaoUsuarioOptions usr userChoice
    | userChoice == "N" || userChoice == "n"    = editNome usr
    | userChoice == "B" || userChoice == "b"    = editBio usr
    | userChoice == "U" || userChoice == "u"    = editUsername usr
    | userChoice == "S" || userChoice == "s"    = editSenha usr
    | userChoice == "V" || userChoice == "v"    = menuPrincipal
    | otherwise = do
        putStrLn "\nOpção Inválida!"
        threadDelay 700000
        menuPerfil usr

editNome :: User -> IO()
editNome usr = do
    newName <- getNameCadastro
    editUser (createUser (idt usr) newName (user usr) (bio usr) (senha usr) (listas usr))
    menuPerfil (Data.Maybe.fromJust(getUserBy (getUsers 0) idt (idt usr))) 


editBio :: User -> IO()
editBio usr = do
    newBio <- getBioCadastro
    editUser (createUser (idt usr) (nome usr) (user usr) newBio (senha usr) (listas usr))
    menuPerfil (Data.Maybe.fromJust(getUserBy (getUsers 0) idt (idt usr))) 

editSenha :: User -> IO()
editSenha usr = do
    newSenha <- getPasswordCadastro
    editUser (createUser (idt usr) (nome usr) (user usr) (bio usr) newSenha (listas usr))
    menuPerfil (Data.Maybe.fromJust(getUserBy (getUsers 0) idt (idt usr))) 

editUsername :: User -> IO()
editUsername usr = do
    newUser <- getUsernameCadastro
    editUser (createUser (idt usr) (nome usr) newUser (bio usr) (senha usr) (listas usr))
    menuPerfil (Data.Maybe.fromJust(getUserBy (getUsers 0) idt (idt usr))) 


