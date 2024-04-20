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

getnameCadastro(R):-
    getString('Digite o seu nome: ', R).

getBioCadastro(R):-
    getString('Digite a sua bio: ', R).

getPasswordCadastro(R):-
    getString('Digite a sua senha: ', R).

getUsernameLogin(R):-
    getString('Digite o seu username: ', R).

getPasswordLogin(R):-
    getString('Digite a sua senha: ', R).

getNumberStars(R):-
    getInt('De 0 a 5 estrelas, como você avalia o filme? ', R).

getComentario(R):-
    getString('Insira seu comentário: ', R).

writeNvezes(0,_).
writeNvezes(N,R):-
    write(R),
    NewN is N-1,
    writeNvezes(NewN,R).
