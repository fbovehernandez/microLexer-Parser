%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h> 

extern char *yytext;
extern int yyleng;
extern int yylex(void);
extern void yyerror(char*);
int variable=0;
int error_sintacticoLexico = 0;
extern FILE *yyin;

// Inicializacion funciones para semantica
void analizarID();
int esMayorA32Caracteres(char *);

#define TAMLEX 32+1 
#define TAMTS 10+1

typedef struct {
        char identifi[TAMLEX];
        int t; // Segun el codigo los toma que enteros (los primeros 3 pr)
} RegTS;

RegTS TS[TAMTS] = { {"inicio", 0}, {"fin", 1}, {"leer", 2}, {"escribir", 3}, {"$", 99} }; 

typedef struct{ 
        int clase;      
        char nombre[TAMLEX];      
        // int valor;     
} REG_EXPRESION; 

REG_EXPRESION procesarID(char *);
void mostrarVector(RegTS*);
void buffer(char *);
void colocar(char * , RegTS * );
int buscar(char *, RegTS *);
void Terminar();
void Generar(char*, char*, char*, char*);
void Leer(REG_EXPRESION);
// buffer = yylval.cadena
%}

%union{
   char* cadena;
   int num;
} 

%token ASIGNACION PYCOMA SUMA RESTA PARENIZQUIERDO PARENDERECHO COMA INICIO FIN LEER ESCRIBIR FDT

%token <cadena> ID
%token <num> CONSTANTE
%%

// Gramatica sintactica para micro con algunas rutinas
// objetivo: programa FDT // {mostrarVector(TS);}
//        ;
programa: INICIO listaSentencias FIN {mostrarVector(TS);} {Terminar();}
        ;
listaSentencias: listaSentencias sentencia | sentencia
        ;
sentencia: identificador ASIGNACION expresion PYCOMA 
        | LEER PARENIZQUIERDO listaIdentificadores PARENDERECHO PYCOMA
        | ESCRIBIR PARENIZQUIERDO listaExpresiones PARENDERECHO PYCOMA
        ;
listaIdentificadores: identificador /* {Leer($1);} */ | listaIdentificadores COMA identificador 
        ;
listaExpresiones: listaExpresiones COMA expresion | expresion
        ;
expresion: expresion operadorAditivo primaria | primaria
        ; 
primaria: identificador 
        | CONSTANTE 
        | PARENIZQUIERDO expresion PARENDERECHO
        ;
operadorAditivo: SUMA | RESTA
        ;
identificador : ID {procesarID($1);} {analizarID($1);}
%%

int main(int argc, char *argv[]) {
  char *nombreArchivo = argv[1];
  // yyin declara cual es la entrada de bison y con el extern File * yyin defino a yyin como un archivo. 
  yyin = fopen(nombreArchivo, "r");
  yyparse();
  fclose(yyin);
  return 0;
}

/*
void Leer(REG_EXPRESION id) {  
    Generar("Read", id.nombre, "Entera", ""); 
} 
*/

void Terminar() {  /* Genera la instruccion para terminar la ejecucion del programa */ 
   printf("\n");
   Generar("Detiene", "", "", ""); 
} 

// Co -> Codigo de operacion, a y b son opereandos y c donde se guarda el resultado. 

void Generar(char * co, char * a, char * b, char * c) {  
     /* Produce la salida de la instruccion para la MV por stdout */  
     printf("%s %s%c%s%c%s\n", co, a, ',', b, ',', c); 
} 

REG_EXPRESION procesarID(char * unIdentif) {
  REG_EXPRESION reg; 
  buffer(unIdentif); // yylval.cadena
  // Aparte, retorna reg del ids que cargo si no estaba. 
  reg.clase = 4; 
  strcpy(reg.nombre, yylval.cadena); 
  return reg;
}

void mostrarVector(RegTS * TS) {
  if(error_sintacticoLexico != 1) { 
        for (int i = 0; i < TAMTS; ++i) {
        printf("%s ", TS[i].identifi);
        }
  }  
}       

// Entera es el unico tipo de dato de micro. 
void buffer(char *s) {
        if(!buscar(s,TS)) {
            colocar(s, TS);  
            Generar("Declara", s, "Entera", "");
        }
}

int buscar(char *id, RegTS * TS) {
    // Aca el codigo en c de ASDR hace una asignacion al token pero no le vi la funcionalidad para este caso
    int i = 0;
     while ( strcmp("$", TS[i].identifi) ) {   
        if ( !strcmp(id, TS[i].identifi) )  {    
               return 1;    
        }   
        i++;  
        }  
        return 0; 
} 

void colocar(char * id, RegTS * TS) {
     int i = 4;  
     //  
     while ( strcmp("$", TS[i].identifi) ) i++;   
     if ( i < 999 ) { // cantidad de tokens posibles?   
        strcpy( TS[i].identifi, id );   TS[i].t = 4;   strcpy(TS[++i].identifi, "$" );          
        } 
} 

void yyerror (char *s){
  error_sintacticoLexico = 1;
  printf ("el error fue: %s\n", s);
  exit(1); // Sale y no sigue evaluando
}

void analizarID() {
    if(esMayorA32Caracteres(yylval.cadena)){
        yyerror("Semantico, el identificador tiene mas de 32 caracteres");
        exit(1);
    }            
}

int esMayorA32Caracteres(char *unIdentif){
    if(strlen(unIdentif) > 32) return 1; 
    return 0;
}

int yywrap()  {
  return 1;  
} 