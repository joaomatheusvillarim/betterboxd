:- set_prolog_flag(encoding, utf8).
:- consult('App/Menus/MenuManager.pl').
:- consult('App/Menus/LeTxt.pl').
%:- consult('App/Util/GetInfos.pl').

:- initialization(main).

main :- 
    menuInicial.