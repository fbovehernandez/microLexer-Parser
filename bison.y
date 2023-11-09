%{
#include <stdio.h>
#include <stdlib.h> 
#include <math.h>

extern char *yytext;
extern int yyleng;
extern int yylex(void);
extern void yyerror(char*);
int variable=0;

// Inicializacion funciones para semantica
void leer(char * unIdentif);
// void asignar();
void comenzar();
void terminar();

%}

%union{
   char* cadena;
   int num;
} 

%token ASIGNACION PYCOMA SUMA RESTA PARENIZQUIERDO PARENDERECHO COMA INICIO FIN FDT LEER ESCRIBIR

%token <cadena> ID
%token <num> CONSTANTE
%%

// Gramatica sintactica para micro con algunas rutinas
objetivo: programa FDT {terminar();}
        ;
programa: {comenzar();} INICIO listaSentencias FIN
        ;
listaSentencias: listaSentencias sentencia | sentencia
        ;
sentencia: ID {leer($1);} ASIGNACION expresion /* {asignar($1, $3);}*/ PYCOMA 
        | LEER PARENIZQUIERDO listaIdentificadores PARENDERECHO PYCOMA 
        | ESCRIBIR PARENIZQUIERDO listaExpresiones PARENDERECHO PYCOMA
        ;
listaIdentificadores: listaIdentificadores COMA ID {leer($3);} | ID {leer($1);} // {leer($3);} <- Porque eso no funciona
        ;
listaExpresiones: listaExpresiones COMA expresion | expresion
        ;
expresion: expresion operadorAditivo primaria | primaria
        ; 
primaria: ID {printf("La cantidad de caracteresssss es: %d",yyleng);}
        |CONSTANTE {printf("valores %d %d",atoi(yytext),$1); }
        |PARENIZQUIERDO expresion PARENDERECHO
        ;
operadorAditivo: SUMA | RESTA
        ;
%%

int main() {
  yyparse();
}

// Implementacion para ver como funcaba yylval
void leer(char * unIdentif) {
  printf("La cantidad de caracteres es: %d", yyleng);
  if(yyleng > 4) yyerror("metiste la pata");
}

void terminar() {
 /* Genera la instruccion para terminar la ejecucion del programa */
 // Generar("Detiene", "", "", ""); 
}

void comenzar() {
  // Incializaciones semanticas ?
}

void yyerror (char *s){
  printf ("mi error es %s\n",s);
}

int yywrap()  {
  return 1;  
} 
