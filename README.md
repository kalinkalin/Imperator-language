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
SIMPLE ::= WEXPRESSION < EXPRESSION
SIMPLE ::= EXPRESSION > EXPRESSION
SIMPLE ::= EXPRESSION >= EXPRESSION
SIMPLE ::= WEXPRESSION =< EXPRESDION
SIMPLE ::= ( CONDITION )
```

This is very standard and primary BNF grammar of a simple language. The most important and difficult things in this part are terms
