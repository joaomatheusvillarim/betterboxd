module App.Models.User where

data User = User    { nome :: String
                    , user :: String
                    , bio :: String
                    , senha :: String
                    } deriving (Show)

createUser :: String -> String -> String -> String -> User
createUser nome user bio senha = User   {
                                         nome = nome
                                        ,user = user
                                        ,bio = bio
                                        ,senha = senha
                                        }