:- use_module(library(csv)).
:- encoding(utf8).

getUsers(Usuarios):- csv_read_file('App/Data/Users.csv', [_|Usuarios]).

getUser(Id, Usuario):- getUsers(Usuarios), nth1(Id, Usuarios, Usuario).

appendUser(Username, Name, Bio, Senha, IdsLista):-
    getUsers(Usuarios),
    length(Usuarios, Id),
    append(Usuarios, [row(Id, Username, Name, Bio, Senha, IdsLista)], Saida),
    csv_write_file('App/Data/Users.csv', Saida).

editUser(Id, Username, Name, Bio, Senha, IdsLista):-
    getUsers(Usuarios),
    editUserAux(Usuarios, Id, Username, Name, Bio, Senha, IdsLista, Saida),
    csv_write_file('App/Data/Users.csv', Saida).

editUserAux([], _, _, _, _, _, _, []).
editUserAux([row(Id, _, _, _, _, _)|T], Id, Username, Name, Bio, Senha, IdsLista, [row(Id, Username, Name, Bio, Senha, IdsLista)|T]).
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
    %exibeListas(IdsLista, Resultado),
    Lista = ['=========================================\n',
             '            Perfil de Usuário          \n',
             '=========================================\n',
             'Nome:     ', Name, '\n',
             'Username: ', Username, '\n',
             'Bio:      ', Bio, '\n',
             '-----------------------------------------\n'
             %'%Resultado, '\n', '-----------------------------------------'
            ],
    atomic_list_concat(Lista, '', Resposta).

%Exibe estatisticas precisa de funcoes de lista.

