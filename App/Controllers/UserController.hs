module App.Controllers.UserController where

import App.Models.User ( User, createUser, idt, user, nome, bio, senha)
import App.Data.CsvManager ( Matriz, readCSV, writeCSV, appendCSV )
import qualified Data.Maybe

--Recebe uma string com tamanho 5 (parametros de user), retorna um User
stringToUser :: [String] -> User
stringToUser [idt, user, name, bio, senha] = createUser idt name user bio senha

--Recebe uma Matriz de strings, e retorna uma lista de usuários
matrizToUser :: Matriz -> [User]
matrizToUser (x:[]) = [stringToUser x]
matrizToUser (x:xs) = stringToUser x : ( matrizToUser xs )

--Converte um usuário para uma representação em lista
userToRow :: User -> [String]
userToRow u = [idt u, user u, nome u, bio u, senha u]

--Retorna uma lista de todos usuarios cadastrados
getUsers :: Int -> [User]
getUsers n =  matrizToUser ( readCSV "./App/Data/Users.csv" )

--Adiciona um User aos arquivos
appendUser :: User ->  IO()
appendUser u = appendCSV "./App/Data/Users.csv" ( userToRow u )

--Verifica a existencia de um username, retorna TRUE  caso existe
hasUsername :: String -> Bool
hasUsername str = Data.Maybe.isJust (getUserBy (getUsers 0) user str)

--Busca um usuário de acordo com a função especificada
getUserBy :: [User]-> (User -> String) -> String -> Maybe User
getUserBy [] func resp =  Nothing
getUserBy (x:xs) func resp
    | func x == resp    = Just x
    | otherwise         = getUserBy xs func resp