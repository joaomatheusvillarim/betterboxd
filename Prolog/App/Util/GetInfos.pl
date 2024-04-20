getInfo(Mensagem, Resposta):- 
    nl,
    write(Mensagem),
    read_line_to_codes(user_input, Codes),
    string_codes(Resposta, Codes).

getUsernameCadastro(R):-
    getInfo('Digite o seu username: ', R).

getnameCadastro(R):-
    getInfo('Digite o seu nome: ', R).

getBioCadastro(R):-
    getInfo('Digite a sua bio: ', R).

getPasswordCadastro(R):-
    getInfo('Digite a sua senha: ', R).

getUsernameLogin(R):-
    getInfo('Digite o seu username: ', R).

getPasswordLogin(R):-
    getInfo('Digite a sua senha: ', R).

getNumberStars(R):-
    getInfo('De 0 a 5 estrelas, como você avalia o filme? ', R).

getComentario(R):-
    getInfo('Insira seu comentário: ', R).

writeNvezes(0,_).
writeNvezes(N,R):-
    write(R),
    NewN is N-1,
    writeNvezes(NewN,R).
