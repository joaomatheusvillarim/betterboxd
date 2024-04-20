:- set_prolog_flag(encoding, utf8).
:- consult('LeTxt.pl').
:- consult('../Util/GetInfos.pl').


menuInicial :-
    lerArquivo('MenuInicial.txt'),
    getString('Selecione uma opção: ', X),
    optionsMenuInicial(X).

optionsMenuInicial(X):- atom_string('E', X), menuLogin,!.
optionsMenuInicial(X):- atom_string('e', X), menuLogin,!.
optionsMenuInicial(X):- atom_string('C', X), menuCadastro,!.
optionsMenuInicial(X):- atom_string('c', X), menuCadastro,!.
optionsMenuInicial(X):- atom_string('S', X), write(''), !.
optionsMenuInicial(X):- atom_string('s', X), write(''), !.
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
    getString('Selecione uma opção: ', X),
    getUserLogged(User),
    optionsMenuPrincipal(X,User).
    
optionsMenuPrincipal(X):- atom_string('V', X), menuPerfil(User),!.
optionsMenuPrincipal(X):- atom_string('v', X), menuPerfil(User),!.
optionsMenuPrincipal(X):- atom_string('B', X), menuBusca1,!.
optionsMenuPrincipal(X):- atom_string('b', X), menuBusca1,!.
optionsMenuPrincipal(X):- atom_string('R', X), menuRecomendacao(User),!.
optionsMenuPrincipal(X):- atom_string('r', X), menuRecomendacao(User),!.
optionsMenuPrincipal(X):- atom_string('S', X), write(''), !.
optionsMenuPrincipal(X):- atom_string('s', X), write(''), !.
optionsMenuPrincipal(_) :- writeln('Opção inválida!'), menuPrincipal.

menuBusca1:-
    lerArquivo('MenuBusca1.txt'),
    getString('Selecione uma opção: ', Opcao),
    optionsMenuBusca1(Opcao).

optionsMenuBusca1(X):- atom_string('F', X), menuBuscaFilme1,!.
optionsMenuBusca1(X):- atom_string('f', X), menuBuscaFilme1,!.
optionsMenuBusca1(X):- atom_string('P', X), menuBuscaPerfil,!.
optionsMenuBusca1(X):- atom_string('p', X), menuBuscaPerfil,!.
optionsMenuBusca1(X):- atom_string('V', X), menuPrincipal, !.
optionsMenuBusca1(X):- atom_string('v', X), menuPrincipal, !.
optionsMenuBusca1(_) :- writeln('Opção inválida!'), menuInicial.

menuBuscaPerfil:-
    lerArquivo('logo.txt'),
    writeNvezes(41,'='),
    getUsers(Users),
    nl,
    exibeUsuarios(Users),
    n1,
    getInt('Id: ', Id),
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
            nl,
            getString('Selecione uma opção: ', UserChoice),
            menuBuscaPerfil2Options(UserChoice,UserEscolhido)
        )
    ;
        nl,
        write('Index inválido'),
        menuBuscaPerfil
    ).

menuBuscaPerfil2Options(X,User):- atom_string('S', X),  menuSelecaoListaBusca(User),!.
menuBuscaPerfil2Options(X,User):- atom_string('s', X), menuSelecaoListaBusca(User),!.
menuBuscaPerfil2Options(X,User):- atom_string('R', X), menuPerfilRecomendacao(User),!.
menuBuscaPerfil2Options(X,User):- atom_string('r', X), menuPerfilRecomendacao(User),!.
menuBuscaPerfil2Options(X,User):- atom_string('V', X), menuPrincipal,!.
menuBuscaPerfil2Options(X,User):- atom_string('v', X), menuPrincipal,!.
menuBuscaPerfil2Options(_,User):- writeln('Opção Inválida!'),menuBuscaPerfil,!.

menuPerfilRecomendacao(User):-
    lerArquivo('MenuBuscaFilme.txt'),
    getString(' ', UserChoice),
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
        getInt('Id: ', Id),
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
    getInt('Id: ', UserChoice),
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
    getString('Selecione uma opção: ', UserChoice),
    menuSelecaoListaBuscaOption(User, Lista, UserChoice).

menuSelecaoListaBuscaOption(User, Lista, X):- atom_string('S', X), menuSelecionaFilme(User, Lista), !.
menuSelecaoListaBuscaOption(User, Lista, X):- atom_string('s', X), menuSelecionaFilme(User, Lista), !.
menuSelecaoListaBuscaOption(User, Lista, X):- atom_string('V', X), menuPrincipal,!.
menuSelecaoListaBuscaOption(User, Lista, X):- atom_string('v', X), menuPrincipal,!.
menuSelecaoListaBuscaOption(User, Lista, _ ):- writeln('Opção Inválida!'), menuSelecaoListaBusca2(User, Lista),!.

menuBuscaFilme1():-
    lerArquivo('MenuBuscaFilme.txt'),
    getString(' ', UserChoice),
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
        getInt('Id: ', Id),
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
    getString('Selecione uma opção: ', UserChoice),
    optionsMenuFilme(Movie, UserChoice).

optionsMenuFilme(Movie, X):- atom_string('C', X), menuComentario(Movie), !.
optionsMenuFilme(Movie, X):- atom_string('c', X), menuComentario(Movie), !.
optionsMenuFilme(Movie, X):- atom_string('A', X), menuComentarioChange(Movie), !.
optionsMenuFilme(Movie, X):- atom_string('a', X), menuComentarioChange(Movie), !.
optionsMenuFilme(Movie, X):- atom_string('V', X), menuPrincipal,!.
optionsMenuFilme(Movie, X):- atom_string('v', X), menuPrincipal,!.

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