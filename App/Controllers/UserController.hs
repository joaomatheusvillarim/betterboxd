module App.Controllers.UserController where

import App.Util.SortSearch (msort, searchBy, searchsBy)
import App.Models.User ( User, createUser, idt, user, nome, bio, senha, listas)
import App.Models.Lista ( Lista, idtL, nomeLista, filmes, createLista)
import App.Data.CsvManager ( Matriz, readCSV, writeCSV, appendCSV, editMatriz)
import App.Util.StringsOp( splitList, hGetContents2, splitOn)
import App.Controllers.ListaController(getListaById, getListasById, getListas, listasToIdL, getLastId)
import qualified Data.Maybe
import System.IO

--Recebe uma string com tamanho 5 (parametros de user), retorna um User
stringToUser :: [String] -> User
stringToUser [idt, user, name, bio, senha] = createUser idt name user bio senha []
stringToUser [idt, user, name, bio, senha, listas] = createUser idt name user bio senha (getListasById (splitOn ',' listas) (getListas 0))

--Recebe uma Matriz de strings, e retorna uma lista de usuários
matrizToUser :: Matriz -> [User]
matrizToUser (x:[]) = [stringToUser x]
matrizToUser (x:xs) = stringToUser x : ( matrizToUser xs )

--Converte um usuário para uma representação em lista
userToRow :: User -> [String]
userToRow u = [idt u, user u, nome u, bio u, senha u, listasToIdL (listas u)]

--Retorna uma lista de todos usuarios cadastrados
getUsers :: Int -> [User]
getUsers n =  matrizToUser ( readCSV "./App/Data/Users.csv" )

--Adiciona um User aos arquivos
appendUser :: [String] ->  IO()
appendUser [user, name, bio, senha] = do
    handle <- openFile "./App/Data/Users.csv" ReadWriteMode
    hSetEncoding handle utf8
    contents <- hGetContents2 handle
    let idt = lines contents
    hSeek handle SeekFromEnd 0
    hPutStr handle  ("\n" ++ show (length idt) ++ ";" ++ user ++ ";" ++ name ++ ";" ++ bio ++ ";" ++ senha ++ ";" ++ show indiceLista ++ "," ++ show (indiceLista +1))
    hClose handle
    where indiceLista = read (getLastId 0) -1

--Verifica a existencia de um username, retorna TRUE  caso existe
hasUsername :: String -> Bool
hasUsername str = Data.Maybe.isJust (getUserBy (getUsers 0) user str)

--Busca um usuário de acordo com a função especificada
getUserBy :: (Eq a) => [User]-> (User -> a) -> a -> Maybe User
getUserBy usuarios func resp = searchBy func usuarios resp

getUserLogged :: Int -> User
getUserLogged n = Data.Maybe.fromJust $ getUserBy (getUsers 0) idt userID
    where userID = head (head ( readCSV "./App/Data/Temp.csv" ) )

getNextIdt :: Int -> Int
getNextIdt n = length (readCSV "./App/Data/Perfil.csv")
