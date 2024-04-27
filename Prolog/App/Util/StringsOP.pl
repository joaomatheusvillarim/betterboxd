isSubstring(Small, Big):- 
    string_lower(Small, SmallLower), 
    string_lower(Big, BigLower),    
    string_chars(SmallLower, R1), 
    string_chars(BigLower, R2), 
    isSubstringAux(R1, R2).

isSubstringAux(Small, Big):- append(_, Q, Big), append(Small, _, Q).

stringToList(String, Lista) :-
    sub_string(String, 1, _, 1, SemColchetes),
    atomic_list_concat(Atoms, ', ', SemColchetes),
    maplist(atom_string, Lista, Atoms).
