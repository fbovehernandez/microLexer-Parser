#!/bin/bash
# Script de inicialización

bison -yd bisonBasico.y
flex flexBasico.l
gcc y.tab.c lex.yy.c
rm y.tab.c y.tab.h lex.yy.c
