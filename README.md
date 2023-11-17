# Trabajo Practico N3
# MicroLexer-Parser - K2055

### Integrantes : Facundo Bove Hernandez, Matias Cornalo, Santiago Perez, Santiago Invernizzi

### - Grupo 33

## Como se resolvio el problema? 
Los pasos que seguimos para la resolución del problema fueron:
1) Crear archivo flex que contiene reglas léxicas para generar los tokens que utilizaremos en nuestro programa micro. Gracias a estas reglas generamos los tokens “LEER”, “ESCRIBIR”,etc o como está compuesto un identificador o un qué valores puede tomar un dígito,etc. Estas últimas compuestas por Regex.
2) Crear archivo bison que utiliza los tokens reconocidos por nuestro archivo flex, y verifique la gramática de micro, teniendo en cuenta que en este solo tenemos un tipo de valor que es el entero.
3) Crear rutinas semánticas:
analizarID(): Verifica que la cantidad de caracteres no supere el máximo (32). Utilizando una función “esMayorA32Caracteres(char)”
procesarID(char *): Cada vez que lea un identificador, llama a una función auxiliar buffer() que verifica que ese identificador no esté en la tabla de símbolos, si lo está, no hace nada, y si no está, lo agrega, generando un registro (REG_EXPRESION) que retorna con el valor asociado(cadena) del identificador y su valor(tipo) que en este caso será 4, ya que los primeros 3 están reservados para palabras reservadas. 
mostrarVector(RegTS *): Recibe la Tabla de símbolos, y la muestra si no hubo previo error sintáctico/léxico/semántico. 
generar(char *co, char *a, char *b, char *c): La idea de esta rutina es hacer una pequeña simulación de una MV de Micro, que por algunas operaciones, vaya mostrando lo que hace. Por ejemplo : cuando se declara una variable identificador, genera la instrucción declara variable, Entera. En este caso, “Entera” es el único tipo que acepta Micro, “Declara” es el código de operación, a y b son operandos y c donde se almacena el resultado.

## Manual
Para correr el programa se ejectura iniciar.sh o en su defecto las siguientes lineas

bison -yd bison.y
flex flex.l
gcc y.tab.c lex.yy.c

Para ejecturlo el .exe, de la siguiente manera : .\a.exe .\Pruebas\"nombreArchivo".txt
Pruebas es el directorio sobre el cual se realizo el programa
