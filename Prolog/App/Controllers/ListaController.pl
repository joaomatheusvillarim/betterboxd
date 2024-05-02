:- use_module(library(csv)).
:- encoding(utf8).
:- set_prolog_flag(encoding, utf8).
:- consult('App/Util/StringsOP.pl').
:- consult('App/Controllers/MovieController.pl').

getListas(Listas):- csv_read_file('App/Data/Listas.csv', Listas).

getLista(Id, Lista):- 
    getListas(Listas), 
    nth1(Id, Listas, Lista).

getListasByString(Str, Listas):-
    splitNumbers(Str, Temp),
    getListasById(Temp, Listas).

getListasById([], []).
getListasById([H|T], R):- 
    getLista(H, Lista), 
    getListasById(T, R2), 
    append([Lista], R2, R).

listasToIds([], '').
listasToIds([H|T], R):- 
    listasToIdsAux([H|T], Lista),
    atomic_list_concat(Lista, ',', R).

listasToIdsAux([], []).
listasToIdsAux([row(Id, _, _)|T], R):- 
    listasToIdsAux(T, R2),
    append([Id], R2, R).
 
createLista(Nome, T):-
    getListas(Listas),
    length(Listas, T2),
    T is T2 + 1,
    append(Listas, [row(T, Nome, '')], NovaListas),
    csv_write_file('App/Data/Listas.csv', NovaListas).

editLista(ID, Nome, Filmes):-
    getListas(Listas),
    editListaAux(Listas, ID, Nome, Filmes, Saida),
    csv_write_file('App/Data/Listas.csv', Saida).

editListaAux([], _, _, _, []).
editListaAux([row(ID, _, _)|T], ID, Nome, Filmes, [row(ID, Nome, Filmes)|T]).
editListaAux([H|T], ID, Nome, Filmes, [H|Out]):- editListaAux(T, ID, Nome, Filmes, Out).

appendMovieToLista(IdLista, row(ID, _, _, _, _, _, _, _)):-
    getLista(IdLista, row(IdLista, Nome, Filmes)),
    (Filmes = '' -> editLista(IdLista, Nome, ID);
        splitNumbers(Filmes, ListaFilmes),
        (not(member(ID, ListaFilmes)) -> 
            append([Filmes], [ID], R),
            atomic_list_concat(R, ',', NovosFilmes),
            editLista(IdLista, Nome, NovosFilmes);
            sleep(0.01))).

removeMovieFromLista(IdLista, row(ID, _, _, _, _, _, _, _)):-
    getLista(IdLista, row(IdLista, Nome, Filmes)),
    splitNumbers(Filmes, ListaFilmes),
    (member(ID, ListaFilmes) -> remove_element(ID, ListaFilmes, R),
    atomic_list_concat(R, ',', NovosFilmes),
    editLista(IdLista, Nome, NovosFilmes);
    sleep(0.01)).

exibeLista(row(_, Nome, ''), Resposta):-
    Lista = [   '=========================================\n',
                '      ', Nome, '\n',
                '=========================================\n',
                'Você não possui nenhum filme!'            
            ],
    atomic_list_concat(Lista, '', Resposta).

exibeLista(row(_, Nome, Filmes), Resposta):-
    splitNumbers(Filmes, ListaFilmes),
    getMoviesByIds(ListaFilmes, Movies),
    showMovies(Movies, 1, StringMovies),
    Lista = [   '=========================================\n',
                '      ', Nome, '\n',
                '=========================================\n',
                StringMovies            
            ],
    atomic_list_concat(Lista, '', Resposta).

exibeListas(Listas, Num, Resposta) :-
    exibeListasAux(Listas, Num, Lista),
    atomic_list_concat(Lista, '', Resposta).

exibeListasAux([], _, []).
exibeListasAux([row(_, Nome, _)|T], Num, [Resposta|Resto]) :-
    atomic_list_concat([Num, ', ', Nome, '\n'], Resposta),
    Num2 is Num + 1,
    exibeListasAux(T, Num2, Resto).
