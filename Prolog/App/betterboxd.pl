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

media_avaliacoes([], 0, 0).
media_avaliacoes([row(_, _, NumStar, _) | Resto], Soma, NumAvaliacoes) :-
    media_avaliacoes(Resto, SomaResto, NumAvaliacoesResto),
    Soma is SomaResto + NumStar,
    NumAvaliacoes is NumAvaliacoesResto + 1.

media_total_avaliacoes(Lista, Media) :-
    media_avaliacoes(Lista, Soma, NumAvaliacoes),
    NumAvaliacoes > 0,
    Media is Soma / NumAvaliacoes.

avaliacoes([],  ' Avaliação média: Nenhuma avalição realizada'):- !.
avaliacoes(Lista, Str):-
    media_total_avaliacoes(Lista, Media),
    Temp = [' Avaliação média: ', Media, ' estrelas'],
    atomic_list_concat(Temp, Str).

comentarios([], '  - Nenhum comentário disponível.'):- !.
comentarios(P, Str):-
    comentariosAux(P, Lista),
    atomic_list_concat(Lista, Str).

comentariosAux([], []).
comentariosAux([row(IdUser, _, NumStar, Comentario)|T], L):-
    getUser(IdUser, row(IdUser, _, Name, _, _, _)),
    comentariosAux(T, L2),
    Temp = [' ', Name, " - ", NumStar, ' estrelas: ', Comentario, '\n'],
    append(Temp, L2, L).
    
movieInfo(row(Id, Titulo, Rating, _, Ano, Atores, Diretores, _), Str):-
    getComentariosByMovie(Id, Comentarios),
    avaliacoes(Comentarios, Temp1),
    comentarios(Comentarios, Temp2),
    Lista = [
                '********************************************************************************\n',
                '\n',
                '                              Informações do Filme\n',
                '\n',
                '********************************************************************************\n',
                ' Título:          ', Titulo, '\n',
                ' Rating:          ', Rating, '\n',
                Temp1, '\n',
                ' Ano:             ', Ano, '\n',
                ' Atores:          ', Atores, '\n',
                ' Diretor:         ', Diretores, '\n',
                '********************************************************************************\n',
                ' Comentários:\n',
                Temp2, '\n',
                '********************************************************************************\n'
    ],
    atomic_list_concat(Lista, Str).


