module App.Betterboxd where

import App.Models.User ( User, createUser, idt, user, nome, bio, senha )
import App.Controllers.UserController (getUsers, appendUser, getUserLogged, getUserBy, hasUsername, getNextIdt, stringToUser) 

cadastraUsuario :: String -> String -> String -> String -> IO()
cadastraUsuario nome user bio senha = appendUser [nome, user, bio, senha]

