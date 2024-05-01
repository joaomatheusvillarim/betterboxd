:- set_prolog_flag(encoding, utf8).
:- consult('LeTxt.pl').
:- consult('../Util/GetInfos.pl').
:- consult('App/betterboxd.pl').
:- consult('App/Controllers/ListaController.pl').
:- consult('App/Controllers/UserController.pl').
:- consult('App/Controllers/MovieController.pl').

menuInicial :-
    lerArquivo('MenuInicial.txt'),
    getString('Selecione uma opção: ', X),
    optionsMenuInicial(X).

optionsMenuInicial(X):- atom_string('E', X), menuLogin, !.
optionsMenuInicial(X):- atom_string('e', X), menuLogin, !.
optionsMenuInicial(X):- atom_string('C', X), menuCadastro, !.
optionsMenuInicial(X):- atom_string('c', X), menuCadastro, !.
optionsMenuInicial(X):- atom_string('S', X), write(''), !.
optionsMenuInicial(X):- atom_string('s', X), write(''), !.
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
    getString('Selecione uma opção: ', X),
    getUserLogged(User),
    optionsMenuPrincipal(X,User).
    
optionsMenuPrincipal(X, User):- atom_string('V', X), menuPerfil(User),!.
optionsMenuPrincipal(X, User):- atom_string('v', X), menuPerfil(User),!.
optionsMenuPrincipal(X, User):- atom_string('B', X), menuBusca1,!.
optionsMenuPrincipal(X, User):- atom_string('b', X), menuBusca1,!.
optionsMenuPrincipal(X, User):- atom_string('R', X), menuRecomendacao(User),!.
optionsMenuPrincipal(X, User):- atom_string('r', X), menuRecomendacao(User),!.
optionsMenuPrincipal(X, User):- atom_string('S', X), write(''), !.
optionsMenuPrincipal(X, User):- atom_string('s', X), write(''), !.
optionsMenuPrincipal(_, _) :- writeln('Opção inválida!'),sleep(1.5), menuPrincipal.

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
optionsMenuBusca1(_) :- writeln('Opção inválida!'),sleep(1.5), menuInicial.

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
        write('Index inválido'),sleep(1.5),
        menuBuscaPerfil
    ).

menuBuscaPerfil2Options(X,User):- atom_string('S', X),  menuSelecaoListaBusca(User),!.
menuBuscaPerfil2Options(X,User):- atom_string('s', X), menuSelecaoListaBusca(User),!.
menuBuscaPerfil2Options(X,User):- atom_string('R', X), menuPerfilRecomendacao(User),!.
menuBuscaPerfil2Options(X,User):- atom_string('r', X), menuPerfilRecomendacao(User),!.
menuBuscaPerfil2Options(X,User):- atom_string('V', X), menuPrincipal,!.
menuBuscaPerfil2Options(X,User):- atom_string('v', X), menuPrincipal,!.
menuBuscaPerfil2Options(_,User):- writeln('Opção Inválida!'),sleep(1.5),menuBuscaPerfil,!.

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
            writeln('Index inválido'),sleep(1.5),
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
            writeln('ERROR: ID inválido'),sleep(1.5),
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
menuSelecaoListaBuscaOption(User, Lista, _ ):- writeln('Opção Inválida!'),sleep(1.5), menuSelecaoListaBusca2(User, Lista),!.

menuBuscaFilme1():-
    lerArquivo('MenuBuscaFilme.txt'),
    getString(' ', UserChoice),
    menuBuscaFilme2(UserChoice).

menuBuscaFilme2(UserChoice):-
    searchMovieByTittle(UserChoice,Movies),
    length(Movies,Tamanho),
    (Tamanho < 1 ->
        write('Nenhum retorno válido'),sleep(1.5),
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
            writeln('Index inválido'),sleep(1.5),
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
optionsMenuFilme(Movie, X):- atom_string('V', X), menuPrincipal(),!.
optionsMenuFilme(Movie, X):- atom_string('v', X), menuPrincipal(),!.
optionsMenuFilme(Movie, _ ):- writeln('Opção Inválida!'),sleep(1.5), menuFilme(Movie),!.

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

comentaFilme(User, Movie):-
    getNumberStars(S),
    getComentario(C),
    putComment(User, Movie, S, C).

menuPerfil(User):-
    lerArquivo('logo.txt'),
    exibePerfil(User, R),
    writeln(R),
    writeln('(A)DICIONAR Lista'),
    writeln('(S)ELECIONAR Lista'),
    writeln('(E)DITAR Dados'),
    writeln('(ES)TATISTICAS do Usuário'),
    writeln('(V)OLTAR'),
    getString('Selecione uma opção: ', UserChoice2),
    optionsMenuPerfil(User, Userchoice2).

optionsMenuPerfil(User, X):- atom_string('A', X), menuCriacaoLista(User), !.
optionsMenuPerfil(User, X):- atom_string('a', X), menuCriacaoLista(User), !.
optionsMenuPerfil(User, X):- atom_string('S', X), menuSelecaoLista(User), !.
optionsMenuPerfil(User, X):- atom_string('s', X), menuSelecaoLista(User), !.
optionsMenuPerfil(User, X):- atom_string('E', X), menuEdicaoUsuario(User), !.
optionsMenuPerfil(User, X):- atom_string('e', X), menuEdicaoUsuario(User), !.
optionsMenuPerfil(User, X):- atom_string('ES', X), menuEstatisticasUsuario(User), !.
optionsMenuPerfil(User, X):- atom_string('Es', X), menuEstatisticasUsuario(User), !.
optionsMenuPerfil(User, X):- atom_string('eS', X), menuEstatisticasUsuario(User), !.
optionsMenuPerfil(User, X):- atom_string('es', X), menuEstatisticasUsuario(User), !.
optionsMenuPerfil(User, X):- atom_string('V', X), menuPrincipal, !.
optionsMenuPerfil(User, X):- atom_string('v', X), menuPrincipal, !.
optionsMenuPerfil(User, _):- writeln('Opção inválida!'),sleep(1.5), menuPerfil(User), !.

menuEstatisticas(User):-
    lerArquivo('logo.txt'),
    exibeEstatisticas(User, R),
    writeln(R),
    ln,
    getString('Digite qualquer coisa para voltar: ', _ ),
    menuPerfil(User).

menuCriacaoLista(User):-
    lerArquivo('CriacaoLista.txt'),
    getString(' ', Nome),
    criaLista(User, Nome),
    menuPerfil(User).

menuSelecaoLista(User):-
    getListas(User, Listas),
    getInt('Id: ', Id),
    length(Listas, Tamanho),

    (Tamanho < 1 -> writeln('Você não possui nenhuma Lista.'),sleep(1.5), menuPerfil(User);
        (Id > Tamanho ; Id < 1 -> writeln('ERROR: Id invalido'),sleep(1.5), menuPerfil(User);
            getIndex(Listas, Id, R),
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
    getString('Selecione uma opção: ', UserChoice),
    menuSelecaoLista2Options(User, Lista, UserChoice).

menuSelecaoLista2Options(User, Lista, X):- atom_string('A', X), menuBuscaFilmeLista(User, Lista), !.
menuSelecaoLista2Options(User, Lista, X):- atom_string('a', X), menuBuscaFilmeLista(User, Lista), !.
menuSelecaoLista2Options(User, Lista, X):- atom_string('S', X), menuSelecionaFilme(User, Lista), !.
menuSelecaoLista2Options(User, Lista, X):- atom_string('s', X), menuSelecionaFilme(User, Lista), !.
menuSelecaoLista2Options(User, Lista, X):- atom_string('R', X), menuRemoveFilmeLista(User, Lista), !.
menuSelecaoLista2Options(User, Lista, X):- atom_string('r', X), menuRemoveFilmeLista(User, Lista), !.
menuSelecaoLista2Options(User, Lista, X):- atom_string('V', X), menuPrincipal(), !.
menuSelecaoLista2Options(User, Lista, X):- atom_string('v', X), menuPrincipal(), !.
menuSelecaoLista2Options(User, Lista, _):- writeln('Opção inválida!'),sleep(1.5), menuSelecaoLista2(User, Lista), !.

menuBuscaFilmeLista(User, Lista):- 
    lerArquivo('MenuBuscaFilme.txt'),
    getString(' ', UserChoice),
    menuBuscaFilme2Lista(User, Lista, UserChoice).

menuBuscaFilme2Lista(User, Lista, UserChoice):-
    searchMovieByTittle(UserChoice,Movies),
    length(Movies, Tamanho),

    (Tamanho < 1 -> writeln('Nenhum retorno válido, voltando ao Menu Principal'),sleep(1.5), menuPrincipal() ;
        showMovies(Movies, R),
        lerArquivo('MenuBuscaFilme2.txt'),
        writeln(R),
        getInt('Id: ', Id),
        (Id < 1 ; Id > Tamanho -> writeln('ERROR: Index invalido'),sleep(1.5), menuBuscaFilme2Lista(User, Lista, UserChoice);
            getIndex(Movies, Id, Resposta),
            appendMoviesToLista(User, Lista, Resposta),
            menuSelecaoLista2(User, Lista)
        )
    ).

menuSelecionaFilme(User,Lista):-
    filmes(Lista,Movies),
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
            menuSelecionaFIlme(User,Lista)
        ;
            Indice is Id -1,
            nth0(Indice,Movies,Info),
            printMovieInfo(Info),
            menuFilme(Info)
        )
    ).

menuRemoveFilmeLista(User,Lista):-
    filmes(Lista,Movies),
    length(Movies,Tamanho),
    (Tamanho = 0 ->
        nl,
        writeln('Lista Vazia, retornando ao Menu'),
        sleep(1.5),
        menuSelecaoLista2(User,Lista)
    ;
        getInt('Id: ', Id),
        (Id < 1 ; Id > Tamanho->
            nl,
            writeln('Index inválido'),
            sleep(1.5),
            menuRemoveFilmeLista(User,Lista)
        ;
            %editLista (removeMovieFromLista lista (idtM (movies !! ((read userChoice) -1))))
            %menuSelecaoLista2 usr (Data.Maybe.fromJust (getListaById (idtL lista) (getListas 0)))
            Indice is Id-1,
            nth0(Indice,Movies,Info),
            removeMovieFromLista(Lista,Info,R3),
            editLista(R3),
    
            idtl(Lista,R1),
            getListas(Listas),
            getListaById(R1,Listas,R2),
            menuSelecaoLista2(User,R2)
        )
    ).

menuEdicaoUsuario(User):-
    lerArquivo('Edicao.txt'),
    getString('Selecione uma opção: ',UserChoice),
    menuEdicaoUsuarioOptions(User,UserChoice).

menuEdicaoUsuarioOptions(User, X):- atom_string('N', X), editNome(User),!.
menuEdicaoUsuarioOptions(User, X):- atom_string('n', X), editNome(User),!.
menuEdicaoUsuarioOptions(User, X):- atom_string('B', X), editBio(User), !.
menuEdicaoUsuarioOptions(User, X):- atom_string('b', X), editBio(User), !.
menuEdicaoUsuarioOptions(User, X):- atom_string('U', X), editUsername(User), !.
menuEdicaoUsuarioOptions(User, X):- atom_string('u', X), editUsername(User), !.
menuEdicaoUsuarioOptions(User, X):- atom_string('S', X), editSenha(User), !.
menuEdicaoUsuarioOptions(User, X):- atom_string('s', X), editSenha(User), !.
menuEdicaoUsuarioOptions(User, X):- atom_string('V', X), menuPrincipal(), !.
menuEdicaoUsuarioOptions(User, X):- atom_string('v', X), menuPrincipal(), !.
menuEdicaoUsuarioOptions(User, _):- writeln('Opção inválida!'),sleep(1.5), menuPerfil(User), !.

editNome(User):-
    getnameCadastro(Nome),
    
    idt(User,Idt),Nome,user(User,Username),
    bio(User,Bio),senha(User,Senha),listas(User,Listas),
    
    createUser(Idt,Nome,Username,Bio,Senha,Listas,Usuario),
    editUser(Usuario),
    getUserBy(Idt,UserBy),
    menuPerfil(UserBy).

editBio(User):-
    getBioCadastro(Bio),
    
    idt(User,Idt),nome(User,Nome),user(User,Username),
    Bio,senha(User,Senha),listas(User,Listas),
    
    createUser(Idt,Nome,Username,Bio,Senha,Listas,Usuario),
    editUser(Usuario),
    getUserBy(Idt,UserBy),
    menuPerfil(UserBy).

editSenha(User):-
    getSenhaCadastro(Senha),
    
    idt(User,Idt),nome(User,Nome),user(User,Username),
    bio(User,Bio),Senha,listas(User,Listas),
    
    createUser(Idt,Nome,Username,Bio,Senha,Listas,Usuario),
    editUser(Usuario),
    getUserBy(Idt,UserBy),
    menuPerfil(UserBy).

editUsername(User):-
    getUsernameCadastro(Username),
    
    idt(User,Idt),nome(User,Nome),Username,
    bio(User,Bio),senha(User,Senha),listas(User,Listas),
    
    createUser(Idt,Nome,Username,Bio,Senha,Listas,Usuario),
    editUser(Usuario),
    getUserBy(Idt,UserBy),
    menuPerfil(UserBy).

menuRecomendacao(User):-
    lerArquivo('Recomendacao.txt'),
    getString('Selecione uma opção: ',UserChoice),
    menuRecomendacaoOptions(User, UserChoice).

menuRecomendacaoOptions(User, X):-  atom_string('M', X), menuRecomendacaoTop10(User),!.
menuRecomendacaoOptions(User, X):-  atom_string('m', X), menuRecomendacaoTop10(User),!.
menuRecomendacaoOptions(User, X):-  atom_string('R', X), menuRecomendacoesPersonalizadas(User),!.
menuRecomendacaoOptions(User, X):-  atom_string('r', X), menuRecomendacoesPersonalizadas(User),!.
menuRecomendacaoOptions(User, X):-  atom_string('V', X), menuPrincipal(),!.
menuRecomendacaoOptions(User, X):-  atom_string('v', X), menuPrincipal(),!.

menuRecomendacaoTop10(User):-
    lerArquivo('CatalogoFilmes.txt'),
    getInt('Selecione uma opção: ', UserChoice),
    menuRecomendacaoTop10Options(User, UserChoice).

menuRecomendacaoTop10Options(User, UserChoice):-
    (UserChoice < 1 ; UserChoice > 22 -> writeln('Error, id invalido'), sleep(1.5), menuRecomendacaoTop10(User);
        generos = ["Comedy", "Drama", "Romance", "Sci-Fi", "Horror", "Documentary", "Biography", "History" , "Adventure", "Action", "Fantasy", "Crime", "Kids & Family", "Animation", "LGBTQ+", "Musical", "War", "Mystery & Thriller", "Music", "Holiday", "Western", "Sports"],
        nth1(generos, Userchoice, GeneroEscolhido),
        getBestMoviesByGenre(GeneroEscolhido, 10, Top10),
        menuRecomendacaoTop10Exibicao(User, Top10)).

menuRecomendacaoTop10Exibicao(User, Top10):-
    lerArquivo('logo.txt'),
    writeNvezes(41,'='),
    showMovies(Top10, 1, Resposta),
    whiteln(Resposta),
    getInt('Selecione um filme: ', UserChoice),
    length(Top10, Tamanho),
    (UserChoice < 1 ; UserChoice > Tamanho -> writeln('Error, id invalido'), sleep(1.5), menuRecomendacaoTop10(User);
        nth1(Top10, UserChoice, FilmeEscolhido),
        movieInfo(FilmeEscolhido, Informacao),
        writeln(Informacao),
        menuFilme(FilmeEscolhido)).

menuRecomendacoesPersonalizadas(User):-
    lerArquivo('RecomendacoesPersonalizadas.txt'),
    writeNvezes(41,'='),
    getFavoritos(User, Favoritos),
    length(Favoritos, TamanhoFavoritos),
    (TamanhoFavoritos < 1 -> writeln('ERROR: Você não possui nenhum favorito!'), sleep(1.5), menuRecomendacao(User) ;
        getAssistidos(User, Assistidos),
        recomendaMovies(Favoritos, Assistidos, Recomendados),
        length(Recomendados, TamanhoRecomendados),
        (TamanhoRecomendados < 1 -> writeln('Nenhum filme encontrado, retornando ao Menu Principal.'), sleep(1.5), menuPrincipal();
            showMovies(Recomendados, Exibir),
            writeln(Exibir),
            getInt('Id: ', Id),
            (Id < 1 ; Id > TamanhoRecomendados -> writeln('Error, id invalido'), sleep(1.5), menuRecomendacao(User);
                nth1(Recomendados, Id, Resposta),
                movieInfo(Resposta, Info),
                whiteln(Info),
                menuFilme(Resposta))
        )
    ).





