:- use_module(library(csv)).
:- encoding(utf8).
:- set_prolog_flag(encoding, utf8).
:- consult('App/Util/StringsOP.pl').
:- consult('App/Util/SortSearch.pl').


getMovies(Movies):- csv_read_file('App/Data/Movies.csv', Movies).

getMovie(Id, Movie):- getMovies(Movies), nth1(Id, Movies, Movie).

editMovie(ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios):-
    getMovies(Movies),
    editMovieAux(Movies, ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios, Saida),
    csv_write_file('App/Data/Movies.csv', Saida).

editMovieAux([], _, _, _, _, _, _, _, _, []).
editMovieAux([row(ID, _, _, _, _, _, _, _)|T], ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios, [row(ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios)|T]).
editMovieAux([H|T], ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios, [H|Out]):- editMovieAux(T, ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios, Out).

getMovieByTitle(Titulo, Resposta):-
    getMovies(Movies),
    getMovieByTittleAux(Movies, Titulo, Temp),
    take(Temp, 10, Resposta).

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

getMoviesByIds([], []).
getMoviesByIds([H|T], R):-  
    getMoviesByIds(T, R2),
    getMovie(H, Movie), 
    append([Movie], R2, R).

showMovies(Movies, Num, Resposta) :-
    showMoviesAux(Movies, Num, Lista),
    atomic_list_concat(Lista, '', Resposta).

showMoviesAux([], _, []).
showMoviesAux([row(_, Titulo, _, _, Ano, _, _, _)|T], Num, [Resposta|Resto]) :-
    atomic_list_concat([Num, ', ', Titulo, ', ', Ano, '\n'], Resposta),
    Num2 is Num + 1,
    showMoviesAux(T, Num2, Resto).

getAllComentarios(Comentarios):- csv_read_file('App/Data/Comentarios.csv', Comentarios).

getComentariosByMovie(IdMovie, Comentarios):-
    getAllComentarios(AllComentarios),
    getComentariosByMovieAux(IdMovie, AllComentarios, Comentarios).

getComentariosByMovieAux(_, [], []).
getComentariosByMovieAux(IdMovie, [row(IdUser, IdMovie, NumStar, Comentario)|T], [row(IdUser, IdMovie, NumStar, Comentario)|T2]):- 
    getComentariosByMovieAux(IdMovie, T, T2), !.
getComentariosByMovieAux(IdMovie, [_|T], R):- getComentariosByMovieAux(IdMovie, T, R).

appendComentario(IdUser, IdMovie, NumStar, Comentario):-
    getAllComentarios(C),
    append(C, [row(IdUser, IdMovie, NumStar, Comentario)], Saida),
    csv_write_file('App/Data/Comentarios.csv', Saida).

hasComment(IdUser, IdMovie):-
    getComentariosByMovie(IdMovie, C),
    member(row(IdUser, IdMovie, _, _), C).

editComment(IdUser, IdMovie, NumStar, Comentario):-
    getAllComentarios(C),
    editCommentAux(C, IdUser, IdMovie, NumStar, Comentario, Saida),
    csv_write_file('App/Data/Comentarios.csv', Saida).

editCommentAux([], _, _, _, _, []).
editCommentAux([row(IdUser, IdMovie, _, _)|T], IdUser, IdMovie, NumStar, Comentario, [row(IdUser, IdMovie, NumStar, Comentario)|T]):- !.
editCommentAux([H|T], IdUser, IdMovie, NumStar, Comentario, [H|Out]):- editCommentAux(T, IdUser, IdMovie, NumStar, Comentario, Out).

mostFrequentGender([], ''):- !.
mostFrequentGender(Movies, R):- mostFrequent('Genero', Movies, R).

secondMostFrequentGender([], ''):- !.
secondMostFrequentGender(Movies, R):- secondMostFrequent('Genero', Movies, R).

mostFrequentActor([], ''):- !.
mostFrequentActor(Movies, R):- mostFrequent('Ator', Movies, R).

mostFrequentDirector([], ''):- !.
mostFrequentDirector(Movies, R):- mostFrequent('Diretor', Movies, R).

getBestMoviesByGenre(Genero, Saida):-
    getMovieByGenre(Genero, Filmes),
    merge_sort(Filmes, FilmesOrdenados),
    take(FilmesOrdenados, 10, Saida).

recomendaMovies(Favoritos, _, Saida):-
    mostFrequentGender(Favoritos, Genero1),
    secondMostFrequentGender(Favoritos, Genero2),
    getMovieByGenre(Genero1, Temp1),
    getMovieByGenreAux(Temp1, Genero2, Temp2),
    merge_sort(Temp2, FilmesOrdenados),
    take(FilmesOrdenados, 10, Saida).

