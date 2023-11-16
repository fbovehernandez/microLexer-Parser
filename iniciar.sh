#!/bin/bash
# Script de inicialización

bison -yd bisonBasico.y
flex flexBasico.l
gcc y.tab.c lex.yy.c -o a.exe
rm y.tab.c y.tab.h lex.yy.c
