:- set_prolog_flag(encoding, utf8).
:- consult('LeTxt.pl').

menuInicial :-
    
    lerArquivo('MenuInicial.txt'),
    write('Selecione uma opção: '),
    read(X),
    optionsMenuInicial(X).
    
optionsMenuInicial(X):- X = 'E'; X ='e',menuLogin,!.
optionsMenuInicial(X) :- X = 'C'; X = 'c', menuCadastro, !.
optionsMenuInicial(X) :- X = 'S'; X = 's', write(''), !.
optionsMenuInicial(_) :- writeln('Opção inválida!'), menuInicial,!.

menuLogin :-
    
    lerArquivo('MenuLogin.txt'),
    write('Digite o seu username: '),
    read(Login),
    write('Digite sua senha: '),
    read(Senha),
    %doLogin(login),
    menuPrincipal.

menuPrincipal :-
    lerArquivo('MenuPrincipal.txt'),
    write('Selecione uma opção: '),
    read(X).
    %optionsMenuPrincipal(X).
    
    