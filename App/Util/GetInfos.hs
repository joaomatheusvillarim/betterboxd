module App.Util.GetInfos where

import System.IO ( hFlush, stdout )

getUsernameCadastro :: IO String
getUsernameCadastro = do
    putStr "Digite o seu username: "
    hFlush stdout
    username <- getLine

    if length username > 18 then do
        putStrLn "\nAviso: O nome do usuário deve ter no máximo 18 caracteres."
        getUsernameCadastro

    else return username

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