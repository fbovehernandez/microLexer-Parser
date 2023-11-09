%{
	#include <stdio.h>
	#include <stdlib.h>
	#include "y.tab.h"
%}
DIGITO [0-9]

LETRA [a-zA-Z]

IDENTIFICADOR {LETRA}({LETRA}|{DIGITO})*

constEntera {DIGITO}({DIGITO})*
%%
"inicio" {return INICIO;}
"leer" {return LEER;}
"escribir" {return ESCRIBIR;}
":=" {return ASIGNACION;}
{constEntera} {yylval.num = atoi(yytext); return CONSTANTE;}
{IDENTIFICADOR} {yylval.cadena = strdup(yytext); return ID;}
";" {return PYCOMA;}
"(" {return PARENIZQUIERDO;}
")" {return PARENDERECHO;}
"+" {return SUMA;}
"fin" {return FIN;}
"-" {return RESTA;}
"," {return COMA;}
[ \t\n]  ; 
. { printf(stderr, "Error léxico: Caracter no válido '%s'\n", yytext); return -1;} // stderr -> canal de error standard
%%
