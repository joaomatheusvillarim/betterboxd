getString(Message, Input) :-
    write(Message),
    read_line_to_string(user_input, Input).

getInt(Message, Input):-
    getAtom(Message, Temp),
    (atom_number(Temp, N) -> Input = N; writeln('Opção inválida'),sleep(0.8),getInt(Message, Input)).

getAtom(Message, Input) :-
    write(Message),
    read_string(user_input, "\n", "\r", _, InputAtom),
    atom_string(Input, InputAtom).

getUserChoice(R):-
    getAtom('Escolha uma opção: ', R).

getUsernameCadastro(R):-
    getString('Digite o seu username: ', R).

getnameCadastro(R):-
    getString('Digite o seu nome: ', R). 

getBioCadastro(R):-
    getString('Digite a sua bio: ', R).

getPasswordCadastro(R):-
    getString('Digite a sua senha: ', R).

getUsernameLogin(R):-
    getAtom('Digite o seu username: ', Temp),
    (atom_number(Temp, N) -> R = N; R = Temp).

getPasswordLogin(R):-
    getAtom('Digite a sua senha: ', Temp),
    (atom_number(Temp, N) -> R = N; R = Temp).