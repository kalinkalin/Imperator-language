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

