# Migração Projeto Funcional para Projeto Lógico

### Betterboxd - 0/8
- [ ] cadastraUsuario
- [ ] isLoginValid
- [ ] doLogin
- [ ] commentMovie
- [ ] changeComment
- [ ] printMovieInfo
- [ ] verificaComentario
- [ ] criaLista

## CONTROLLER
### ListaController - 14/14
- [x] stringToLista
- [x] listaToString
- [x] matrizToLista
- [x] getListas
- [x] createListaData
- [x] appendMovieToLista
- [x] getListaById
- [x] getListasById
- [x] listasToIdL
- [x] getLastId
- [x] getLastLista
- [x] exibeListas
- [x] exibeLista
- [x] removeMovieFromLista
- [x] editLista
### MovieController - 12/23
- [X] stringToMovie
- [X] matrizToMovie
- [ ] stringToList
- [X] getMovies
- [X] getMovieById
- [X] getMoviesById
- [X] getMoviesByGenre
- [ ] getBestMoviesByGenre
- [X] getMoviesByTitle
- [ ] appendComment
- [ ] updateComment
- [ ] editComment
- [ ] commentToString
- [X] moviesToIdString
- [X] movieAtIndex
- [X] showMovies
- [X] searchMovieByID
- [X] searchMovieByTitle
- [ ] mostFrequentGenre
- [ ] secondMostFrequentGenre
- [ ] mostFrequentActor
- [ ] mostFrequentDirector
- [ ] recomendaMovies
### UserController - 11/15
- [X] stringToUser
- [X] matrizToUser
- [X] userToRow
- [X] userToString
- [X] getUsers
- [X] editUser
- [X] appendUser
- [ ] hasUsername
- [X] getUserBy
- [ ] getUserLogged
- [X] getNextIdt
- [ ] appendListaToUser
- [X] exibeUsuarios
- [X] exibePerfil
- [ ] exibeEstatisticas

## DATA - Provavel desnecessário, tendo em vista a existencia de uma biblioteca com todas funcoes em prolog.
### CsvManager - 10/10
- [x] matrizToString
- [x] writeCSV
- [x] readCSV
- [x] readUTF8
- [x] appendCSV
- [x] getRow
- [x] editMatriz
- [x] editarIndice
- [x] editarLinhaCSV
- [x] appendLinhaCSV

## MENUS
Tudo ok!

## MODELS
### Lista - 2/2
- [x] data Lista (Constructor)
- [x] createLista
### Movie - 0/2
- [x] data Movie (Constructor)
- [x] createMovie
### User - 0/2
- [x] data User (Constructor)
- [x] createUser

## UTIL
### GetInfos
Tudo ok!
### PrintUtil - 0/1
- [ ] printTxt
### SortSearch - 0/10
- [ ] merge
- [ ] halve
- [ ] msort
- [ ] searchBy
- [ ] searchsby
- [ ] removeBy
- [ ] removeFrom
- [ ] mostFrequentElement
- [ ] groupSort
- [ ] secondMostFrequentElement
### StringsOp - 0/6
- [ ] concatStrings
- [ ] splitOn
- [ ] splitList
- [ ] stringToTuples
- [ ] listaToTuples
- [ ] hGetContents2
