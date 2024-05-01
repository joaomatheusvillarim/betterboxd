:- consult('App/Controllers/UserController.pl').
:- consult('App/Util/StringsOP.pl').

getString(Mensagem, Resposta):- 
    nl,
    write(Mensagem),
    read_line_to_codes(user_input, Codes), 
    string_codes(Resposta, Codes).

getInt(Mensagem, Resposta):-
    getString(Mensagem, String),
    atom_number(String, Resposta).

getUsernameCadastro(R):-
    getString('Digite o seu username: ', R),
    atom_chars(R, R2),
    length(R2, Tamanho),
    (hasUsername(R) -> 
        writeln('Aviso: O nome do usuário já está em uso.'),
        getUsernameCadastro(R);
    Tamanho > 18 ->
        writeln('Aviso: O nome do usuário deve ter no máximo 18 caracteres.'),
        getUsernameCadastro(R);
    true).

getnameCadastro(R):-
    getString('Digite o seu nome: ', R). 

getBioCadastro(R):-
    getString('Digite a sua bio: ', R).

getPasswordCadastro(R):-
    getString('Digite a sua senha: ', R).

getUsernameLogin(R):-
    getString('Digite o seu username: ', Temp),
    atom_string(R, Temp).

getPasswordLogin(R):-
    getString('Digite a sua senha: ', R).

getNumberStars(R):-
    getInt('De 0 a 5 estrelas, como você avalia o filme? ', R),
    (R < 0 ; R > 5 -> 
        writeln('Aviso: Quantidade de estrelas inválidas'),
        getNumberStars(R)    
    ).

getComentario(R):-
    getString('Insira seu comentário: ', R).

writeNvezes(0,_).
writeNvezes(N,R):-
    write(R),
    NewN is N-1,
    writeNvezes(NewN,R).
