:-consult('StringsOP.pl').

merge([],[],_):- !.
merge(L,[],L):- !.
merge([],R,R):- !.
merge([row(ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios)|T],
    [row(ID2, Titulo2, Rating2, Generos2, Ano2, Atores2, Diretores2, Comentarios2)|T2],
    [row(ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios)|T3]):-
        Rating>=Rating2,
        merge(T,[row(ID2, Titulo2, Rating2, Generos2, Ano2, Atores2, Diretores2, Comentarios2)|T2],T3), !.

merge([row(ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios)|T],
    [row(ID2, Titulo2, Rating2, Generos2, Ano2, Atores2, Diretores2, Comentarios2)|T2],
    [row(ID2, Titulo2, Rating2, Generos2, Ano2, Atores2, Diretores2, Comentarios2)|T3]):-
        merge([row(ID, Titulo, Rating, Generos, Ano, Atores, Diretores, Comentarios)|T],T2,T3), !.


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

secondMostFrequent('Genero', [], ''):- !.
secondMostFrequent('Genero', Movies, R):-
    listaGeneros(Movies, Temp),
    extrair(Temp, Temp2),
    second_most_common_element(Temp2, R).

mostFrequent('Genero', [], ''):- !.
mostFrequent('Diretor', [], ''):- !.
mostFrequent('Ator', [], ''):- !.

mostFrequent('Genero', Movies, R):-
    listaGeneros(Movies, Temp),
    extrair(Temp, Temp2),
    most_common_element(Temp2, R).

mostFrequent('Diretor', Movies, R):-
    listaDiretor(Movies, Temp),
    extrair(Temp, Temp2),
    most_common_element(Temp2, R).

mostFrequent('Ator', Movies, R):-
    listaAtor(Movies, Temp),
    extrair(Temp, Temp2),
    most_common_element(Temp2, R).

listaGeneros([],[]).
listaGeneros([row(_,_,_,Genero,_,_,_,_)|T],[Genero|T2]):-
    listaGeneros(T,T2),!.

listaDiretor([],[]).
listaDiretor([row(_,_,_,_,_,_,Diretor,_)|T],[Diretor|T2]):-
    listaDiretor(T,T2),!.

listaAtor([],[]).
listaAtor([row(_,_,_,_,_,Ator,_,_)|T],[Ator|T2]):-
    listaAtor(T,T2),!.

extrair(ListaStrings, ListaExtraida) :-
    maplist(stringToList2, ListaStrings, ListasExtraidas),
    flatten(ListasExtraidas, ListaExtraida).

most_common_element(List, Result) :-
    msort(List, SortedList),  
    group_list(SortedList, Grouped), 
    find_most_common(Grouped, _, Result), !. 

second_most_common_element(List, Result) :-
    msort(List, SortedList),  
    group_list(SortedList, Grouped), 
    find_most_common(Grouped, MostCommonGroup, _), 
    delete(Grouped, MostCommonGroup, Remaining), 
    find_most_common(Remaining, _, Result), !. 

group_list([], []).
group_list([X|Xs], [[X|Group]|Rest]) :-
    group(X, Xs, Group, Remainder),
    group_list(Remainder, Rest).

group(X, [X|Xs], [X|Group], Remainder) :-
    group(X, Xs, Group, Remainder).
group(_, List, [], List).

find_most_common([], [], _).
find_most_common([[X|Xs]|Groups], MaxGroup, Result) :-
    length([X|Xs], Len),
    find_most_common(Groups, MaxGroup1, Result1),
    length(MaxGroup1, MaxLen),
    (Len > MaxLen ->
        MaxGroup = [X|Xs],
        Result = X;
        MaxGroup = MaxGroup1,
        Result = Result1
    ).