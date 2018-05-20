## Simple imperative language interpreted in prolog

This is my, so far, biggest project in prolog. As introduction i would like to present this language BNF grammar and explain how the tokenizer,parser and interpreter works and how they are composed togheter, just to know how it all works form the inside.

### BNF GRAMMAR

```
PROGRAMME ::= 
PROGRAMME ::= INSTRUCTION | PROGRAMME

INSTRUCTION ::= IDENTIFIER := EXPRESSION
INSTRUCTION ::= read IDENTIFIER
INSTRUCTION ::= write EXPRESSION
INSTRUCTION ::= if CONDITION then PROGRAMME fi
INSTRUCTION ::= if CONDITION then PROGRAMME else PROGRAMME fi
INSTRUKCJA ::= while CONDITION do PROGRAMME od


```
