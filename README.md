## Resumen Practico 

### Arboles b

 - Cosas a tener en cuenta: 
 >      1. Cada nodo del árbol puede contener como máximo M descendientes directos (hijos) y M-1 elementos.
 >      2. La raíz no posee descendientes directos o tiene al menos dos.
 >      3. Un nodo con X descendientes directos contiene X-1 elementos.
 >      4. Todos los nodos (salvo la raíz) tienen como mínimo [M/2] – 1 (Parte entera) elementos y como máximo M-1 elementos.

 - Conceptos : 

 1. Overflow : 
 > Esto pasa al momento de dar de alta un elemento en el arbol y este debe ir en un nodo y no entra, a esto se le llama overflow El nodo no posee espacio para otro elemento.
 
 > Solucion: 
  Division y promocion, lo que hacemos en  juntar todos los elementos junto con el nuevo, luego de esto dividimos creando un nuevo nodo dejando la mitad entera en el primer nodo y la otra mitad en el nuevo. Luego de esto hacemos la promocion del primer elemento del primer nodo (por convención). Esto puede propagar el overflow al nodo padre pero se trata de la misma forma. EJ: 

Acá al agregar el 80, se genera overflow en el nodo (1) , por lo que debemos dividir creando un nuevo nodo y promocionando el primer elemento de ese nuevo nodo. (75,80) (88,91).
![](https://github.com/lautibudini/FOD/blob/main/images-readme/Captura%20de%20pantalla%202024-05-14%20215545.png)


Una vez que promocionamos en este caso el elem = 88 al nodo (2) debemos acomodar sus elementos y 'ordenar' sus hijos: 
![](https://github.com/lautibudini/FOD/blob/main/images-readme/Captura%20de%20pantalla%202024-05-14%20215621.png)





 




  
