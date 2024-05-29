{
    2. Una mejora respecto a la solución propuesta en el ejercicio 1 sería mantener por un
 lado el archivo que contiene la información de los alumnos de la Facultad de
 Informática (archivo de datos no ordenado) y por otro lado mantener un índice al
 archivo de datos que se estructura como un árbol B que ofrece acceso indizado por
 DNI de los alumnos.
 
 a. Defina en Pascal las estructuras de datos correspondientes para el archivo de
 alumnos y su índice.
 
 b. Suponga que cada nodo delárbol B cuenta con un tamaño de 512 bytes. ¿Cuál
 sería el orden del árbol B (valor de M) que se emplea como índice? Asuma que
 los números enteros ocupan 4 bytes. Para este inciso puede emplear una fórmula
 similar al punto 1b, pero considere además que en cada nodo se deben
 almacenar los M-1 enlaces a los registros correspondientes en el archivo de
 datos.
 
 c. ¿Quéimplica que el orden del árbol B sea mayor que en el caso del ejercicio 1?
 
 d. Describa con sus palabras el proceso para buscar el alumno con el DNI 12345678
 usando el índice definido en este punto.
 
 e. ¿Qué ocurre si desea buscar un alumno por su número de legajo? ¿Tiene sentido
 usar el índice que organiza el acceso al archivo de alumnos por DNI? ¿Cómo
 haría para brindar acceso indizado al archivo de alumnos por número de legajo?
 
 f.
 Suponga que desea buscar los alumnas que tienen DNI en el rango entre
 40000000 y 45000000. ¿Qué problemas tiene este tipo de búsquedas con apoyo
 de unárbol B que solo provee acceso indizado por DNI al archivo de alumnos? 
   
}
program ejercicio2;
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
  
  archivo = file of alumno; 
  
//Arbol ....
  
  tnodo = record
    hijos: array[1..M] of integer;
    claves: array[1..M-1] of integer; 
    enlaces: array[1..M-1] of integer; 
    cantReg: integer;  
  end; 
  
  tarchivo = file of tnodo; 


// --------------------------------------
// PUNTO B:

- usando la formula anterior (N = (M-1) * A + M * B + C) se deberia agregar el vector de enlaces,
pero aca lo que cambia tambien es lo que ocupa un registro ahora: 

> 512 = 4*(M-1) + 4(M) + 4 + 4*(M-1)
> 512 = 4M - 4 + 4M + 4 + 4M -4
> 512 = 4M + 4M + 4M - 4
> 512 = 12M -4
> 512 + 4 = 12M
> 516 / 12 = M --------------------> M = 43

res : el arbol seria de orden 43, con 42 claves maximas cada nodo.


// --------------------------------------
// PUNTO C:

> significa que con respecto al anterior, por cada nodo aumenta el numero de claves por nodo, 
y que el arbol a comparacion del anterior va a ser mas chico en altura pero mas ancho por la cant
de claves por nodo.

// --------------------------------------
// PUNTO D:

> lo que se hace es buscar la clave 12345678 en cada nodo, comparando si es menor a las claves 
en ese nodo, al no encontrarla o encontrar una mayor se fija de ir hacia la izq o derecha dependiendo
del valor. Hasta encontrarla o llegar a una hoja, y si se encuentra usando ese enlace. 

// --------------------------------------
// PUNTO E:

> No tendria sentido buscar por dni ya que se deberia buscar por cada alumno si coincide su numero
de legajo con el puesto a buscar. Lo mejor seria organizar el arbol por numero de legajo   
y asi que la busqueda sea mas eficiente. 

// --------------------------------------
// PUNTO F:

> preguntar........
