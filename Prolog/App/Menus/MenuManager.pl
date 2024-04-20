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
    (isDigit(Id),Id >=1,length(Users,Length),Id =< Length ->
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
    ;
        nl,
        write('Index inválido'),
        menuBuscaPerfil
    ).

menuBuscaPerfil2Options('S',User):- menuSelecaoListaBusca(User),!.
menuBuscaPerfil2Options('s',User):- menuSelecaoListaBusca(User),!.
menuBuscaPerfil2Options('R',User):- menuPerfilRecomendacao(User),!.
menuBuscaPerfil2Options('r',User):- menuPerfilRecomendacao(User),!.
menuBuscaPerfil2Options('V',User):- menuPrincipal,!.
menuBuscaPerfil2Options('v',User):- menuPrincipal,!.
menuBuscaPerfil2Options(_,User):- writeln('Opção Inválida!'),menuBuscaPerfil,!.

menuPerfilRecomendacao(User):-
    lerArquivo('MenuBuscaFilme.txt'),
    read(UserChoice),
    menuPerfilRecomendacao2(User,UserChoice).

menuPerfilRecomendacao2(User,UserChoice):-
    searchMovieByTittle(UserChoice,Movies),
    length(Movies,Tamanho),
    (Tamanho <1 ->
        write('Nenhum retorno válido'),
        menuPerfilRecomendacao(User)
    ;
        showMovies(Movies,1,FilmesSTR),
        lerArquivo('MenuBuscaFilme2.txt'),
        writeln(FilmesSTR),
        write('Id: '),
        read(Id),
        (isDigit(Id),Id >=1,Id =< Tamanho ->
            lista(User,Lista),
            nth0(2,Lista,Resultado1),
            Escolha is UserChoice -1,
            nth0(Escolha,Movies,Resultado2),
            appendMovieToLista(Resultado1,Resultado2),
            write('Filme Recomendado com sucesso'),
            menuBuscaPerfil
        ;
            nl,
            writeln('Index inválido'),
            menuPerfilRecomendacao2(User,UserChoice)
        )
    ).

menuSelecaoListaBusca(User):-
    listas(User,Lists),
    writeln('Id: '),
    read(UserChoice),
    length(Lists,Length),
    (Length < 1->
        ln,
        writeln('O usuário não possui nenhuma lista.'),
        menuBuscaPerfil
    ;
        (isDigit(UserChoice),Length >= UserChoice,UserChoice >= 1 ->
            Indice is UserChoice -1,
            nth0(Indice,Lists,Resultado),
            menuSelecaoListaBusca2(User,Resultado)

        ;
            writeln('ERROR: ID inválido'),
            menuBuscaPerfil
        )
    ).

menuSelecaoListaBusca2(User, Lista) :-
    lerArquivo('logo.txt'),
    writeNvezes(41,'='),
    writeln('(S)ELECIONAR Filme'),
    writeln('(V)OLTAR'),
    writeln('Selecione uma opção: ')
    read(UserChoice),
    menuSelecaoListaBuscaOption(User, Lista, UserChoice).

menuSelecaoListaBuscaOption(User, Lista, 'S'):- menuSelecionaFilme(User, Lista), !.
menuSelecaoListaBuscaOption(User, Lista, 's'):- menuSelecionaFilme(User, Lista), !.
menuSelecaoListaBuscaOption(User, Lista, 'V'):- menuPrincipal,!.
menuSelecaoListaBuscaOption(User, Lista, 'v'):- menuPrincipal,!.
menuSelecaoListaBuscaOption(User, Lista, _ ):- writeln('Opção Inválida!'), menuSelecaoListaBusca2(User, Lista),!.

menuBuscaFilme1():-
    lerArquivo('MenuBuscaFilme.txt'),
    read(UserChoice),
    menuBuscaFilme2 (UserChoice).

menuBuscaFilme2(UserChoice):-
    searchMovieByTittle(UserChoice,Movies),
    length(Movies,Tamanho),
    (Tamanho < 1 ->
        write('Nenhum retorno válido'),
        menuBuscaFilme1()
    ;
    showMovies(Movies,1,FilmesSTR),
        lerArquivo('MenuBuscaFilme2.txt'),
        writeln(FilmesSTR),
        write('Id: '),
        read(Id),
        (isDigit(Id),Id >=1,Id =< Tamanho ->
            Escolha is UserChoice -1,
            nth0(Escolha,Movies,MovieEscolhido),
            menuFilme(MovieEscolhido)
        ;
            nl,
            writeln('Index inválido'),
            menuBuscaFilme2(UserChoice)
        )
    ).


menuFilme(Movie):-
    printMovieInfo(Movie),
    writeln('(C)OMENTAR e avaliar filme'),
    writeln('(A)LTERAR comentário'),
    writeln('(V)OLTAR ao menu principal'),
    writeln('Selecione uma opção: '),
    read(UserChoice),
    optionsMenuFilme(Movie, UserChoice).

optionsMenuFilme(Movie, 'C'):- menuComentario(Movie), !.
optionsMenuFilme(Movie, 'c'):- menuComentario(Movie), !.
optionsMenuFilme(Movie, 'A'):- menuComentarioChange(Movie), !.
optionsMenuFilme(Movie, 'a'):- menuComentarioChange(Movie), !.
optionsMenuFilme(Movie, 'V'):- menuPrincipal,!.
optionsMenuFilme(Movie, 'v'):- menuPrincipal,!.

menuComentario(Movie):-
    userLogged(User),
    (verificaCommentUnico(User, Movie) -> comentaFilme(User, Movie);
        whiteln('Você já avaliou este filme!'),
        menuFilme(Movie)
    ).

menuComentarioChange(Movie):-
    userLogged(User),
    (not(verificaCommentUnico(User, Movie)) -> comentaFilme(User, Movie);
        whiteln('Você ainda não avaliou este filme!'),
        menuFilme(Movie)
    ).