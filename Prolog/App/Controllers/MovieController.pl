:- use_module(library(csv)).
:- encoding(utf8).
:- set_prolog_flag(encoding, utf8).
:- consult('App/Util/StringsOP.pl').

getMovies(Movies):- csv_read_file('App/Data/Movies.csv', Movies).

getMovie(Id, Movie):- getMovies(Movies), nth1(Id, Movies, Movie).

editMovie(ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios):-
    getMovies(Movies),
    editMovieAux(Movies, ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios, Saida),
    csv_write_file('App/Data/Movies.csv', Saida).

editMovieAux([], _, _, _, _, _, _, _, _, []).
editMovieAux([row(ID, _, _, _, _, _, _, _)|T], ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios, [row(ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios)|T]).
editMovieAux([H|T], ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios, [H|Out]):- editUserAux(T, ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios, Out).

editComentarios(Id, Edicao):-
    getMovie(Id, row(Id, Titulo, Rating, Generos, Ano, Atores, Diretores, _)),
    editMovie(Id, Titulo, Rating, Generos, Ano, Atores, Diretores, Edicao).


getMovieByTitle(Titulo, Resposta):-
    getMovies(Movies),
    getMovieByTittleAux(Movies, Titulo, Resposta).

getMovieByTittleAux([], _, []).
getMovieByTittleAux([row(ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios)|T], TituloBuscado, Resposta):-
    (isSubstring(TituloBuscado, Titulo) -> getMovieByTittleAux(T, TituloBuscado, Resposta2), Resposta = [row(ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios)|Resposta2]
        ;getMovieByTittleAux(T, TituloBuscado, Resposta)).

getMovieByGenre(Genero, Resposta):-
    getMovies(Movies),
    getMovieByGenreAux(Movies, Genero, Resposta).

getMovieByGenreAux([], _, []).
getMovieByGenreAux([row(ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios)|T], GeneroBuscado, Resposta):-
    (isSubstring(GeneroBuscado, Generos) -> getMovieByGenreAux(T, GeneroBuscado, Resposta2), Resposta = [row(ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios)|Resposta2]
        ;getMovieByGenreAux(T, GeneroBuscado, Resposta)).

showMovies(Movies, Num, Resposta) :-
    showMoviesAux(Movies, Num, Lista),
    atomic_list_concat(Lista, '', Resposta).

showMoviesAux([], _, []).
showMoviesAux([row(_, Titulo, _, _, Ano, _, _, _)|T], Num, [Resposta|Resto]) :-
    atomic_list_concat([Num, ', ', Titulo, ', ', Ano, '\n'], Resposta),
    Num2 is Num + 1,
    showMoviesAux(T, Num2, Resto).