{
   
Se cuenta con un archivo con información de las diferentes distribuciones de linux
existentes. De cada distribución se conoce: nombre, año de lanzamiento, número de
versión del kernel, cantidad de desarrolladores y descripción. El nombre de las
distribuciones no puede repetirse. Este archivo debe ser mantenido realizando bajas
lógicas y utilizando la técnica de reutilización de espacio libre llamada lista invertida.
   
   
Escriba la definición de las estructuras de datos necesarias y los siguientes
procedimientos:
* 
a. ExisteDistribucion: módulo que recibe por parámetro un nombre y devuelve
verdadero si la distribución existe en el archivo o falso en caso contrario.
* 
b. AltaDistribución: módulo que lee por teclado los datos de una nueva
distribución y la agrega al archivo reutilizando espacio disponible en caso
de que exista. (El control de unicidad lo debe realizar utilizando el módulo
anterior). En caso de que la distribución que se quiere agregar ya exista se
debe informar “ya existe la distribución”.
* 
c. BajaDistribución: módulo que da de baja lógicamente una distribución 
cuyo nombre se lee por teclado. Para marcar una distribución como
borrada se debe utilizar el campo cantidad de desarrolladores para
mantener actualizada la lista invertida. Para verificar que la distribución a
borrar exista debe utilizar el módulo ExisteDistribucion. En caso de no existir
se debe informar “Distribución no existente”.
   
}
program linux;
const
  valorAlto = 'ZZZZ';
type

  distribucion = record
    nombre: String; 
    anioLanzamiento : integer; 
    versionKernel: integer; 
    cantDesarrolladores : integer; 
    descripcion : String; 
  end; 

  archivo = file of distribucion; 


// PROCEDIMIENTOS AUXILIARES.

procedure leerReg(var reg : distribucion);
begin
  writeln(' Ingrese el nombre de distribucion de linux : ');
  readln(reg.nombre);
  if ( reg.nombre <> valorAlto)then
    begin
      writeln(' Ingrese el año de lanzamiento de la  distribucion de linux : ');
      readln(reg.anioLanzamiento);
      writeln(' Ingrese la version de kernel: ');
      readln(reg.versionKernel);
      writeln(' Ingrese la cantidad de desarrolladores : ');
      readln(reg.cantDesarrolladores);
      writeln(' Ingrese la descripcion : ');
      readln(reg.descripcion);
    end; 
end; 

procedure crearArchivo(var archivo : archivo);
var
  reg : distribucion; 
begin
  writeln('--- creacion del archivo ----');
  rewrite(archivo);
  // Utilizo el primer reg como cabecera de la lista invertida. 
  reg.cantDesarrolladores:=0;
  write(archivo,reg);
  leerReg(reg);
  while (reg.nombre <> valorAlto )do
    begin
      write(archivo,reg);
      leerReg(reg);
    end; 
  close(archivo);
end; 



procedure leer(var archivo: archivo; var reg : distribucion);
begin
  if (not eof(archivo))then
    read(archivo,reg)
  else
    reg.nombre:= valorAlto; 
end;


procedure imprimir(var archivo: archivo);
var
  reg: distribucion;
begin
  reset(archivo);
  leer(archivo,reg);
  while (reg.nombre <> valorAlto)do
    begin
      writeln('nombre de la distribucion : ', reg.nombre);
      writeln('cantidad de desarrolladores : ', reg.cantDesarrolladores);
      writeln(' ');
      leer(archivo,reg);
    end; 
  close(archivo);
end; 

// PROCEDIMIENTOS PEDIDOS EN LOS INCISOS.


function ExisteDistribucion(var archivo : archivo; nom : String):boolean;
var
  aux : boolean;  
  reg: distribucion; 
begin
  aux:= false;
  reset(archivo);
  leer(archivo,reg);
  while((reg.nombre <> valorAlto) and (reg.nombre <> nom))do
    begin
      leer(archivo,reg);
    end; 
  // Puede salir porq lo encontro o termino el archivo.
  if (reg.nombre = nom)then aux:= true; 
  close(archivo);
  ExisteDistribucion:= aux; 
end; 




procedure AltaDistribucion(var archivo: archivo);
var
  nuevo,reg : distribucion; 
  res: boolean; 
  pos: integer ;
begin
  //leo por teclado los datos de una nueva distribución
  leerReg(nuevo);
  // Si no existe se puede agregar
  res := ExisteDistribucion(archivo,nuevo.nombre);
  if (res = false) then
    begin
      // Lo abro nuevamente para poder empezar a trabajar, ya que en el metodo anterior lo abri y cerre 
      reset(archivo);
      // Verifico si hay algun espacio borrado de manera logica.
      leer(archivo,reg);
      if (reg.cantDesarrolladores <0)then
        begin
          pos:= reg.cantDesarrolladores*-1; //guardo en positivo la posicion a dar de alta
          seek(archivo,pos);
          leer(archivo,reg);                //leo el archivo que esta en esta posicion asi lo copio en la cabecera
          seek(archivo,filepos(archivo)-1);
          write(archivo,nuevo);             // Copio el nuevo registro.
          seek(archivo,0);                  // Me posiciono en la cabecera y reemplazo por el reciente reemplazado.
          write(archivo,reg);               // Ahora en DESARROLLADORES queda el ultimo elemento actual de la lista invertida si no esta vacia.
        end
      else
        begin
          writeln(' no hay espacio para agregar una distribucion nueva.');
        end; 
      close(archivo);
    end; 
end;



procedure BajaDistribucion(var archivo : archivo);
var
  nombre:String; 
  reg, borrado: distribucion; 
  pos : integer; 
  res : boolean; 
begin
  //leo por teclado el nombre de la distribución a borrar.
  writeln('ingrese el nombre de la distribucion a borrar : ');
  readln(nombre);
  // Si existe lo eliminamos
  res := ExisteDistribucion(archivo,nombre);
  if (res = true) then
    begin
      // Borramos el archivo poniendo en cantDesarrolladores el ultimo reg borrado q esta en la cabecera
      reset(archivo);
      leer(archivo,reg); // En reg tengo el ultimo elemento de la lista en ese momento, ahora es el anteultimo
      leer(archivo,borrado);
      while(borrado.nombre <> nombre )do // Como se q existe, no controlo por que se termine el archivo.
        begin
          leer(archivo,borrado);
        end; 
      seek(archivo,filepos(archivo)-1);  // posiciono el puntero al registro a borrar 
      pos:= filepos(archivo)*-1;         // Obtengo la posicion del reciente borrado para ponerlo en la cabecera.
      borrado.cantDesarrolladores:= reg.cantDesarrolladores; // Copio el de la cabecera en el actual borrado
      reg.cantDesarrolladores:= pos;      // ahora en la cabecera tiene la posicion recientemente eliminada.
      write(archivo,borrado);            // en reg tenia la cabezera del ultimo borrado ya viejo.
      seek(archivo,0);
      write(archivo,reg );   // Ahora el borrado queda como el ultimo de la pila, ya que tenemos el num de reg del ultimo borrado.
      close(archivo);
    end
  else
    begin
      writeln('no existe la distribucion ');
    end; 
end; 

var 
  archivoo : archivo; 
BEGIN
  assign(archivoo,'linuxInfo');
  //crearArchivo(archivoo);
  writeln('---------Archivo sin modificar------------');
  imprimir(archivoo);
  // MENU PARA DAR DE BAJA Y ALTA EN EL ARCHIVO.
  writeln ('BAJA');
  BajaDistribucion(archivoo);
  BajaDistribucion(archivoo);
  BajaDistribucion(archivoo);
  imprimir(archivoo);
  writeln ('ALTA');
  AltaDistribucion(archivoo);
  AltaDistribucion(archivoo);
  imprimir(archivoo);
END.

