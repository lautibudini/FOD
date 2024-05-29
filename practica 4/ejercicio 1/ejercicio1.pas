{
   1. Considere que desea almacenar en un archivo la información correspondiente a los
 alumnos de la Facultad de Informática de la UNLP. De los mismos deberá guardarse
 nombre y apellido, DNI, legajo y año de ingreso. Suponga que dicho archivo se organiza
 comounárbol B de orden M.
 
 a. Defina en Pascal las estructuras de datos necesarias para organizar el archivo de
 alumnos como un árbol B de orden M.
 
 b. Suponga que la estructura de datos que representa una persona (registro de
 persona) ocupa 64 bytes, que cada nodo del árbol B tiene un tamaño de 512
 bytes y que los números enteros ocupan 4 bytes, ¿cuántos registros de persona
 entrarían en un nodo del árbol B? ¿Cuál sería el orden del árbol B en este caso (el
 valor de M)? Para resolver este inciso, puede utilizar la fórmula N = (M-1) * A + M *
 B + C, donde N es el tamaño del nodo (en bytes), A es el tamaño de un registro
 (en bytes), B es el tamaño de cada enlace a un hijo y C es el tamaño que ocupa
 el campo referido a la cantidad de claves. El objetivo es reemplazar estas
 variables con los valores dados y obtener el valor de M (M debe ser un número
 entero, ignorar la parte decimal).
 
 c. ¿Qué impacto tiene sobre el valor de M organizar el archivo con toda la
 información de los alumnos como un árbol B?
 
 d. ¿Qué dato seleccionaría como clave de identificación para organizar los
 elementos (alumnos) en el árbol B? ¿Hay más de una opción?
 
 e. Describa el proceso de búsqueda de un alumno por el criterio de ordenamiento
 especificado en el punto previo. ¿Cuántas lecturas de nodos se necesitan para
 encontrar un alumno por su clave de identificación en el peor y en el mejor de
 los casos? ¿Cuáles serían estos casos?
 
 f.
 ¿Qué ocurre si desea buscar un alumno por un criterio diferente? ¿Cuántas
 lecturas serían necesarias en el peor de los casos?
}


program ejercicio1;
const
  M = un_numero; 
Type

  alumno = record
    nombre : String[50]; 
    apellido : String[50]
    dni : longint; 
    legajo : integer; 
    ingreso: integer; 
  end; 
  
//Arbol ....
  
  tnodo = record
    hijos: array[1..M] of alumno;
    claves: array[1..M-1] of integer; 
    cantReg: integer;  
  end; 
  
  tarchivo = file of tnodo; 
  
  
// --------------------------------------
// PUNTO B:


- suponiendo que persona ocupa 64Bytes.
- cada nodo del arbol B tiene tamaño 512Bytes.
- los enteros ocupan 4Bytes.

512 = 64*(M-1) + 4(M) + 4
512 = 64M - 64 + 4M + 4
512 = 64M + 4M -60
512 = 68M -60
512 + 60 = 68M
572 = 68M
572 / 68 = M ---------------> M = 8

respuesta: 

> entran como maximo 7 registros de tipo persona, ya que es de orden 8 = [8-1]=7.
> Es de orden 8 , es lo que nos dio despejando la ecuacion. 


// --------------------------------------
// PUNTO C:


> Para mi tiene un impacto con el espacio, ya que persona ocupa 64Bytes, si no guardaramos todo 
en cada nodo y solo guardaramos un solo dato para identificarlo, entrarian mas alumnos y el orden M
seria mas grande. 

// --------------------------------------
// PUNTO D:

> Yo seleccionaria, el numero de dni y/o el numero de alumno ya que son unicos para cada persona.

// --------------------------------------
// PUNTO E:

> el mejor caso seria una lectura, ya que podria estar en la raiz.
> el peor caso serian h lecturas (h siendo la altura del arbol).

// --------------------------------------
// PUNTO F:


> si se desea buscarlo de forma diferente , se necesitarian n lecturas (en el peor caso),
 siendo n la cantidad de elementos del arbol ya que puede verse necesario recorrer todo el arbol. 

















   
