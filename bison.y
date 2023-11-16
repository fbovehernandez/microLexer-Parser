%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h> 
#include <math.h>

extern char *yytext;
extern int yyleng;
extern int yylex(void);
extern void yyerror(char*);
int variable=0;
extern FILE *yyin;

// Inicializacion funciones para semantica
void max32Caracteres();
int esMayorA32Caracteres(char *);

#define TAMLEX 32+1 

typedef struct {
        char identifi[TAMLEX];
        int t; // Segun el codigo los toma que enteros (los primeros 3 pr)
} RegTS;

RegTS TS[10] = { {"inicio", 0}, {"fin", 1}, {"leer", 2}, {"escribir", 3}, {"$", 99} };  // El ID seria 4 -> Las otras son pr y el 99 supongo que es un caracter que usa para poder agregar despues el valor al final de la tabla. 

typedef struct{ 
        int clase;      
        char nombre[TAMLEX];      
        // int valor;     
} REG_EXPRESION; 

REG_EXPRESION procesarID(char *);
void mostrarVector(RegTS* );
void buffer(char *);
void colocar(char * , RegTS * );

// buffer = yylval.cadena
%}

%union{
   char* cadena;
   int num;
} 

%token ASIGNACION PYCOMA SUMA RESTA PARENIZQUIERDO PARENDERECHO COMA INICIO FIN LEER ESCRIBIR

%token <cadena> ID
%token <num> CONSTANTE
%%

// Gramatica sintactica para micro con algunas rutinas
// Falta agregar el fdt? -> como token
programa: INICIO listaSentencias FIN {mostrarVector(TS);}
        ;
listaSentencias: listaSentencias sentencia | sentencia
        ;
sentencia: identificador ASIGNACION expresion PYCOMA 
        | LEER PARENIZQUIERDO listaIdentificadores PARENDERECHO PYCOMA 
        | ESCRIBIR PARENIZQUIERDO listaExpresiones PARENDERECHO PYCOMA
        ;
listaIdentificadores: listaIdentificadores COMA identificador | identificador
        ;
listaExpresiones: listaExpresiones COMA expresion | expresion
        ;
expresion: expresion operadorAditivo primaria | primaria
        ; 
primaria: identificador
        | PARENIZQUIERDO expresion PARENDERECHO
        ;
operadorAditivo: SUMA | RESTA
        ;
identificador : ID {procesarID($1);} {max32Caracteres($1);}
%%

int main() {
  // Funca bien, yyin declara cual es la entrada de bison y con el extern File * yyin defino a yyin como un archivo, no se si ya esta definido por default en bison. 
  FILE *archivo = fopen("archivo.txt", "r");
  yyin = archivo;
  yyparse();
  fclose(archivo);
  return 0;
}

REG_EXPRESION procesarID(char * unIdentif) {
  REG_EXPRESION reg; 
  buffer(unIdentif); // yylval.cadena ?
  // mostrarVector(TS);
  // Aparte, retorna reg del ids que cargo si no estaba. 
  reg.clase = 4; 
  strcpy(reg.nombre, yylval.cadena); 
  return reg;
}

void mostrarVector(RegTS * TS) {
    // 1000 primeros
    for (int i = 0; i < 15; ++i) {
        printf("%s ", TS[i].identifi);
    }
}       

void buffer(char *s) {
        // No hay previa validacion de si ya esta en la tabla
        colocar(s, TS);
}

void colocar(char * id, RegTS * TS) {
     int i = 4;  // Supongo que es valor numerico del ids
     //  
     while ( strcmp("$", TS[i].identifi) ) i++;   
     if ( i < 999 ) { // cantidad de tokens posibles?   
        strcpy( TS[i].identifi, id );   TS[i].t = 4;   strcpy(TS[++i].identifi, "$" );          
        } 
} 

// Implementacion para ver como funcaba yylval
void yyerror (char *s){
  printf ("mi error es %s\n", s);
}

void max32Caracteres() {
    if(esMayorA32Caracteres(yylval.cadena)){
        yyerror("Error Semantico, el identificador tiene mas de 32 caracteres");
    }            
}

int esMayorA32Caracteres(char *unIdentif){
    if(strlen(unIdentif) > 4) return 1; //> 32, 4 para probar. 
    return 0;
}

int yywrap()  {
  return 1;  
} 
