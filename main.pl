key(read).
key(write).
key(if).
key(then).
key(else).
key(fi).
key(while).
key(do).
key(od).
key(and).
key(or).
key(mod).

int(X,Y) :-
       atom_number(X,Y),Y >= 0.

id(ID) :-
	atom_chars(ID, L),
	uppercase_word(L).

uppercase_word([]).
uppercase_word([H|L]) :-
	char_code(H,Code),
	between(65,90,Code),
	uppercase_word(L).

sep(SEPARATOR) :-
	member(SEPARATOR, [':',';','+','-','*','/','(',')','<','>','=<','>=',':=','=','/=']).

white_space(Char) :-
	member(Char,[' ','\t','\n','\r']).

predicate(Atom, Predicate) :-
	(key(Atom) -> Predicate = key(Atom));
	(int(Atom,Number) -> Predicate = int(Number));
	(id(Atom) -> Predicate = id(Atom));
	(sep(Atom) -> Predicate = sep(Atom)).

stream_to_array(X,Chars):-
	read_string(X,_,String),
	string_chars(String,Chars),
	close(X).

scanner(X,Y) :-
	stream_to_array(X,C),
	tokenize(C,Y).

tokenize([],[]).
tokenize([H1|C],T) :-
	white_space(H1),tokenize(C,T).

tokenize([H1|C],[H2|Y]) :-
	char_type(H1,alnum),
	append_alnum([H1|C],_,CO,AO),
	predicate(AO,H2),
	tokenize(CO,Y).

tokenize([H1|C],[H2|Y]) :-
	special(H1),
	append_special([H1|C],_,CO,AO),
	predicate(AO,H2),
	tokenize(CO,Y).

append_alnum([H|C],AO,[H|C],AO):-
	not(char_type(H,alnum)).
append_alnum([H|C],A,CO,AO):-
	char_type(H,alnum),
	append_atom(A,H,A2),
	append_alnum(C,A2,CO,AO).

append_special([H|C],A,[H|C],A):-
	append_atom(A,H,A2),
	not(sep(A2)).
append_special([H|C],A,CO,AO):-
	append_atom(A,H,A2),
	sep(A2),
	append_special(C,A2,CO,AO).

append_atom(Atom1,Char,Atom2) :-
	not(var(Atom1)) ->
	atom_concat(Atom1,Char,Atom2) ;
	Atom2 = Char.

special(CHAR) :-
	char_code(CHAR,CODE),
	(between(33,47,CODE);
	between(58,63,CODE)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

program([]) -->[].
program([INSTRUKCJA | PROGRAM]) --> instrukcja(INSTRUKCJA), program(PROGRAM).

instrukcja(assign(ID,WYRAZENIE)) --> [id(ID)],[sep(:=)],wyrazenie(WYRAZENIE),[sep(;)].
instrukcja(write(WYRAZENIE)) --> [key(write)],wyrazenie(WYRAZENIE),[sep(;)].
instrukcja(read(ID)) --> [key(read),id(ID),sep(;)].
instrukcja(if(WARUNEK,PROGRAM)) --> [key(if)],warunek(WARUNEK),[key(then)],program(PROGRAM),[key(fi)],[sep(;)].
instrukcja(if(WARUNEK,PROGRAM1,PROGRAM2)) --> [key(if)],warunek(WARUNEK),[key(then)],program(PROGRAM1),[key(else)],program(PROGRAM2),[key(fi)],[sep(;)].
instrukcja(read(ID)) --> [key(read),id(ID),sep(;)].
instrukcja(while(WARUNEK,PROGRAM)) --> [key(while)],warunek(WARUNEK),[key(do)],program(PROGRAM),[key(od)],[sep(;)].

wyrazenie(WYRAZENIE) --> multdiv(WYRAZENIE).
wyrazenie(MULTDIV + WYRAZENIE2) --> multdiv(MULTDIV), [sep(+)], wyrazenie(WYRAZENIE2).
wyrazenie(MULTDIV - WYRAZENIE2) --> multdiv(MULTDIV), [sep(-)], wyrazenie(WYRAZENIE2).

multdiv(PRIMARY) --> primary(PRIMARY).
multdiv(PRIMARY * MULTDIV) --> primary(PRIMARY), [sep(*)], multdiv(MULTDIV).
multdiv(PRIMARY / MULTDIV) --> primary(PRIMARY), [sep(/)], multdiv(MULTDIV).

primary(EXPR) --> [sep('(')], wyrazenie(EXPR),[sep(')')].
primary(id(ID)) --> [id(ID)].
primary(int(NUM)) --> [int(NUM)].

warunek((KONIUNKCJA ; WARUNEK)) --> koniunkcja(KONIUNKCJA), [key(or)], warunek(WARUNEK).
warunek(KONIUNKCJA) --> koniunkcja(KONIUNKCJA).

koniunkcja((PROSTY , KONIUNKCJA)) --> prosty(PROSTY) , [key(and)], koniunkcja(KONIUNKCJA).
koniunkcja(PROSTY) --> prosty(PROSTY).

prosty(WYRAZENIE1 =:= WYRAZENIE2) --> wyrazenie(WYRAZENIE1),[sep(=:=)],wyrazenie(WYRAZENIE2).
prosty(WYRAZENIE1 =\= WYRAZENIE2) --> wyrazenie(WYRAZENIE1),[sep(/=)],wyrazenie(WYRAZENIE2).
prosty(WYRAZENIE1 < WYRAZENIE2) --> wyrazenie(WYRAZENIE1),[sep(<)],wyrazenie(WYRAZENIE2).
prosty(WYRAZENIE1 > WYRAZENIE2) --> wyrazenie(WYRAZENIE1),[sep(>)],wyrazenie(WYRAZENIE2).
prosty(WYRAZENIE1 >= WYRAZENIE2) --> wyrazenie(WYRAZENIE1),[sep(>=)],wyrazenie(WYRAZENIE2).
prosty(WYRAZENIE1 =< WYRAZENIE2) --> wyrazenie(WYRAZENIE1),[sep(=<)],wyrazenie(WYRAZENIE2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


interpreter(INSTRUKCJE) :-
	interpreter(INSTRUKCJE, []).

interpreter([], _).
interpreter([read(ID) | INSTRUKCJE], ASOC) :- !,
	read(N),
	integer(N),
	podstaw(ASOC, ID, N, ASOC1),
	interpreter(INSTRUKCJE, ASOC1).
interpreter([write(W) | INSTRUKCJE], ASOC) :- !,
	wartość(W, ASOC, WART),
	write(WART), nl,
	interpreter(INSTRUKCJE, ASOC).
interpreter([assign(ID, W) | INSTRUKCJE], ASOC) :- !,
	wartość(W, ASOC, WAR),
	podstaw(ASOC, ID, WAR, ASOC1),
	interpreter(INSTRUKCJE, ASOC1).
interpreter([if(C, P) | INSTRUKCJE], ASOC) :- !,
	interpreter([if(C, P, []) | INSTRUKCJE], ASOC).
interpreter([if(C, P1, P2) | INSTRUKCJE], ASOC) :- !,
	(   prawda(C, ASOC)
	->  append(P1, INSTRUKCJE, DALEJ)
	;   append(P2, INSTRUKCJE, DALEJ)),
	interpreter(DALEJ, ASOC).
interpreter([while(C, P) | INSTRUKCJE], ASOC) :- !,
	append(P, [while(C, P)], DALEJ),
	interpreter([if(C, DALEJ) | INSTRUKCJE], ASOC).

podstaw([], ID, N, [ID = N]).
podstaw([ID = _ | ASOC], ID, N, [ID = N | ASOC]) :- !.
podstaw([ID1 = W1 | ASOC1], ID, N, [ID1 = W1 | ASOC2]) :-
	podstaw(ASOC1, ID, N, ASOC2).

pobierz([ID = N | _], ID, N) :- !.
pobierz([_ | ASOC], ID, N) :-
	pobierz(ASOC, ID, N).

wartość(int(N), _, N).
wartość(id(ID), ASOC, N) :-
	pobierz(ASOC, ID, N).
wartość(W1+W2, ASOC, N) :-
	wartość(W1, ASOC, N1),
	wartość(W2, ASOC, N2),
	N is N1+N2.
wartość(W1-W2, ASOC, N) :-
	wartość(W1, ASOC, N1),
	wartość(W2, ASOC, N2),
	N is N1-N2.
wartość(W1*W2, ASOC, N) :-
	wartość(W1, ASOC, N1),
	wartość(W2, ASOC, N2),
	N is N1*N2.
wartość(W1/W2, ASOC, N) :-
	wartość(W1, ASOC, N1),
	wartość(W2, ASOC, N2),
	N2 =\= 0,
	N is N1 div N2.
wartość(W1 mod W2, ASOC, N) :-
	wartość(W1, ASOC, N1),
	wartość(W2, ASOC, N2),
	N2 =\= 0,
	N is N1 mod N2.

prawda(W1 =:= W2, ASOC) :-
	wartość(W1, ASOC, N1),
	wartość(W2, ASOC, N2),
	N1 =:= N2.
prawda(W1 =\= W2, ASOC) :-
	wartość(W1, ASOC, N1),
	wartość(W2, ASOC, N2),
	N1 =\= N2.
prawda(W1 < W2, ASOC) :-
	wartość(W1, ASOC, N1),
	wartość(W2, ASOC, N2),
	N1 < N2.
prawda(W1 > W2, ASOC) :-
	wartość(W1, ASOC, N1),
	wartość(W2, ASOC, N2),
	N1 > N2.
prawda(W1 >= W2, ASOC) :-
	wartość(W1, ASOC, N1),
	wartość(W2, ASOC, N2),
	N1 >= N2.
prawda(W1 =< W2, ASOC) :-
	wartość(W1, ASOC, N1),
	wartość(W2, ASOC, N2),
	N1 =< N2.
prawda((W1, W2), ASSOC) :-
	prawda(W1, ASSOC),
	prawda(W2, ASSOC).
prawda((W1; W2), ASSOC) :-
	(   prawda(W1, ASSOC),
	    !
	;   prawda(W2, ASSOC)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

wykonaj(NazwaPliku):-
	open(NazwaPliku,read,X),scanner(X,Y),phrase(program(PROGRAM),Y),interpreter(PROGRAM).
