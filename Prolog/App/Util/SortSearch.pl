merge([],[],_).
merge(L,[],L).
merge([],R,R).
merge([row(ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios)|T],[row(ID2, Titulo2, Rating2, Generos2, Ano2, Atores2, Diretores2, Comentarios2)|T2],[row(ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios)|T3]): Rating>=Rating2,merge(T,[row(ID2, Titulo2, Rating2, Generos2, Ano2, Atores2, Diretores2, Comentarios2)|T2],T3),!.
merge([row(ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios)|T],[row(ID2, Titulo2, Rating2, Generos2, Ano2, Atores2, Diretores2, Comentarios2)|T2],[row(ID2, Titulo2, Rating2, Generos2, Ano2, Atores2, Diretores2, Comentarios2)|T3]):- merge([row(ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios)|T],T2,T3),!.

split(Lista, Esquerda, Direita) :-
    length(Lista, Tamanho),
    Metade is Tamanho // 2,
    length(Esquerda, Metade),
    append(Esquerda, Direita, Lista).
    
merge_sort([], []).
merge_sort([X], [X]).
merge_sort(Lista, Ordenada) :-
    split(Lista, Esquerda, Direita),
    merge_sort(Esquerda, EsquerdaOrdenada),
    merge_sort(Direita, DireitaOrdenada),
    merge(EsquerdaOrdenada, DireitaOrdenada, Ordenada).

listaGenero([], []).
listaGenero([row(_, _, _, [G|Gs], _, _, _, _)|T], G),!.

    

most_common_element(List, Result) :-
    select(Result, List, Rest),
    select(Result, Rest, RestWithoutResult),
    \+ member(Result, RestWithoutResult).
