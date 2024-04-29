merge([],[],_).
merge(L,[],L).
merge([],R,R).
merge([H:T],[H2:T2],[H:T3]):- H>=H2,merge(T,[H2:T2],T3),!.
merge([H:T],[H2:T2],[H2:T3]):- merge([H:T],T2,T3),!.

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
