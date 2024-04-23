{
  
   Una cadena de tiendas de indumentaria posee un archivo maestro no ordenado con
la información correspondiente a las prendas que se encuentran a la venta. De cada
prenda se registra: cod_prenda, descripción, colores, tipo_prenda, stock y
precio_unitario. Ante un eventual cambio de temporada, se deben actualizar las
prendas a la venta. Para ello reciben un archivo conteniendo: cod_prenda de las
prendas que quedarán obsoletas. Deberá implementar un procedimiento que reciba
ambos archivos y realice la baja lógica de las prendas, para ello deberá modificar el
stock de la prenda correspondiente a valor negativo.
* 
Adicionalmente, deberá implementar otro procedimiento que se encargue de
efectivizar las bajas lógicas que se realizaron sobre el archivo maestro con la
información de las prendas a la venta. Para ello se deberá utilizar una estructura
auxiliar (esto es, un archivo nuevo), en el cual se copien únicamente aquellas prendas
que no están marcadas como borradas. Al finalizar este proceso de compactación
del archivo, se deberá renombrar el archivo nuevo con el nombre del archivo maestro
original.
   
}


program tiendas;
const
  valorAlto = 9999;
type

  prenda = record
    cod : integer; 
    descripcion : String; 
    colores: String; 
    tipo : String; 
    stock : integer; 
    precio: Real ;
  end; 
  
  am = file of prenda;
  //Maestro no ordenado.

  ad = file of integer;
  // Posee los codigos de prendas que quedaron obsoletas.

//----------------------------------------------------------------
// PROCEDIMIENTOS AUXILIARES. 

procedure leer(var maestro : am; var reg : prenda);
begin
  if (not eof(maestro))then
    read(maestro,reg)
  else
    reg.cod:= valorAlto; 
end; 

procedure leer2(var detalle : ad; var num : integer); 
begin
  if(not eof(detalle))then
    read(detalle,num)
  else
    num:= valorAlto; 
end; 


procedure leerReg(var reg: prenda); 
begin
  writeln('ingrese el codigo de la prenda : ');
  readln(reg.cod);
  if (reg.cod <> valorAlto)then
    begin
      writeln('ingrese la descripcion de la prenda : ');
      readln(reg.descripcion);
      writeln('ingrese los colores de la prenda : ');
      readln(reg.colores);
      writeln('ingrese el tipo de prenda : ');
      readln(reg.tipo);
      writeln('ingrese el stock de la prenda : ');
      readln(reg.stock);
      writeln('ingrese el precio de la prenda : ');
      readln(reg.precio);
    end; 
end; 


procedure crearMaestro(var maestro: am);
var
  reg: prenda; 
begin
  writeln(' - creacion del archivo maestro -');
  rewrite(maestro);
  leerReg(reg);
  while (reg.cod <> valorAlto)do
    begin
      write(maestro,reg);
      leerReg(reg);
    end; 
  close(maestro);
end; 


procedure crearDetalle(var detalle : ad);
var
  num: integer; 
begin
  writeln(' - creacion del detalle -');
  rewrite(detalle);
  writeln('ingrese el codigo de prenda q desea dar de baja : ');
  readln(num);
  while (num <> valorAlto ) do
    begin
      write(detalle, num);
      writeln('ingrese el codigo de prenda q desea dar de baja : ');
      readln(num);
    end; 
  close(detalle);
end;


procedure imprimir(var maestro : am);
var 
  reg: prenda; 
begin
  writeln(' Productos : ');
  reset(maestro);
  leer(maestro,reg);
  while (reg.cod <> valorAlto)do
    begin
      writeln('despues');
      writeln(' codigo de la prenda : ' , reg.cod);
      writeln('descripcion de la prenda : ', reg.descripcion);
      writeln('colores de la prenda : ', reg.colores);
      writeln('tipo de prenda : ', reg.tipo);
      writeln('stock de la prenda : ', reg.stock);
      writeln('precio de la prenda : ', reg.precio);
      leer(maestro,reg);
    end; 
  close(maestro);
end; 


//-----------------------------------------------------------------
// PROCEDIMIENTOS DE BAJAS. 

// Modificar el stock de la prenda correspondiente(baja) a valor negativo.
procedure bajaLogica(var maestro : am; var detalle : ad);
var
  reg : prenda;
  cod : integer;  
begin
  reset(maestro);
  reset(detalle);
  // Actualizo el maestro, recorriendo el detalle.
  // como el detalle tiene de seguro el codigo , tomo un codigo y lo busco en el maestro.
  leer2(detalle,cod);
  while ( cod <> valorAlto)do
    begin
      // me posiciono al principio y busco el codigo en el maestro.
      seek(maestro,0);
      leer(maestro,reg);
      while( (reg.cod <> valorAlto) and (reg.cod <> cod))do
        begin
          leer(maestro,reg);
        end; 
      // Una vez que tengo el codigo , pongo en negativo el stock y lo escribo de nuevo. 
      reg.stock:= reg.stock*-1;
      seek(maestro,filepos(maestro)-1);
      write(maestro,reg);
      // Leo el proximo codigo del detalle
      leer2(detalle,cod);
    end; 
  close(detalle);
  close(maestro);
end; 




procedure nuevoArchivo(var nuevo,maestro: am );
var
  reg: prenda; 
begin
  reset(maestro);
  rewrite(nuevo);
  leer(maestro,reg);
  while ( reg.cod <> valorAlto)do
    begin
      if (reg.stock >0)then
        begin
          // Si es mayor a cero, no es negativo entonces se agrega al nuevo archivo
          write(nuevo,reg);
        end; 
      leer(maestro,reg);
    end; 
  // Una vez que termino de filtrar el archivo con lo borrado logicamente 
  // Debo asignar al nuevo el nombre del anterior archivo y borrar el otro.
  close(nuevo);
  close(maestro);
  // Borro el maestro: 
  erase(maestro);
  // Renombro al nuevo con el maestro (nombre fisico, no logico).
  rename(nuevo,'maestro');
end; 


var 
  nuevo,maestro: am; 
  detalle : ad; 
BEGIN
  assign(maestro,'maestro');
  assign(detalle,'detalle');
  assign(nuevo, 'nuevo');
  crearMaestro(maestro);
  crearDetalle(detalle);
  writeln('---------------------------------');
  writeln('maestro sin modificar : ');
  imprimir(maestro);
  bajaLogica(maestro,detalle);
  writeln('---------------------------------');
  writeln('maestro con baja logica : ');
  imprimir(maestro);
  nuevoArchivo(nuevo,maestro);
  writeln('---------------------------------');
  writeln('maestro - nuevo archivo - : ');
  imprimir(nuevo);
END.

