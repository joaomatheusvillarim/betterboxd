:- set_prolog_flag(encoding, utf8).

limpaTela():-
    Temp = '\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n',
    writeln(Temp).

lerArquivo(NomeArquivo) :-
    limpaTela,
    atom_concat('App/Menus/MenusTxt/', NomeArquivo, NovoCaminho),
    open(NovoCaminho, read, Stream),
    lerLinhas(Stream),
    close(Stream).

lerLinhas(Stream) :-
    repeat,
    (   at_end_of_stream(Stream) ->
        ! ;
        read_line(Stream, Line),
        not(atom_chars(Line, ['_'|_])),
        writeln(Line),
        fail
    ).                 
    

read_line(Stream, Line) :-
    read_line_to_string(Stream, LineStr),
    atom_string(Line, LineStr).       
