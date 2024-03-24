module App.Util.GetInfos where

import System.IO ( hFlush, stdout )
import App.Controllers.UserController( hasUsername )

getUsernameCadastro :: IO String
getUsernameCadastro = do
    putStr "\nDigite o seu username: "
    hFlush stdout
    username <- getLine

    if hasUsername username then do
        putStrLn "\nAviso: O nome do usuário já está em uso."
        getUsernameCadastro

    else if length username > 18 then do
        putStrLn "\nAviso: O nome do usuário deve ter no máximo 18 caracteres."
        getUsernameCadastro

    else return username

getNameCadastro :: IO String
getNameCadastro = do
    putStr "Digite o seu nome: "
    hFlush stdout
    name <- getLine

    if length name > 18 then do
        putStrLn "\nAviso: O seu nome deve ter no máximo 18 caracteres."
        getNameCadastro

    else return name

getBioCadastro :: IO String
getBioCadastro = do
    putStr "Digite a sua bio: "
    hFlush stdout
    getLine

getPasswordCadastro :: IO String
getPasswordCadastro = do
    putStr "Digite a sua senha: "
    hFlush stdout
    password <- getLine

    if length password < 5 then do
        putStrLn "\nAviso: A senha deve ter no mínimo 5 digitos."
        getPasswordCadastro

    else return password

getUsernameLogin :: IO String
getUsernameLogin = do
    putStr "\nDigite o seu username: "
    hFlush stdout
    getLine

getPasswordLogin :: IO String
getPasswordLogin = do
    putStr "Digite a sua senha: "
    hFlush stdout
    getLine

getNumberStars :: IO Int
getNumberStars = do
    putStr "De 0 a 5 estrelas, como você avalia o filme? "
    hFlush stdout
    n <- getLine
    if ((read n) < 0 || (read n) > 5) then do
        putStrLn "\nAviso: Quantidade de estrelas inválidas"
        getNumberStars

    else return (read n)
    
getComentario :: IO String
getComentario = do
    putStr "Insira seu comentário: "
    hFlush stdout
    getLine