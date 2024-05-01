:- set_prolog_flag(encoding, utf8).
:- consult('App/Menus/MenuManager2.pl').
:- consult('App/Menus/LeTxt.pl').
:- consult('App/Util/GetInfos2.pl').

:- initialization(main).

main :- 
    menuInicial().