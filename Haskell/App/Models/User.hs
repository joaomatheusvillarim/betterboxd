module App.Models.User where

import App.Models.Lista (Lista)

data User = User    { idt :: String
                    , nome :: String
                    , user :: String
                    , bio :: String
                    , senha :: String
                    , listas :: [Lista]
                    } deriving (Show)

createUser :: String -> String -> String -> String -> String -> [Lista] -> User
createUser idt nome user bio senha listas = User   {
                                         idt = idt
                                        ,nome = nome
                                        ,user = user
                                        ,bio = bio
                                        ,senha = senha
                                        ,listas = listas
                                        }