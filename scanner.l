%{
	#include <stdio.h>
	#include <string.h>
	#include <stdlib.h>
	#include "y.tab.h"
%}
DIGITO [0-9]
LETRA [a-zA-Z]
IDENTIFICADOR {LETRA}({LETRA}|{DIGITO})*
constEntera {DIGITO}({DIGITO})*
%%

[ \t\n] 
"inicio" {return INICIO;}
"leer" {return LEER;}
"escribir" {return ESCRIBIR;}
"fin" {return FIN;} // Si lo pongo mas abajo, por alguna razon no lo matchea
":=" {return ASIGNACION;}
{constEntera} {yylval.num = atoi(yytext); return CONSTANTE;}
{IDENTIFICADOR} {yylval.cadena = strdup(yytext); return ID;}
";" {return PYCOMA;}
"(" {return PARENIZQUIERDO;}
")" {return PARENDERECHO;}
"+" {return SUMA;}
"-" {return RESTA;}
"," {return COMA;}
. {printf("Error Lexico");}

%%
