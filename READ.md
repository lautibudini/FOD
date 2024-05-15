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
 
![imagen 1 ](../images-readme\Captura de pantalla 2024-05-14 215545.png)
![imagen 2](images-readme\Captura de pantalla 2024-05-14 215621.png)


  