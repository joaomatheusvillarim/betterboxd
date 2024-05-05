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
    writeln('            Menu Busca Perfis            '),
    writeln('========================================='),
    exibeUsuarios(T),
    writeln(T),
    writeln('========================================='),
    getInt('Id: ', Id),
    menuBuscaPerfil2(Id, Users).

menuBuscaPerfil2(Id,Users):-
    length(Users, T),
    Tamanho is T + 1,
    (Id > 0, Id < Tamanho ->
        writeln('debugging 2'),
        nth1(Id,Users,UserEscolhido),
        getUserLogged(row(Id2, _, _, _, _, _)),
        ( Id = Id2 ->
            writeln('debugging 1'),
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

menuSelecaoListaBusca(row(Id, Username, Name, Bio, Senha, IdsLista)):-
    getListasByString(IdsLista, Lists),
    getInt('Id: ', UserChoice),
    length(Lists,Length),
    (Length < 1->
        ln,
        writeln('O usuário não possui nenhuma lista.'),
        menuBuscaPerfil
    ;
        (Length >= UserChoice,UserChoice >= 1 ->
            Indice is UserChoice -1,
            nth0(Indice,Lists,Resultado),
            menuSelecaoListaBusca2(row(Id, Username, Name, Bio, Senha, IdsLista),Resultado)

        ;
            writeln('ERROR: ID inválido'),sleep(1.5),
            menuBuscaPerfil
        )
    ).

menuSelecaoListaBusca2(row(Id, Username, Name, Bio, Senha, IdsLista), Lista) :-
    lerArquivo('logo.txt'),
    exibeLista(Lista, R),
    writeln(R),
    writeln('========================================='),
    writeln('(S)ELECIONAR Filme'),
    writeln('(V)OLTAR'),
    getAtom('Selecione uma opção: ', UserChoice),
    menuSelecaoListaBuscaOption(row(Id, Username, Name, Bio, Senha, IdsLista), Lista, UserChoice).

menuSelecaoListaBuscaOption(User, Lista, 'S'):- menuSelecionaFilme(User, Lista), !.
menuSelecaoListaBuscaOption(User, Lista, 's'):- menuSelecionaFilme(User, Lista), !.
menuSelecaoListaBuscaOption(_, _, 'V'):- menuPrincipal,!.
menuSelecaoListaBuscaOption(_, _, 'v'):- menuPrincipal,!.
menuSelecaoListaBuscaOption(User, Lista, _ ):- writeln('Opção Inválida!'),sleep(1.5), menuSelecaoListaBusca2(User, Lista),!.

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

menuRemoveFilmeLista(row(IdU, Username, Name, Bio, Senha, IdsLista),row(IdLista, Nome, Filmes)):-
    splitNumbers(Filmes, ListaFilmes),
    getMoviesByIds(ListaFilmes, Movies),

    length(Movies,Tamanho),
    (Tamanho = 0 ->
        nl,
        writeln('Lista Vazia, retornando ao Menu'),
        sleep(1.5),
        menuSelecaoLista2(row(IdU, Username, Name, Bio, Senha, IdsLista),row(IdLista, Nome, Filmes))
    ;
        getInt('Id: ', Id),
        (Id < 1 ; Id > Tamanho->
            nl,
            writeln('Index inválido'),
            sleep(1.5),
            menuRemoveFilmeLista(row(IdU, Username, Name, Bio, Senha, IdsLista),row(IdLista, Nome, Filmes))
        ;
            Indice is Id-1,
            nth0(Indice,Movies,Info),
            removeMovieFromLista(IdLista, Info),
            getLista(IdLista, R2),
            menuSelecaoLista2(row(IdU, Username, Name, Bio, Senha, IdsLista),R2)
        )
    ).

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
        writeln('Você ainda não avaliou este filme!'),
        menuFilme(Movie)
    ).

changeComentFilme(User, Movie):-
    User = row(IdUser, _, _, _, _, _),
    Movie = row(IDMovie, _, _, _, _, _, _, _),
    getNumberStars(S),
    getComentario(C),
    editComment(IdUser, IDMovie, S, C),
    menuFilme(Movie).

menuEdicaoUsuario(User):-
    lerArquivo('Edicao.txt'),
    getAtom('Selecione uma opção: ',UserChoice),
    menuEdicaoUsuarioOptions(User,UserChoice).

menuEdicaoUsuarioOptions(User, 'N'):- editNome(User),!.
menuEdicaoUsuarioOptions(User, 'n'):- editNome(User),!.
menuEdicaoUsuarioOptions(User, 'B'):- editBio(User), !.
menuEdicaoUsuarioOptions(User, 'b'):- editBio(User), !.
menuEdicaoUsuarioOptions(User, 'U'):- editUsername(User), !.
menuEdicaoUsuarioOptions(User, 'u'):- editUsername(User), !.
menuEdicaoUsuarioOptions(User, 'S'):- editSenha(User), !.
menuEdicaoUsuarioOptions(User, 's'):- editSenha(User), !.
menuEdicaoUsuarioOptions(_, 'V'):- menuPrincipal(), !.
menuEdicaoUsuarioOptions(_, 'v'):- menuPrincipal(), !.
menuEdicaoUsuarioOptions(User, _):- writeln('Opção inválida!'),sleep(1.5), menuPerfil(User), !.

editNome(row(IdU, _, _, _, _, _)):-
    getString('Insira seu novo nome: ', Edicao),
    editName(IdU, Edicao),
    getUser(IdU,UserBy),
    menuPerfil(UserBy).

editBio(row(IdU, _, _, _, _, _)):-
    getString('Insira sua nova bio: ', Edicao),
    editBio(IdU, Edicao),
    getUser(IdU,UserBy),
    menuPerfil(UserBy).

editUsername(row(IdU, _, _, _, _, _)):-
    getString('Insira seu novo Username: ', Edicao),
    editUsername(IdU, Edicao),
    getUser(IdU,UserBy),
    menuPerfil(UserBy).

editSenha(row(IdU, _, _, _, _, _)):-
    getString('Insira sua nova senha: ', Edicao),
    editSenha(IdU, Edicao),
    getUser(IdU,UserBy),
    menuPerfil(UserBy).

menuEstatisticasUsuario(User):-
    lerArquivo('logo.txt'),
    exibeEstatisticas(User, R),
    writeln(R),
    getString('Digite qualquer coisa para voltar: ', _ ),
    menuPerfil(User).

menuPerfilRecomendacao(User):-
    lerArquivo('MenuBuscaFilme.txt'),
    getString(' ', UserChoice),
    menuPerfilRecomendacao2(User,UserChoice).

menuPerfilRecomendacao2(User,UserChoice):-
    User = row(_, _, _, _, _, IdsLista),
    getListasByString(IdsLista, Listas),
    nth0(2,Listas,row(IDListaR, _, _)),
    getMovieByTitle(UserChoice,Movies),
    length(Movies, Tamanho),

    (Tamanho < 1 -> writeln('Nenhum retorno válido, voltando ao Menu Principal'),sleep(1.5), menuPrincipal() ;
        showMovies(Movies,1,FilmesSTR),
        lerArquivo('MenuBuscaFilme2.txt'),
        writeln(FilmesSTR),
        getInt('Id: ', Id),
        (Id >=1,Id =< Tamanho ->
            nth1(Id,Movies,Resposta),
            appendMovieToLista(IDListaR,Resposta),
            writeln('Filme Recomendado com sucesso'),
            sleep(1.5),
            menuBuscaPerfil
        ;
            writeln('Index inválido'),sleep(1.5),
            menuPerfilRecomendacao2(User,UserChoice)
        )
    ).

menuRecomendacao(User):-
    lerArquivo('Recomendacao.txt'),
    getAtom('Selecione uma opção: ',UserChoice),
    menuRecomendacaoOptions(User, UserChoice).

menuRecomendacaoOptions(User, 'M'):-  menuRecomendacaoTop10(User),!.
menuRecomendacaoOptions(User, 'm'):-  menuRecomendacaoTop10(User),!.
menuRecomendacaoOptions(User, 'R'):-  menuRecomendacoesPersonalizadas(User),!.
menuRecomendacaoOptions(User, 'r'):-  menuRecomendacoesPersonalizadas(User),!.
menuRecomendacaoOptions(_, 'V'):-  menuPrincipal(),!.
menuRecomendacaoOptions(_, 'v'):-  menuPrincipal(),!.

menuRecomendacaoTop10(User):-
    lerArquivo('CatalogoFilmes.txt'),
    getInt('Selecione uma opção: ', UserChoice),
    menuRecomendacaoTop10Options(User, UserChoice).

menuRecomendacaoTop10Options(User, UserChoice):-
    (UserChoice < 1 ; UserChoice > 22 -> writeln('Error, id invalido'), sleep(1.5), menuRecomendacaoTop10(User);
        Generos = ['Comedy', 'Drama', 'Romance', 'Sci-Fi', 'Horror', 'Documentary', 'Biography', 'History' , 'Adventure', 'Action', 'Fantasy', 'Crime', 'Kids & Family', 'Animation', 'LGBTQ+', 'Musical', 'War', 'Mystery & Thriller', 'Music', 'Holiday', 'Western', 'Sports'],
        nth1(UserChoice, Generos, GeneroEscolhido),
        getBestMoviesByGenre(GeneroEscolhido, Top10),
        menuRecomendacaoTop10Exibicao(User, Top10)).

menuRecomendacaoTop10Exibicao(User, Top10):-
    lerArquivo('logo.txt'),
    writeln('========================================='),
    showMovies(Top10, 1, Resposta),
    writeln(Resposta),
    getInt('Selecione um filme: ', UserChoice),
    length(Top10, Tamanho),
    (UserChoice < 1 ; UserChoice > Tamanho -> writeln('Error, id invalido'), sleep(1.5), menuRecomendacaoTop10(User);
        nth1(UserChoice, Top10, FilmeEscolhido),
        movieInfo(FilmeEscolhido, Informacao),
        menuFilme(FilmeEscolhido)).

menuRecomendacoesPersonalizadas(User):-
    User = row(_, _, _, _, _, IdsLista),
    getListasByString(IdsLista, Listas),
    nth0(0, Listas, row(_, _, FavoritosStr)),
    nth0(1, Listas, row(_, _, AssistidosStr)),
    splitNumbers(FavoritosStr, Temp1),
    getMoviesByIds(Temp1, Favoritos),
    splitNumbers(AssistidosStr, Temp2),
    getMoviesByIds(Temp2, Assistidos),

    lerArquivo('RecomendacoesPersonalizadas.txt'),
    writeln('========================================='),
    length(Favoritos, TamanhoFavoritos),
    (TamanhoFavoritos < 1 -> writeln('ERROR: Você não possui nenhum favorito!'), sleep(1.5), menuRecomendacao(User) ;
        recomendaMovies(Favoritos, Assistidos, Recomendados),
        length(Recomendados, TamanhoRecomendados),
        (TamanhoRecomendados < 1 -> writeln('Nenhum filme encontrado, retornando ao Menu Principal.'), sleep(1.5), menuPrincipal();
            showMovies(Recomendados,1, Exibir),
            writeln(Exibir),
            getInt('Id: ', Id),
            (Id < 1 ; Id > TamanhoRecomendados -> writeln('Error, id invalido'), sleep(1.5), menuRecomendacao(User);
                nth1(Id, Recomendados, Resposta),
                menuFilme(Resposta))
        )
    ).