#!/bin/bash
# Script de inicialización

bison -yd bison.y
flex scanner.l
gcc y.tab.c lex.yy.c
rm y.tab.c y.tab.h lex.yy.c
