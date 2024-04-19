:- set_prolog_flag(encoding, utf8).

lerArquivo(NomeArquivo) :-
    atom_concat('App/Menus/', NomeArquivo, NovoCaminho),
    open(NovoCaminho, read, Stream),
    lerLinhas(Stream),
    close(Stream).                       

lerLinhas(Stream) :-
        not(at_end_of_stream(Stream)),
        read_line(Stream, Line),            
        not(atom_chars(Line, ['_'|_])),       
        writeln(Line),                      
        lerLinhas(Stream).                  
        
lerLinhas(_).  

read_line(Stream, Line) :-
    read_line_to_string(Stream, LineStr),
    atom_string(Line, LineStr).       
