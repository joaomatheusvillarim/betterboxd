getString(Mensagem, Resposta):- 
    nl,
    write(Mensagem),
    read_line_to_codes(user_input, Codes), 
    string_codes(Resposta, Codes).

getInt(Mensagem, Resposta):-
    getString(Mensagem, String),
    atom_number(String, Resposta).

getUsernameCadastro(R):-
    getString('Digite o seu username: ', R).
    length(R,Tamanho),
    (hasUsername(R) -> 
        writeln('Aviso: O nome do usuário já está em uso.'),
        getUsernameCadastro(R)
    ;Tamanho > 18 ->
        writeln('Aviso: O nome do usuário deve ter no máximo 18 caracteres.'),
    getUsernameCadastro(R)
    ).

getnameCadastro(R):-
    getString('Digite o seu nome: ', R),
    length(R,Tamanho),
    (Tamanho > 18 -> 
        writeln('Aviso: O seu nome deve ter no máximo 18 caracteres.'),
        getnameCadastro(R)
    ).

getBioCadastro(R):-
    getString('Digite a sua bio: ', R).

getPasswordCadastro(R):-
    getString('Digite a sua senha: ', R),
    length(R,Tamanho),
    (Tamanho < 5 ->
        writeln('Aviso: A senha deve ter no mínimo 5 digitos.'),
        getPasswordCadastro(R)
    ).

getUsernameLogin(R):-
    getString('Digite o seu username: ', R).

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
