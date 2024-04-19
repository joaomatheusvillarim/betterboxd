getUsernameCadastro(R):-
    nl,
    write('Digite o seu username: '),
    read(R).

getnameCadastro(R):-
    write('Digite o seu nome: '),
    read(R).

getBioCadastro(R):-
    write('Digite a sua bio: '),
    read(R).

getPasswordCadastro(R):-
    write('Digite a sua senha: '),
    read(R).

getUsernameLogin(R):-
    nl,
    write('Digite o seu username: '),
    read(R).

getPasswordLogin(R):-
    nl,
    write('Digite a sua senha: '),
    read(R).

getNumberStars(R):-
    write('De 0 a 5 estrelas, como você avalia o filme? '),
    read(R).

getComentario(R):-
    write('Insira seu comentário: '),
    read(R).

writeNvezes(0,_).
writeNvezes(N,R):-
    write(R),
    NewN is N-1,
    writeNvezes(NewN,R).
