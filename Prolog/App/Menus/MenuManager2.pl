:- set_prolog_flag(encoding, utf8).
:- consult('LeTxt.pl').
:- consult('../Util/GetInfos2.pl').
:- consult('App/betterboxd.pl').
:- consult('App/Controllers/ListaController.pl').
:- consult('App/Controllers/UserController.pl').
:- consult('App/Controllers/MovieController.pl').

menuInicial :-
    lerArquivo('MenuInicial.txt'),
    getAtom('Selecione uma opção: ', X),
    optionsMenuInicial(X).

optionsMenuInicial('E'):- menuLogin, !.
optionsMenuInicial('e'):- menuLogin, !.
optionsMenuInicial('C'):- menuCadastro, !.
optionsMenuInicial('c'):- menuCadastro, !.
optionsMenuInicial('S'):- write(''), !.
optionsMenuInicial('s'):- write(''), !.
optionsMenuInicial(_):- writeln('Opção inválida!'),sleep(1.5), menuInicial, !.

menuLogin :- 
    lerArquivo('MenuLogin.txt'),
    getUsernameLogin(Login),
    getPasswordLogin(Senha),
    (isLoginValid(Login,Senha) ->
        doLogin(Login),
        menuPrincipal
    ;
        nl,writeln('Login Inválido!'),sleep(1.5),menuInicial
    ).

menuCadastro:-
    lerArquivo('MenuLogin.txt'),
    getUsernameCadastro(User),
    getnameCadastro(Nome),
    getBioCadastro(Bio),
    getPasswordCadastro(Senha),
    cadastraUsuario(Nome,User,Bio,Senha),
    menuInicial.

menuPrincipal :-
    lerArquivo('MenuPrincipal.txt'),
    getAtom('Selecione uma opção: ', X),
    getUserLogged(User),
    optionsMenuPrincipal(X,User).

optionsMenuPrincipal('V', User):- menuPerfil(User),!.
optionsMenuPrincipal('v', User):- menuPerfil(User),!.
optionsMenuPrincipal('B', _):- menuBusca1,!.
optionsMenuPrincipal('b', _):- menuBusca1,!.
optionsMenuPrincipal('R', User):- menuRecomendacao(User),!.
optionsMenuPrincipal('r', User):- menuRecomendacao(User),!.
optionsMenuPrincipal('S', _):- write(''), !.
optionsMenuPrincipal('s', _):- write(''), !.
optionsMenuPrincipal(_, _) :- writeln('Opção inválida!'),sleep(1.5), menuPrincipal.

menuPerfil(User):-
    lerArquivo('logo.txt'),
    exibePerfil(User, R),
    writeln(R),
    writeln('(A)DICIONAR Lista'),
    writeln('(S)ELECIONAR Lista'),
    writeln('(E)DITAR Dados'),
    writeln('(ES)TATISTICAS do Usuário'),
    writeln('(V)OLTAR'),
    nl,
    getAtom('Selecione uma opção: ', UserChoice),
    optionsMenuPerfil(User, UserChoice).

optionsMenuPerfil(User, 'A'):- menuCriacaoLista(User), !.
optionsMenuPerfil(User, 'a'):- menuCriacaoLista(User), !.
optionsMenuPerfil(User, 'S'):- menuSelecaoLista(User), !.
optionsMenuPerfil(User, 's'):- menuSelecaoLista(User), !.
optionsMenuPerfil(User, 'E'):- menuEdicaoUsuario(User), !.
optionsMenuPerfil(User, 'e'):- menuEdicaoUsuario(User), !.
optionsMenuPerfil(User, 'ES'):- menuEstatisticasUsuario(User), !.
optionsMenuPerfil(User, 'Es'):- menuEstatisticasUsuario(User), !.
optionsMenuPerfil(User, 'eS'):- menuEstatisticasUsuario(User), !.
optionsMenuPerfil(User, 'es'):- menuEstatisticasUsuario(User), !.
optionsMenuPerfil(_, 'V'):- menuPrincipal, !.
optionsMenuPerfil(_, 'v'):- menuPrincipal, !.
optionsMenuPerfil(User, _):- writeln('Opção inválida!'),sleep(1.5), menuPerfil(User), !.

menuCriacaoLista(User):-
    lerArquivo('CriacaoLista.txt'),
    getString(' ', Nome),
    criaLista(User, Nome, NovoUser),
    menuPerfil(NovoUser).

menuSelecaoLista(row(Id, Username, Name, Bio, Senha, IdsLista)):-
    User = row(Id, Username, Name, Bio, Senha, IdsLista),
    getListasByString(IdsLista, Listas),
    getInt('Id: ', Indice),
    length(Listas, Tamanho),

    (Tamanho < 1 -> writeln('Você não possui nenhuma Lista.'),sleep(1.5), menuPerfil(User);
        (Indice > Tamanho ; Indice < 1 -> writeln('ERROR: Id invalido'),sleep(1.5), menuPerfil(User);
            nth1(Indice, Listas, R),
            menuSelecaoLista2(User, R)
            )
        ).

menuSelecaoLista2(User, Lista):-
    lerArquivo('logo.txt'),
    exibeLista(Lista, E),
    writeln(E),
    writeNvezes(41,'='),
    writeln('(A)DICIONAR Filme'),
    writeln('(S)ELECIONAR Filme'),
    writeln('(R)EMOVER Filme'),
    writeln('(V)OLTAR'),
    getAtom('Selecione uma opção: ', UserChoice),
    menuSelecaoLista2Options(User, Lista, UserChoice).

menuSelecaoLista2Options(User, Lista, 'A'):- menuBuscaFilmeLista(User, Lista), !.
menuSelecaoLista2Options(User, Lista, 'a'):- menuBuscaFilmeLista(User, Lista), !.
menuSelecaoLista2Options(User, Lista, 'S'):- menuSelecionaFilme(User, Lista), !.
menuSelecaoLista2Options(User, Lista, 's'):- menuSelecionaFilme(User, Lista), !.
menuSelecaoLista2Options(User, Lista, 'R'):- menuRemoveFilmeLista(User, Lista), !.
menuSelecaoLista2Options(User, Lista, 'r'):- menuRemoveFilmeLista(User, Lista), !.
menuSelecaoLista2Options(User, Lista, 'V'):- menuPrincipal(), !.
menuSelecaoLista2Options(User, Lista, 'v'):- menuPrincipal(), !.
menuSelecaoLista2Options(User, Lista, _):- writeln('Opção inválida!'),sleep(1.5), menuSelecaoLista2(User, Lista), !.