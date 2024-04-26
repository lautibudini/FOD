{
   El encargado de ventas de un negocio de productos de limpieza desea administrar el
stock de los productos que vende. Para ello, genera un archivo maestro donde figuran
todos los productos que comercializa. De cada producto se maneja la siguiente
información: código de producto, nombre comercial, precio de venta, stock actual y
stock mínimo. Diariamente se genera un archivo detalle donde se registran todas las
ventas de productos realizadas. De cada venta se registran: código de producto y
cantidad de unidades vendidas. Resuelve los siguientes puntos
* 
* 
a. Se pide realizar un procedimiento que actualice el archivo maestro con el
archivo detalle, teniendo en cuenta que:

i. Los archivos no están ordenados por ningún criterio.
ii. Cada registro del maestro puede ser actualizado por 0, 1 ó más registros
del archivo detalle.


b. ¿Qué cambios realizaría en el procedimiento del punto anterior si se sabe que
cada registro del archivo maestro puede ser actualizado por 0 o 1 registro del
archivo detalle? 

RES: Al solo poder ser actualizado por 1 como maximo, lo que haria es mientras que no se termine y no lo encuentre
sigo. Entonces al momento que corta saldria xq no hay ventas o xq encontro la unica que se puede y no sigue iterando
   
}


program Local;
const
  valorAlto = 9999; 
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
  
  
// MODULOS PARA CREAR LOS ARCHIVOS


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


// MODULO DE IMPRESION PARA PODER VERIFICAR

procedure leer(var detalle : aD ; var act2 : venta);
begin
  if (not eof(detalle))then
    read(detalle,act2)
  else
    act2.codigo := valorAlto;
end; 

procedure leerM(var maestro : aM ; var act : producto);
begin
  if (not eof(maestro))then
    read(maestro,act)
  else
   act.codigo := valorAlto;
end; 

procedure imprimir(var maestro : aM);
var 
  reg: producto; 
begin
  reset(maestro);
  leerM(maestro,reg);
  while (reg.codigo <> valorAlto)do
    begin
      writeln('producto : ', reg.nombre , ', stock : ', reg.sActual);
      writeln(' ');
      leerM(maestro,reg);
    end; 
  close(maestro);
end; 


// MODULO DE ACTUALIZACION MAESTRO-DETALLE DESORDENADOS.


procedure actualizar(var maestro : aM ; var detalle : aD);
var
  reg : producto; 
  v : venta; 
  unidades : integer; 
begin
  reset(maestro);
  reset(detalle);
  // Leo un maestro para arrancar a iterar
  leerM(maestro,reg);
  while (reg.codigo <> valorAlto)do
    begin
      unidades:=0; 
      // Como siempre voy a recorrer el detalle por cada codigo debo posicionarme en el inicio del archivo
      seek(detalle,0);
      leer(detalle,v);
      // Como no esta ordenado debo recorrer todo el archivo para ver si hay una venta de mi producto actual.
      while (v.codigo <> valorAlto)do
        begin
          // Si coincide con mi producto sumo las unidades vendidas
          if (v.codigo = reg.codigo)then unidades:= unidades + v.unidades;
          leer(detalle,v);
        end;
      // Si se vendio este producto lo modifico sino sigo
      if (unidades> 0)then
        begin
          reg.sActual:= reg.sActual - unidades; 
          // Posiciono el puntero y actualizo
          seek(maestro,filepos(maestro)-1);
          write(maestro,reg);
        end;
      leerM(maestro,reg); 
    end; 
  close(detalle);
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
      writeln('4- Para imprimir el archivo maestro');
      
      readln(num);
      case num of
        0: writeln('menu finalizado');
        1: generarMaestro(maestro);
        2: generarDetalle(detalle);
        3: actualizar(maestro,detalle);
        4: imprimir(maestro);
      else
        writeln('numero no valido');
      end;
    end; 
END.

