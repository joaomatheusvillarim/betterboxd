:- set_prolog_flag(encoding, utf8).
:- consult('LeTxt.pl').
:- consult('../Util/GetInfos.pl').


menuInicial :-
    
    lerArquivo('MenuInicial.txt'),
    write('Selecione uma opção: '),
    read(X),
    optionsMenuInicial(X).

optionsMenuInicial('E'):- menuLogin,!.
optionsMenuInicial('e'):- menuLogin,!.
optionsMenuInicial('C'):- menuCadastro,!.
optionsMenuInicial('c'):- menuCadastro,!.
optionsMenuInicial('S'):- write(''), !.
optionsMenuInicial('s'):- write(''), !.
optionsMenuInicial(_) :- writeln('Opção inválida!'), menuInicial.

menuLogin :-
    
    lerArquivo('MenuLogin.txt'),
    getUsernameLogin(Login),
    getPasswordLogin(Senha),
    (isLoginValid(Login,Senha) ->
        menuPrincipal
    ;
        nl,writeln('Login Inválido!'),menuInicial
    ).

menuCadastro:-
    lerArquivo('MenuCadastro.txt'),
    getUsernameCadastro(User),
    getnameCadastro(Nome),
    getBioCadastro(Bio),
    getPasswordCadastro(Senha),
    cadastraUsuario(Nome,User,Bio,Senha),
    menuInicial.
    


menuPrincipal :-
    lerArquivo('MenuPrincipal.txt'),
    write('Selecione uma opção: '),
    read(X),
    getUserLogged(User),
    optionsMenuPrincipal(X,User).
    
optionsMenuPrincipal('V'):- menuPerfil(User),!.
optionsMenuPrincipal('v'):- menuPerfil(User),!.
optionsMenuPrincipal('B'):- menuBusca1,!.
optionsMenuPrincipal('b'):- menuBusca1,!.
optionsMenuPrincipal('R'):- menuRecomendacao(User),!.
optionsMenuPrincipal('r'):- menuRecomendacao(User),!.
optionsMenuPrincipal('S'):- write(''), !.
optionsMenuPrincipal('s'):- write(''), !.
optionsMenuPrincipal(_) :- writeln('Opção inválida!'), menuPrincipal.

menuBusca1:-
    lerArquivo('MenuBusca1.txt'),
    write('Selecione uma opção: '),
    read(Opcao),
    optionsMenuBusca1(Opcao).

optionsMenuBusca1('F'):- menuBuscaFilme1,!.
optionsMenuBusca1('f'):- menuBuscaFilme1,!.
optionsMenuBusca1('P'):- menuBuscaPerfil,!.
optionsMenuBusca1('p'):- menuBuscaPerfil,!.
optionsMenuBusca1('V'):- menuPrincipal, !.
optionsMenuBusca1('v'):- menuPrincipal, !.
optionsMenuBusca1(_) :- writeln('Opção inválida!'), menuInicial.

menuBuscaPerfil:-
    lerArquivo('logo.txt'),
    writeNvezes(41,'='),
    getUsers(Users),
    nl,
    exibeUsuarios(Users),
    n1,
    write('Id: '),
    read(Id),
    menuBuscaPerfil2(Id,Users).

menuBuscaPerfil2(Id,Users):-
    (not(isDigit(Id)),Id <1,length(Users,Length),Id > Length ->
        nl,
        write('Index inválido'),
        menuBuscaPerfil
    ;
        nth0(Id,Users,UserEscolhido),
        getUserLogged(UserLogado),
        ( idt(UserEscolhido) = idt(UserLogado) ->
            menuPerfil(UserEscolhido)
            ;
            lerArquivo('logo.txt'),
            exibePerfil(UserEscolhido),
            writeln(''),
            writeln('(S)ELECIONAR Lista'),
            writeln('(R)ECOMENDAR Filme'),
            writeln('(V)OLTAR'),
            nl,write('Selecione uma opção: '),
            read(UserChoice),
            menuBuscaPerfil2Options(UserChoice,UserEscolhido)
        )
    ).

    