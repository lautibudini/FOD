{
   Los árboles B+ representan una mejora sobre los árboles B dado que conservan la
 propiedad de acceso indexado a los registros del archivo de datos por alguna clave,
 pero permiten además un recorrido secuencial rápido. Al igual que en el ejercicio 2,
 considere que por un lado se tiene el archivo que contiene la información de los
 alumnos de la Facultad de Informática (archivo de datos no ordenado) y por otro lado
 se tiene un índice al archivo de datos, pero en este caso el índice se estructura como
 un árbol B+ que ofrece acceso indizado por DNI al archivo de alumnos. Resuelva los
 siguientes incisos:

a. ¿Cómo se organizan los elementos (claves) de un árbol B+? ¿Qué elementos se
 encuentran en los nodos internos y que elementos se encuentran en los nodos
 hojas?
 
b. ¿Qué característica distintiva presentan los nodos hojas de un árbol B+? ¿Por
 qué?
 
c. Defina en Pascal las estructuras de datos correspondientes para el archivo de
 alumnos y su índice (árbol B+). Por simplicidad, suponga que todos los nodos del
 árbol B+ (nodos internos y nodos hojas) tienen el mismo tamaño
 
d. Describa, con sus palabras, el proceso de búsqueda de un alumno con un DNI
 específico haciendo uso de la estructura auxiliar (índice) que se organiza como
 un árbol B+. ¿Qué diferencia encuentra respecto a la búsqueda en un índice
 estructurado como un árbol B?
 
e. Explique con sus palabras el proceso de búsqueda de los alumnos que tienen DNI
 en el rango entre 40000000 y 45000000, apoyando la búsqueda en un índice
 organizado como un árbol B+. ¿Qué ventajas encuentra respecto a este tipo de
 búsquedas en un árbol B?
   
   
}

program ejercicio3;
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
  
  lista = ^nodo;  
  nodo = record 
    hijos: array[1..M-1] of longint;
    elems: array[1..M] of integer; 
    enlaces: array[1..M-1] of integer; 
    cantReg: integer;
    sig: lista;
    end;
    
    arbol = file of nodo;



// --------------------------------------
// PUNTO B:

> En las hojas del arbol b+, se encuentran los datos 'reales', y en los nodos que no son
hojas solo hay copias para poder organizar el arbol a partir de x criterio. 

// --------------------------------------
// PUNTO D:

> La busqueda es muy similar al otro, lo que cambia es que el dato real se encuentra al 
llegar a una hoja,si existe, ya que los demas son copias que se usan para la busqueda.

// --------------------------------------
// PUNTO E:

> completar.........


