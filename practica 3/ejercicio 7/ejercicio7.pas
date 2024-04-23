{
   
   
   Se cuenta con un archivo que almacena información sobre especies de aves en vía
de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las
especies a eliminar. Deberá realizar todas las declaraciones necesarias, implementar
todos los procedimientos que requiera y una alternativa para borrar los registros. 
* 
* Para ello deberá implementar dos procedimientos, uno que marque los registros a borrar y
posteriormente otro procedimiento que compacte el archivo, quitando los registros
marcados. Para quitar los registros se deberá copiar el último registro del archivo en la
posición del registro a borrar y luego eliminar del archivo el último registro de forma tal
de evitar registros duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000.
   
   
}
program especies;
const
  valorAlto = 9999; 
type

  ave = record
    cod : integer; 
    nombre : String; 
    familia : String; 
    descripcion : String; 
    zona : String ;
  end; 

  //El archivo no está ordenado por ningún criterio
  archivo = file of ave; 

// PROCEDIMIENTOS COMPLEMENTARIOS PARA PROBAR EL PROGRAMA


// mi corte es cuando en cod me mande valorAlto q termino el archivo. No especificado en el enunciado.
procedure leer(var a: archivo; var reg :ave);
begin
  if (not eof(a))then
    read(a,reg)
  else
    reg.cod:= valorAlto; 
end; 


procedure leerReg(var reg : ave);
begin
  writeln('ingrese el codigo del ave : (corta el ingreso con - 9999 -)');
  readln(reg.cod);
  if (reg.cod <> valorAlto)then
    begin
      writeln('ingrese el nombre del ave:  ');
      readln(reg.nombre);
      writeln('ingrese la familia del ave:  ');
      readln(reg.familia);
      writeln('ingrese la descripcion del ave:  ');
      readln(reg.descripcion);
      writeln('ingrese la zona geografica del ave:  ');
      readln(reg.zona);
    end; 
end; 

procedure crearArchivo(var a : archivo);
var
  reg :ave; 
begin
  rewrite(a);
  leerReg(reg);
  while ( reg.cod <> valorAlto)do
    begin
      write(a,reg);
      leerReg(reg);
    end; 
  close(a);
end;



procedure imprimir (var a : archivo);
var
  reg : ave; 
begin
  reset(a);
  leer(a,reg);
  while (reg.cod <> valorAlto)do
    begin
      writeln('el nombre del ave:  ', reg.nombre );
      writeln('el codigo del ave : ', reg.cod);
      writeln(' ');
      leer(a,reg);
    end; 
  close(a);
end; 






// PROCEDIMIENTOS PARA LA ELIMINACION Y COMPACTACION DE LOS ARCHIVOS.

procedure eliminacionLogica(var a : archivo);
var
  cod : integer;
  reg : ave;  
begin
  writeln(' ingrese el codigo de ave a eliminar : - Termina este procedimiento ingresando 5000 - ');
  readln(cod);
  reset(a);
  while (5000 <> cod)do
    begin
      seek(a,0);
      leer(a,reg);
      // Busco el codigo de mi ave.
      while ( (reg.cod <> valorAlto) and (reg.cod <> cod))do
        begin
          leer(a,reg);
        end; 
      // Si existe modifico , sino informo 
      if (reg.cod = cod)then
        begin
          // le pongo la marca de borrado
          reg.nombre:= 'eliminado';
          seek(a,filepos(a)-1);
          write(a,reg); 
          writeln('marcado como borrado. ');
        end
      else
        writeln('no existe el codigo');
      // Pido otro codigo de ave : 
      writeln(' ingrese el codigo de ave a eliminar : - Termina este procedimiento ingresando 5000 - ');
      readln(cod);
    end; 
  close(a);
end; 



procedure compactar(var archivo : archivo);
var
  reg: ave; 
  pos : integer; 
begin
  // Debo recorrer el archivo desde principio a fin, y en cada posicion de eliminacion logica, tomo
  // el ultimo archivo y lo intercambio por el ultimo - y trunco- 
  
  // Se presenta una situacion donde pueden haber mas de un elemento al final del archivo
  // eliminados de manera logica , asi q para trabajar de esta manera, me desago de ellos
  // antes de reemplazar un eliminado por uno del final ej: 
  // valido valido eliminado valido eliminado eliminado
  // al querer reemplazar el primer eliminado por el ultimo estaria cometiendo un error, por ende 
  // debo eliminar y truncar hasta tener uno valido en el final para poder reemplazar.
  
  
  reset(archivo);
 
  //me posiciono al inicio del archivo 
  seek(archivo,0);
  leer(archivo,reg);
  while (reg.cod <> valorAlto)do
    begin
      if (reg.nombre = 'eliminado')then
        begin
          // me guardo la posicion a reemplazar. es la anterior ya que al leerlo avanzo.
          pos:= filepos(archivo)-1;
          // Leo el ultimo registro para ver si es un eliminado o esta disponible.
          seek(archivo,filesize(archivo)-1);
          leer(archivo,reg);
          // Si es un eliminado debo verificar que como ultimo me quede uno valido.
          while(reg.nombre = 'eliminado' )do
            begin
              //al leerlo avanza al siguiente, entonces me posiono de nuevo en el que lei.
              seek(archivo,filepos(archivo)-1);
              // trunco el archivo en este punto.
              truncate(archivo);
              // como ya lo trunque , me posiciono de nuevo en el ultimo elemento.
              seek(archivo,filesize(archivo)-1);
              leer(archivo,reg);
            end;
          // me vuelvo a posicionar en este ya valido, y lo trunco asi pongo este en mi 'pos'.
          seek(archivo,filesize(archivo)-1);
          truncate(archivo);
          // reemplazo el archivo eliminado.
          seek(archivo,pos);
          write(archivo,reg);
        end; 
      //leo el siguiente elemento.
      leer(archivo,reg);
    end; 
  close(archivo);
end; 


var
  a : archivo; 
BEGIN
  assign(a,'aves');
  crearArchivo(a);
  writeln('---------- archivo original -------------------------------------');
  imprimir(a);
  eliminacionLogica(a);
  writeln('-----------archivo despues de la eliminacion logica -------------- ');
  imprimir(a);
  compactar(a);
  writeln('-----------archivo final, compactado -----------------------------');
  imprimir(a);
END.

