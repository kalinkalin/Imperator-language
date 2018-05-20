## Simple imperative language interpreted in prolog

This is my, so far, biggest project in prolog. As introduction i would like to present this language BNF grammar and explain how the tokenizer,parser and interpreter works and how they are composed togheter, just to know how it all works form the inside.

### BNF GRAMMAR

```
PROGRAMME ::= 
PROGRAMME ::= INSTRUCTION | PROGRAMME

INSTRUCTION ::= IDENTIFIER 
```
