:- use_module(library(csv)).
:- encoding(utf8).
:- set_prolog_flag(encoding, utf8).
:- consult('App/Controllers/ListaController.pl').
:- consult('App/Controllers/UserController.pl').
:- consult('App/Controllers/MovieController.pl').


cadastraUsuario(Nome, User, Bio, Senha):-
    Temp1 = ['Favoritos de ', Nome],
    Temp2 = ['Filmes loggados de ', Nome],
    Temp3 = ['Recomendados para ', Nome],
    atomic_list_concat(Temp1, '', Nome1),
    atomic_list_concat(Temp2, '', Nome2),
    atomic_list_concat(Temp3, '', Nome3),
    createLista(Nome1, T1),
    createLista(Nome2, T2),
    createLista(Nome3, T3),
    atomic_list_concat([T1, T2, T3], ',', IdsLista),
    appendUser(User, Nome, Bio, Senha, IdsLista).

isLoginValid(User, Senha):-
    hasUsername(User, row(_, User, _, _, Senha, _)).

doLogin(Username):-
    hasUsername(Username, row(Id, Username, _, _, _, _)),
    csv_write_file('App/Data/Temp.csv', [row(Id)]).

criaLista(row(Id, Username, Name, Bio, Senha, IdsLista), Nome, NovoUser):-
    createLista(Nome, T),
    Temp = [IdsLista, T],
    atomic_list_concat(Temp, ',', Resposta),
    editUser(Id, Username, Name, Bio, Senha, Resposta),
    getUser(Id, NovoUser).




