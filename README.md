## Resumen Practico 📝

### Arboles B 🌳

 - Cosas a tener en cuenta: 
 >      1. Cada nodo del árbol puede contener como máximo M descendientes directos (hijos) y M-1 elementos.
 >      2. La raíz no posee descendientes directos o tiene al menos dos.
 >      3. Un nodo con X descendientes directos contiene X-1 elementos.
 >      4. Todos los nodos (salvo la raíz) tienen como mínimo [M/2] – 1 (Parte entera) elementos y como máximo M-1 elementos.

 - Conceptos : 

 1. Overflow : 
 > Esto pasa al momento de dar de alta un elemento en el arbol,donde este elem debe ir en un nodo y no entra, a esto se le llama overflow. El nodo no posee espacio para otro elemento.
 
 > Solucion: 
  Division y promocion, lo que hacemos es juntar todos los elementos junto con el nuevo, luego de esto dividimos creando un nuevo nodo dejando la mitad entera en el primer nodo y la otra mitad en el nuevo. Luego de esto hacemos la promocion del primer elemento del primer nodo (por convención). Esto puede propagar el overflow al nodo padre pero se trata de la misma forma. EJ: 

Acá al agregar el 80, se genera overflow en el nodo (1) , por lo que debemos dividir creando un nuevo nodo y promocionando el primer elemento de ese nuevo nodo. (75,80) (88,91).
![](https://github.com/lautibudini/FOD/blob/main/images-readme/Captura%20de%20pantalla%202024-05-14%20215545.png)


Una vez que promocionamos en este caso el elem = 88 al nodo (2) debemos acomodar sus elementos y 'ordenar' sus hijos: 
![](https://github.com/lautibudini/FOD/blob/main/images-readme/Captura%20de%20pantalla%202024-05-14%20215621.png)


2. Bajas: 
> Si la clave a eliminar no está en una hoja, se debe reemplazar con la menor clave del subárbol derecho.

> En caso que el nodo a eliminar sea hoja y eliminando ese elemento posee los minimos elementos ([M/2]-1), se elimina sin problema. Caso contrario se produce underflow.


- Underflow: 
> Primero se intenta redistribuir con un hermano adyacente, es decir se junta el hermano adyacente, elemento 'padre' y el que produce undeflow y se hace un tipo de 'division y promoción' (todo en el nodo que genera undeflow). 

> Si la redistribución no es posible, entonces se debe fusionar con el hermano adyacente, juntando los valores y reacomodando todo. 
- Politicas de underflow:
 > . Política izquierda: se intenta redistribuir con el hermano adyacente izquierdo, si no es posible, se fusiona con hermano adyacente izquierdo.
 
 >. Política derecha: se intenta redistribuir con el hermano adyacente derecho, si no es posible, se fusiona con hermano adyacente derecho.
 
 > . Política izquierda o derecha: se intenta redistribuir con el hermano adyacente izquierdo, si no es posible,  se intenta con el hermano adyacente derecho, si tampoco es posible, se fusiona con hermano adyacente izquierdo.

 >. Política derecha o izquierda: se intenta redistribuir con el hermano adyacente derecho, si no es posible,  se intenta con el hermano adyacente izquierdo, si tampoco es posible, se fusiona con hermano adyacente derecho.

> Casos especiales: en cualquier política si se tratase de un nodo hoja de un extremo del árbol debe intentarse redistribuir con el hermano adyacente que el mismo posea si no se puede aplicar su politica especificada.




ejemplos: 
- Redistribuir politica der o izq underflow: 

> La eliminación de la clave 70 en el nodo 1 produce underflow.
Se intenta redistribuir con el hermano derecho. No es posible ya que el nodo contiene la cantidad mínima de claves. 
Se intenta redistribuir con el hermano izquierdo. La operación es posible y se rebalancea la carga entre los nodos 1 y 0.

![](https://github.com/lautibudini/FOD/blob/main/images-readme/Captura%20de%20pantalla%202024-05-14%20224859.png)

![](https://github.com/lautibudini/FOD/blob/main/images-readme/Captura%20de%20pantalla%202024-05-14%20224912.png)

-  Concatenar con misma politica : 
> el 86, no se puede balancear con su adyacente entonces se fusiona el nodo en underflow con su adyacente. Así liberando el nodo (5) y solucionando el undeflow generado.

![](https://github.com/lautibudini/FOD/blob/main/images-readme/Captura%20de%20pantalla%202024-05-14%20225416.png)

![](https://github.com/lautibudini/FOD/blob/main/images-readme/Captura%20de%20pantalla%202024-05-14%20225436.png)

> Otro ejemplo donde se propaga el underflow y llega hasta la raiz, donde se deben reacomodar los hijos : 
> al querer elimarse el elem(95) genera underflow, y al no poder redistribuir, concatenamos en el nodo mismo(4) los elementos (96,120) Liberando el nodo(3) pero generando undeflow en el nodo 6, entonces concatenamos el padre y hermano adyacente en el nodo(2)? y reacomodando los hijos.

![](https://github.com/lautibudini/FOD/blob/main/images-readme/Captura%20de%20pantalla%202024-05-14%20225520.png)

![](https://github.com/lautibudini/FOD/blob/main/images-readme/Captura%20de%20pantalla%202024-05-14%20225534.png)

3. Escrituras y lecturas:
   > Es muy importante el orden de lecturas y escrituras.

   > En las lecturas se arranca desde la raiz, y puede variar en casos de tener que leer mas nodos por alguna alta o baja ( un nodo no puede leerse dos veces, ya con leerlo una vez queda ).

   > Las escrituras siempre son de derecha a izquierda y desde el ultimo nivel a la raiz. 


..... En proceso 🙇🏻🙇🏻

### Arboles B+ 

cosas a tener en cuenta : 

las propiedades de cada nodo.........

> La operación de búsqueda en árboles B+ es similar a la operación de búsqueda en árboles B. El proceso es simple, ya que todas las claves se encuentran en las hojas, deberá continuarse con la búsqueda hasta el último nivel del árbol donde esta la clave real.

manejo de altas y bajas :

1. Altas.

> como se menciono los datos reales son los que estan al nivel de las hojas, y los demas son copias de los datos. Al momento de insertar un elemento este se hace al nivel de hoja, pudiendo generar overflow.

#### Overflow manejo.

> Lo que se hace es como siempre, se divide el nodo en dos, dejando la parte entera en el nodo original y la otra en un nodo nuevo. Subiendo una COPIA del valor menor del segundo nodo, se sube la copia no el dato original .

imagenes--------------------

2. Bajas.

#### Underflow manejo.

> Si al eliminar una clave, la cantidad de llaves es menor a [M/2]-1, entonces debe realizarse una redistribución de claves, tanto en el índice como en las páginas hojas.

> Si la redistribución no es posible, entonces debe realizarse una fusión entre los nodos.

POLITICAS DE RESOLUCION DE UNDERFLOW: 

>Política izquierda: se intenta redistribuir con el hermano adyacente izquierdo, si no es posible, se fusiona con hermano adyacente izquierdo.

>Política derecha: se intenta redistribuir con el hermano adyacente derecho, si no es posible, se fusiona con hermano adyacente derecho.

>Política izquierda o derecha: se intenta redistribuir con el hermano adyacente izquierdo, si no es posible,  se intenta con el hermano adyacente derecho, si tampoco es posible, se fusiona con hermano adyacente izquierdo.

>Política derecha o izquierda: se intenta redistribuir con el hermano adyacente derecho, si no es posible,  se intenta con el hermano adyacente izquierdo, si tampoco es posible, se fusiona con hermano adyacente derecho

ejemplos de underflow........



 




  
