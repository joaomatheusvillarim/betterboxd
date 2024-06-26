:- use_module(library(csv)).
:- encoding(utf8).
:- set_prolog_flag(encoding, utf8).
:- consult('App/Controllers/ListaController.pl').
:- consult('App/Util/StringsOP.pl').

getUsers(Usuarios):- csv_read_file('App/Data/Users.csv', Usuarios).

getUser(Id, Usuario):- getUsers(Usuarios), nth1(Id, Usuarios, Usuario).

appendUser(Username, Name, Bio, Senha, IdsLista):-
    getUsers(Usuarios),
    length(Usuarios, Id2),
    Id is Id2 + 1,
    append(Usuarios, [row(Id, Username, Name, Bio, Senha, IdsLista)], Saida),
    csv_write_file('App/Data/Users.csv', Saida).

editUser(Id, Username, Name, Bio, Senha, IdsLista):-
    getUsers(Usuarios),
    editUserAux(Usuarios, Id, Username, Name, Bio, Senha, IdsLista, Saida),
    csv_write_file('App/Data/Users.csv', Saida).

hasUsername(Username):-
    hasUsername(Username, _).

hasUsername(Username, R):-
    getUsers(U),
    hasUsernameAux(Username, U, R).

hasUsernameAux(Username, [row(Id, Username, Name, Bio, Senha, IdsLista)|_], row(Id, Username, Name, Bio, Senha, IdsLista)):- !.
hasUsernameAux(Username, [row(_, _, _, _, _, _)|T], R):- hasUsernameAux(Username, T, R).

getUserLogged(User):-
    csv_read_file('App/Data/Temp.csv', [row(ID)]),
    getUser(ID, User).

editUserAux([], _, _, _, _, _, _, []).
editUserAux([row(Id, _, _, _, _, _)|T], Id, Username, Name, Bio, Senha, IdsLista, [row(Id, Username, Name, Bio, Senha, IdsLista)|T]):- !.
editUserAux([H|T], Id, Username, Name, Bio, Senha, IdsLista, [H|Out]):- editUserAux(T, Id, Username, Name, Bio, Senha, IdsLista, Out).

editUsername(Id, Edicao):-
    getUser(Id, row(Id, _, Name, Bio, Senha, IdsLista)),
    editUser(Id, Edicao, Name, Bio, Senha, IdsLista).

editName(Id, Edicao):-
    getUser(Id, row(Id, Username, _, Bio, Senha, IdsLista)),
    editUser(Id, Username, Edicao, Bio, Senha, IdsLista).

editBio(Id, Edicao):-
    getUser(Id, row(Id, Username, Name, _, Senha, IdsLista)),
    editUser(Id, Username, Name, Edicao, Senha, IdsLista).

editSenha(Id, Edicao):-
    getUser(Id, row(Id, Username, Name, Bio, _, IdsLista)),
    editUser(Id, Username, Name, Bio, Edicao, IdsLista).

editLista(Id, Edicao):-
    getUser(Id, row(Id, Username, Name, Bio, Senha, _)),
    editUser(Id, Username, Name, Bio, Senha, Edicao).

exibeUsuarios(Resposta):-
    getUsers(Usuarios),
    exibeUsuariosAux(Usuarios, Lista),
    atomic_list_concat(Lista, '', Resposta).

exibeUsuariosAux([], '').
exibeUsuariosAux([row(Id, _, Nome, _, _, _)], Resposta):- append([Id, '. ', Nome], [], Resposta), !.
exibeUsuariosAux([row(Id, _, Nome, _, _, _)|T], Resposta):- exibeUsuariosAux(T, Resposta2), append([Id, '. ', Nome, '\n'], Resposta2, Resposta).

exibePerfil(row(_, Username, Name, Bio, _, IdsLista), Resposta):-
    splitNumbers(IdsLista, Ids),
    getListasById(Ids, Listas),
    exibeListas(Listas, 1, Resultado),
    Lista = ['=========================================\n',
             '            Perfil de Usuário          \n',
             '=========================================\n',
             'Nome:     ', Name, '\n',
             'Username: ', Username, '\n',
             'Bio:      ', Bio, '\n',
             '-----------------------------------------\n',
             Resultado, 
             '-----------------------------------------'
            ],
    atomic_list_concat(Lista, '', Resposta).

exibeEstatisticas(row(_, _, _, _, _, IdsLista), Str):-
    getListasByString(IdsLista, Listas),
    nth0(0, Listas, row(_, _, FavoritosStr)),
    nth0(1, Listas, row(_, _, AssistidosStr)),
    splitNumbers(FavoritosStr, Temp1),
    getMoviesByIds(Temp1, Favoritos),
    splitNumbers(AssistidosStr, Temp2),
    getMoviesByIds(Temp2, Assistidos),
    union(Favoritos, Assistidos, Total),
    length(Total, N),
    mostFrequentGender(Total, G),
    mostFrequentActor(Total, A),
    mostFrequentDirector(Total, D),
    Lista = [
        '=========================================\n',
        '          Estatisticas de Usuário        \n',
        '=========================================\n',
        'Filmes assistidos:     ', N, '\n',
        'Gênero favorito:       ', G, '\n',
        'Ator(a) favorito:      ', A, '\n',
        'Diretor(a) favorito:   ', D, '\n',
        '========================================='
    ],
    atomic_list_concat(Lista, Str).

