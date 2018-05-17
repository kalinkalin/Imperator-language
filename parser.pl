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





