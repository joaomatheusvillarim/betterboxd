:- set_prolog_flag(encoding, utf8).
:- consult('App/Menus/MenuManager.pl').
:- consult('App/Menus/LeTxt.pl').

:- initialization(main).

main :- 
    menuInicial.