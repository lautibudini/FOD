{
* Se cuenta con un archivo de productos de una cadena de venta de alimentos congelados.
De cada producto se almacena: código del producto, nombre, descripción, stock disponible,
stock mínimo y precio del producto.
Se recibe diariamente un archivo detalle de cada una de las 30 sucursales de la cadena. Se
debe realizar el procedimiento que recibe los 30 detalles y actualiza el stock del archivo
maestro. La información que se recibe en los detalles es: código de producto y cantidad
vendida. 
* Además, se deberá informar en un archivo de texto: nombre de producto,
descripción, stock disponible y precio de aquellos productos que tengan stock disponible por
debajo del stock mínimo. Pensar alternativas sobre realizar el informe en el mismo
procedimiento de actualización, o realizarlo en un procedimiento separado (analizar
ventajas/desventajas en cada caso).
* 
Nota: todos los archivos se encuentran ordenados por código de productos. En cada detalle
puede venir 0 o N registros de un determinado producto
}
program cadena_alimentos;
const
  valorAlto = 9999; 
type

  producto = record
    codigo: integer; 
    nombre: String; 
    descripcion : String; 
    sDisponible: integer; 
    sMinimo: integer; 
    precio : real; 
  end; 
  
  venta = record
    codigo: integer; 
    cantidad: integer; 
  end; 

  aM = file of producto; 
  aD = file of venta; 

  //uso vectores para poder guardar los 30 detalles y el primer reg de cada uno
  vec_detalle = array [1..30] of aD; 
  vec_registro = array [1..30] of venta; 
  
  
//procedimientos para actualizar al maestro

procedure leer(var detalle: aD ; var det : venta);
begin
  if (not eof(detalle))then
    read(detalle,det)
  else
    det.codigo := valorAlto;
end; 

procedure minimo(var vec_det: vec_detalle; var vec_reg : vec_registro;  var min : venta);
var
  i: integer; 
  pos: integer; 
begin
  //arranca en valor alto ya que quiero sacar el minimo
  min.codigo :=valorAlto;
  pos:=0;
  //saco el minimo del vec de registros de los n detalles
  for i:= 1 to 30 do
    begin
      if (vec_reg[i].codigo<min.codigo)then
        min:= vec_reg[i];
        pos:= i;
    end;
  //ya tengo la pos y el valor minimo
  //si no es valorAlto es xq todavia no se terminaron los 30 archivos
  if (min.codigo <> valorAlto) then  
    //leo el sig reg para ponerlo en el vector 
    leer(vec_det[pos],vec_reg[pos]); 
end; 

procedure actualizar (var maestro : aM; var vec_det: vec_detalle; var vec_reg : vec_registro );
var
  produc: producto;
  i : integer; 
  min: venta; 
begin
  reset(maestro);
  //abro los 30 detalles y leo el primer reg de cada uno 
  for i:= 1 to 30 do
    begin
      reset(vec_det[i]);
      leer(vec_det[i],vec_reg[i]); 
    end; 
  minimo(vec_det,vec_reg,min);
  while (min.codigo <> valorAlto)do
    begin
      //leo uno del  maestro
      read(maestro,produc);
      //busco en el maestro si no es el actual
      while(produc.codigo <> min.codigo)do
        begin
          read(maestro,produc);
        end; 
      //si hay mas de uno en el detalle debo iterar y restar
      while (min.codigo = produc.codigo)do
        begin
          produc.sDisponible := produc.sDisponible - min.cantidad; 
          minimo(vec_det,vec_reg,min);
        end; 
      // cuando salgo debo actualizar en el maestro
      seek(maestro,filepos(maestro)-1);
      write(maestro,produc);
    end; 
  close(maestro);
  //tengo que hacer close a los 30 detalles
  for i:= 1 to 30 do
    begin
      close(vec_det[i]);
    end; 
end; 

procedure exportarMinimos(var maestro : aM);
var
  txt: text; 
  reg: producto;
begin
  reset(maestro);
  assign(txt,'minimos.txt');
  rewrite(txt);
  while(not eof(maestro))do
    begin
      read(maestro,reg);
      if (reg.sDisponible<reg.sMinimo)then
        writeln(txt,reg.nombre);
        writeln(txt,reg.sDisponible,' ',reg.precio, ' ',reg.descripcion);
    end; 
  close(maestro);
  close(txt);
end; 

var 
  maestro : aM ;
  i: integer; 
  vec_det: vec_detalle; 
  vec_reg: vec_registro ; 
  istr: String;
BEGIN
  assign(maestro,'maestroo');
  for i:= 1 to 30 do
    begin
      Str(i,istr);  //convierte un valor numerico en una cadena de caracteres
      assign(vec_det[i],'detalle'+ istr);
    end; 
  actualizar(maestro,vec_det,vec_reg);
  exportarMinimos(maestro);
  //yo hice el procedimiento de exportar cuando ya termine de actualizar el archivo maestro
  //una desventaja es que se recorre dos veces el maestro, pero personalmente queda mas legible
  //para hacerlo junto debo de cargar en el txt, cuando termine de actualizar un producto para verificar lo pedido.
END.

