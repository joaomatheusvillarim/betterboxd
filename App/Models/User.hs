module App.Models.User where

data User = User    { idt :: String
                    , nome :: String
                    , user :: String
                    , bio :: String
                    , senha :: String
                    } deriving (Show)

createUser :: String -> String -> String -> String -> String -> User
createUser idt nome user bio senha = User   {
                                         idt = idt
                                        ,nome = nome
                                        ,user = user
                                        ,bio = bio
                                        ,senha = senha
                                        }