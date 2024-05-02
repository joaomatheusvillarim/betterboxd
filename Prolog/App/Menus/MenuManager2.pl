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

menuBusca1:-
    lerArquivo('MenuBusca1.txt'),
    getAtom('Selecione uma opção: ', Opcao),
    optionsMenuBusca1(Opcao).

optionsMenuBusca1('F'):- menuBuscaFilme1,!.
optionsMenuBusca1('f'):- menuBuscaFilme1,!.
optionsMenuBusca1('P'):- menuBuscaPerfil,!.
optionsMenuBusca1('p'):- menuBuscaPerfil,!.
optionsMenuBusca1('V'):- menuPrincipal, !.
optionsMenuBusca1('v'):- menuPrincipal, !.
optionsMenuBusca1(_) :- writeln('Opção inválida!'),sleep(1.5), menuPrincipal.

menuBuscaPerfil:-
    lerArquivo('logo.txt'),
    getUsers(Users),
    writeln('========================================='),
    exibeUsuarios(T),
    writeln(T),
    writeln('========================================='),
    getInt('Id: ', Id),
    menuBuscaPerfil2(Id, Users).

menuBuscaPerfil2(Id,Users):-
    length(Users, T),
    (Id > 0, Id < T ->
        nth1(Id,Users,UserEscolhido),
        getUserLogged(row(Id2, _, _, _, _, _)),
        ( Id = Id2 ->
            menuPerfil(UserEscolhido)
            ;
            lerArquivo('logo.txt'),
            exibePerfil(UserEscolhido, R32),
            writeln(R32),
            writeln(''),
            writeln('(S)ELECIONAR Lista'),
            writeln('(R)ECOMENDAR Filme'),
            writeln('(V)OLTAR'),
            nl,
            getAtom('Selecione uma opção: ', UserChoice),
            menuBuscaPerfil2Options(UserChoice,UserEscolhido)
        )
    ;
        nl,
        write('Index inválido'),sleep(1.5),
        menuBuscaPerfil
    ).

menuBuscaPerfil2Options('S',User):- menuSelecaoListaBusca(User),!.
menuBuscaPerfil2Options('s',User):- menuSelecaoListaBusca(User),!.
menuBuscaPerfil2Options('R',User):- menuPerfilRecomendacao(User),!.
menuBuscaPerfil2Options('r',User):- menuPerfilRecomendacao(User),!.
menuBuscaPerfil2Options('V',_):- menuPrincipal,!.
menuBuscaPerfil2Options('v',_):- menuPrincipal,!.
menuBuscaPerfil2Options(_,_):- writeln('Opção Inválida!'),sleep(1.5),menuBuscaPerfil,!.    

% CONTINUAR AQUI.

menuBuscaFilme1():-
    lerArquivo('MenuBuscaFilme.txt'),
    getString(' ', UserChoice),
    menuBuscaFilme2(UserChoice).

menuBuscaFilme2(UserChoice):-
    getMovieByTitle(UserChoice,Movies),
    length(Movies,Tamanho),

    (Tamanho < 1 ->
        write('Nenhum retorno válido'),sleep(1.5),
        menuBuscaFilme1()
    ;
    showMovies(Movies,1,FilmesSTR),
        lerArquivo('MenuBuscaFilme2.txt'),
        writeln(FilmesSTR),
        getInt('Id: ', Id),
        (Id < 1 ; Id > Tamanho -> writeln('ERROR: Index invalido'),sleep(1.5), menuBuscaFilme2(UserChoice);
            nth1(Id, Movies, Resposta),
            menuFilme(Resposta)
        ;
            nl,
            writeln('Index inválido'),sleep(1.5),
            menuBuscaFilme2(UserChoice)
        )
    ).

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
    writeln('========================================='),
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
menuSelecaoLista2Options(_, _, 'V'):- menuPrincipal(), !.
menuSelecaoLista2Options(_, _, 'v'):- menuPrincipal(), !.
menuSelecaoLista2Options(User, Lista, _):- writeln('Opção inválida!'),sleep(1.5), menuSelecaoLista2(User, Lista), !.

menuBuscaFilmeLista(User, Lista):- 
    lerArquivo('MenuBuscaFilme.txt'),
    getString(' ', UserChoice),
    menuBuscaFilme2Lista(User, Lista, UserChoice).

menuBuscaFilme2Lista(User, row(IDLista, _, _), UserChoice):-
    getMovieByTitle(UserChoice,Movies),
    length(Movies, Tamanho),

    (Tamanho < 1 -> writeln('Nenhum retorno válido, voltando ao Menu Principal'),sleep(1.5), menuPrincipal() ;
        showMovies(Movies, 1, R),
        lerArquivo('MenuBuscaFilme2.txt'),
        writeln(R),
        getInt('Id: ', Id),
        (Id < 1 ; Id > Tamanho -> writeln('ERROR: Index invalido'),sleep(1.5), menuBuscaFilme2Lista(User, row(IDLista, _, _), UserChoice);
            nth1(Id, Movies, Resposta),
            appendMovieToLista(IDLista, Resposta),
            getLista(IDLista, NovaLista),
            menuSelecaoLista2(User, NovaLista)
        )
    ).

menuSelecionaFilme(_, row(_, _, '')):-
    writeln('Lista Vazia, retornando ao Menu Principal'),
    sleep(1.5),
    menuPrincipal, !.

menuSelecionaFilme(User, row(IDLista, Nome, Filmes)):-
    splitNumbers(Filmes, ListaFilmes),
    getMoviesByIds(ListaFilmes, Movies),
    length(Movies,Tamanho),
    (Tamanho = 0 ->
        nl,
        writeln('Lista Vazia, retornando ao Menu Principal'),
        sleep(1.5),
        menuPrincipal
    ;
        getInt('Id: ', Id),
        (Id < 1 ; Id > Tamanho->
            nl,
            writeln('Index inválido'),
            sleep(1.5),
            menuSelecionaFIlme(User,row(IDLista, Nome, Filmes))
        ;
            Indice is Id -1,
            nth0(Indice,Movies,Info),
            menuFilme(Info)
        )
    ).

menuFilme(Movie):-
    movieInfo(Movie, R),
    write(R),
    writeln('(C)OMENTAR e avaliar filme'),
    writeln('(A)LTERAR comentário'),
    writeln('(V)OLTAR ao menu principal'),
    getAtom('Selecione uma opção: ', UserChoice),
    optionsMenuFilme(Movie, UserChoice).

optionsMenuFilme(Movie, 'C'):- menuComentario(Movie), !.
optionsMenuFilme(Movie, 'c'):- menuComentario(Movie), !.
optionsMenuFilme(Movie, 'A'):- menuComentarioChange(Movie), !.
optionsMenuFilme(Movie, 'a'):- menuComentarioChange(Movie), !.
optionsMenuFilme(_, 'V'):- menuPrincipal(),!.
optionsMenuFilme(_, 'v'):- menuPrincipal(),!.
optionsMenuFilme(Movie, _ ):- writeln('Opção Inválida!'),sleep(1.5), menuFilme(Movie),!.

menuComentario(Movie):-
    Movie = row(IDMovie, _, _, _, _, _, _, _),
    getUserLogged(User),
    User = row(IdUser, _, _, _, _, _),
    (not(hasComment(IdUser, IDMovie)) -> comentaFilme(User, Movie);
        writeln('Você já avaliou este filme!'),
        sleep(1),
        menuFilme(Movie)
    ).

comentaFilme(User, Movie):-
    User = row(IdUser, _, _, _, _, _),
    Movie = row(IDMovie, _, _, _, _, _, _, _),
    getNumberStars(S),
    getComentario(C),
    appendComentario(IdUser, IDMovie, S, C),
    getMovie(IDMovie, NewM),
    menuFilme(NewM).

menuComentarioChange(Movie):-
    getUserLogged(User),
    User = row(IdUser, _, _, _, _, _),
    Movie = row(IDMovie, _, _, _, _, _, _, _),
    (hasComment(IdUser, IDMovie) -> changeComentFilme(User, Movie);
        whiteln('Você ainda não avaliou este filme!'),
        menuFilme(Movie)
    ).

changeComentFilme(User, Movie):-
    User = row(IdUser, _, _, _, _, _),
    Movie = row(IDMovie, _, _, _, _, _, _, _),
    getNumberStars(S),
    getComentario(C),
    editComment(IdUser, IDMovie, S, C),
    menuFilme(Movie).