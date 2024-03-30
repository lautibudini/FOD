{
El encargado de ventas de un negocio de productos de limpieza desea administrar el stock
de los productos que vende. Para ello, genera un archivo maestro donde figuran todos los
productos que comercializa. De cada producto se maneja la siguiente información: código de
producto, nombre comercial, precio de venta, stock actual y stock mínimo. Diariamente se
genera un archivo detalle donde se registran todas las ventas de productos realizadas. De
cada venta se registran: código de producto y cantidad de unidades vendidas. Se pide
realizar un programa con opciones para:
* 
* a. Actualizar el archivo maestro con el archivo detalle, sabiendo que:
     ● Ambos archivos están ordenados por código de producto.
     ● Cada registro del maestro puede ser actualizado por 0, 1 ó más registros del archivo detalle.
     ● El archivo detalle sólo contiene registros que están en el archivo maestro.
  b. Listar en un archivo de texto llamado “stock_minimo.txt” aquellos productos cuyo
     stock actual esté por debajo del stock mínimo permitido. 
}

program comercio;
const
  valorAlto = 999;
type
  producto = record
    codigo: integer; 
    nombre : String; 
    precio : real; 
    sActual : integer; 
    sMinimo : integer; 
  end; 

  venta = record
    codigo: integer; 
    unidades: integer; 
  end;
  
  aM = file of producto; 
  aD = file of venta; 


{ modulos para generar el archivo maestro de cero}
procedure leerReg(var p : producto);
begin
  writeln('ingrese el codigo del producto : ');
  readln(p.codigo);
  if (p.codigo <> 0)then
    begin
      writeln('ingrese el nombre del producto : ');
      readln(p.nombre);
      writeln('ingrese el precio del producto : ');
      readln(p.precio);
      writeln('ingrese el stock actual del producto : ');
      readln(p.sActual);
      writeln('ingrese el stock minimo del producto : ');
      readln(p.sMinimo);
    end; 
end; 

procedure generarMaestro(var maestro : aM);
var
  p: producto;
begin
  rewrite(maestro);
  writeln('para finalizar con el ingreso de productos ingrese el codigo = 0');
  leerReg(p);
  while (p.codigo <>0)do
    begin
      write(maestro,p);
      leerReg(p);
    end; 
  close(maestro);
end; 

{modulos para crear el archivo detalle de cero}

procedure leerReg2(var v : venta);
begin
  writeln('ingrese el codigo del producto : ');
  readln(v.codigo);
  if (v.codigo <> 0)then
    begin
      writeln('ingrese las unidades vendidas del producto : ');
      readln(v.unidades);
    end; 
end; 

{se debe ingresar ordenado por cod de producto}
procedure generarDetalle(var detalle : aD);
var
  v: venta;
begin
  rewrite(detalle);
  writeln('para finalizar con el ingreso de ventas ingrese el codigo = 0');
  leerReg2(v);
  while (v.codigo <>0)do
    begin
      write(detalle,v);
      leerReg2(v);
    end; 
  close(detalle);
end; 



{inciso A , actualizar el maestro con el detalle}
procedure leer(var detalle : aD ; var act2 : venta);
begin
  if (not eof(detalle))then
    read(detalle,act2)
  else
    act2.codigo := valorAlto;
end; 
procedure actualizar(var maestro : aM; var detalle: aD);
var
  act : producto;
  act2: venta; 
begin
  reset(maestro);
  reset(detalle);
  //read(maestro,act); es mejor si va dentro del while
  leer(detalle,act2);
  while (act2.codigo <> valorAlto)do
    begin
      read(maestro,act); debe ir aca(?
      // busco en el maestro el producto
      while (act2.codigo <> act.codigo)do
        begin
          read(maestro,act);
        end; 
      // puede haber mas de 1 venta por entonces agrupo
      while (act2.codigo = act.codigo)do
        begin
          act.sActual := act.sActual - act2.unidades; //le resto lo vendido
          leer(detalle,act2);
        end; 
      //debo actualizar en el maestro
      seek(maestro, filepos(maestro)-1);
      write(maestro,act);
    end; 
  close(maestro);
  close(detalle);
end; 

{exporto a un txt los productos que tengan un stock menor al minimo}
procedure exportar(var maestro: aM);
var
  txt: text; 
  p: producto;
begin
  assign(txt, 'stock_minimo.txt');
  rewrite(txt);
  reset(maestro);
  while (not eof(maestro))do
    begin
      read(maestro,p);
      //como no especifica su uso, para mayor rapidez pongo solo los nombres
      if (p.sMinimo > p.sActual) then writeln(txt, p.nombre);
    end; 
  close(txt);
  close(maestro);
end; 



var
  maestro : aM; 
  detalle : aD; 
  num: integer; 
BEGIN
  assign(maestro,'maestroo');
  assign(detalle, 'detallee');
  num:= 1; 
  while (num <> 0)do
    begin
      writeln('bienvenido al menu principal, ingrese : ');
      writeln('0- Para finalizar');
      writeln('1- Para generar un archivo maestro donde figuran todos los productos');
      writeln('2- Para generar un archivo detalle nuevo con todas las ventas');
      writeln('3- Para actualizar el archivo maestro con el detalle');
      writeln('4- Para exportar los nombres de los productos donde su stock actual sea menor que el minimo');
      
      readln(num);
      case num of
        0: writeln('menu finalizado');
        1: generarMaestro(maestro);
        2: generarDetalle(detalle);
        3: actualizar(maestro,detalle);
        4: exportar(maestro);
      else
        writeln('numero no valido');
      end;
    end; 
END.

