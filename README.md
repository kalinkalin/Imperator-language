## Simple imperative language interpreted in prolog

This is my, so far, biggest project in prolog. As introduction i would like to present this language BNF grammar and explain how the tokenizer,parser and interpreter works and how they are composed togheter, just to know how it all works from the inside.

### BNF GRAMMAR

```
PROGRAMME ::=
PROGRAMME ::= INSTRUCTION ; PROGRAMME

INSTRUCTION ::= IDENTIFIER := EXPRESSION
INSTRUCTION ::= read IDENTIFIER
INSTRUCTION ::= write EXPRESSION
INSTRUCTION ::= if CONDITION then PROGRAMME fi
INSTRUCTION ::= if CONDITION then PROGRAMME else PROGRAMME fi
INSTRUCTION ::= while CONDITION do PROGRAMME od

EXPRESSION ::= COMPONENT + EXPRESSION
EXPRESSION ::= COMPONENT - EXPRESSION
EXPRESSION ::= COMPONENT

COMPONENT ::= FACTOR * COMPONENT
COMPONENT ::= FACTOR / COMPONENT
COMPONENT ::= FACTOR mod COMPONENT
COMPONENT ::= FACTOR
FACTOR ::= IDENTIFIER
FACTOR ::= NATURAL_NUMBER
FACTOR ::= ( EXPRESSION )

CONDITION ::= CONJUNCTION or CONDITION
CONDITION ::= CONJUNCTION
CONJUNCTION ::= SIMPLE and CONJUNCTION
CONJUNCTION ::= SIMPLE
SIMPLE ::= EXPRESSION = EXPRESSION
SIMPLE ::= EXPRESSION /= EXPRESSION
SIMPLE ::= EXPRESSION < EXPRESSION
SIMPLE ::= EXPRESSION > EXPRESSION
SIMPLE ::= EXPRESSION >= EXPRESSION
SIMPLE ::= WEXPRESSION =< EXPRESDION
SIMPLE ::= ( CONDITION )
```

This is very standard and primary BNF grammar of a simple language. The most important and difficult things in this part are symbols defining arithmetic operations and logic conditions. Regarding first one, ```EXPRESSION``` symbol have to preserve operator precedence while parsing arithmetic expressions. It cannot be written just like:

```
EXPRESSION --> FACTOR
EXPRESSION --> FACTOR + EXPRESSION
EXPRESSION --> FACTOR - EXPRESSION
EXPRESSION --> FACTOR * EXPRESSION
...
```
This parsing from left to right doesn't preserve the precedence, for example ```5 * 4 + 7``` where 4+7 would be done first. My approach was to go through the expression and to break up the whole expression preserving the precedence of operators, so the first terminated sub-expression would be the one with the biggest priority. This approach is very popular and well-known in simple compilers. Case of logic conditions is pretty analogous problem.

<hr>

### TOKENIZER

Programme which goal is to read char stream(programme in our language) and change this data to a tokens list. Tokens are defined smallest elements of language. There are: 
  * key words:  ```read, write, if, then, else, fi, while, do, od, and, or, mod```
  * separators:  ```; , + , - , * , / , ( , ) , < , > , =< , >= , := , = , /= ```
  * identifiers:  ```id's are uppercase letters words.```
  * integers:  ```int's are natural numbers.```

Tokenizer is giving back list of tokens wrapped in terms. So elements of this list are: key(key_word), sep(separator), id(identifier), int(integer).

For example scanning - ```read N; SUM := 0;``` would give list ```[key(read),id(N),sep(;),id(SUM),sep(:=),int(0),sep(;)]```.

<hr>

### PARSER

The goal of parser is to make whole syntax analysis and check if the given programme is well composed programme in the definition of our language. Parser also translates syntax list into list of whole operations in our language, of course if the program is syntatically correct. To achive these purposes i have used prolog utility called [definite clausule grammar(DCG)](http://www.learnprolognow.org/lpnpage.php?pagetype=html&pageid=lpn-htmlse29). 

Translating from tokens to operations is made up by adding parameters do DCG. Tokens are being wrapped into terms expressing operations. For example list of tokens - `[id(SUM),sep(:=),int(0),sep(;)]`  would be translated to a list `[assign(’SUM’, int(0))]`. 

**Another example**: 
`[key(while),id(N),sep(>),int(0),key(do),key(assign),id(N),sep(:=),id(N),sep(-),int(1),key(od),sep(;)]` 

to a list -> `[while(id(N)>int(0),[assign(N,id(N)-int(1))]]`.
