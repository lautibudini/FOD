{
   Dada la estructura planteada en el ejercicio anterior, implemente el siguiente módulo:

   Abre el archivo y elimina la flor recibida como parámetro manteniendo
   la política descripta anteriormente

   procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);.
   
   
}

program floresp2;
const
  valorAlto = 9999; 
type

  reg_flor = record
    nombre: String;
    codigo:integer;
  end;
      
  tArchFlores = file of reg_flor;


procedure leer(var a : tArchFlores; var reg: reg_flor);
begin
  if (not eof(a))then
    read(a,reg)
  else
    reg.codigo:= valorAlto; 
end; 

procedure crearArchivo (var a: tArchFlores);
var
  reg: reg_flor; 
  nombre: String; 
begin
  writeln('ingrese el nombre logico del archivo');
  readln(nombre);
  assign(a,nombre);
  rewrite(a);
  reg.codigo:= 0; 
  write(a,reg);  //escribo en la cabecera del archivo como inicio un cero, q funciona como la pila
  writeln('ingrese el codigo de la flor : ');
  readln(reg.codigo);
  while(reg.codigo <> valorAlto)do
    begin
      writeln('ingrese el nombre de la flor : ');
      readln(reg.nombre);
      write(a,reg);
      writeln('ingrese el codigo de la flor : ');
      readln(reg.codigo);
    end;
  close(a);
end; 




//modulo del punto 5 
procedure eliminarFlor (var a: tArchFlores; flor:reg_flor);
var
  reg,cabeza: reg_flor; 
  indice : integer; 
begin
  reset(a);
  leer(a,cabeza); //guardo el valor de la cabecera 
  leer(a,reg);
  while ( (reg.codigo <> valorAlto) and(reg.nombre <> flor.nombre))do
    begin
      leer(a,reg);
    end; 
  if (reg.nombre = flor.nombre)then
    begin
      seek(a,filepos(a)-1);     // me posiciono en el reg
      indice:= filepos(a)*-1;  // me guardo la posicion del eliminado en negativo 
      reg.codigo:= cabeza.codigo;  //pongo el reg que esta en cabezera, la sig posicion
      write(a,reg);
      seek(a,0);               // me posiciono  en la cabecera
      cabeza.codigo:= indice;  // escribo el indice del reciente borrado en neg
      write(a,cabeza);        //en el registro cabeza tengo la posicion negativa
    end
  else
    begin
      writeln('no se encontro la flor');
    end; 
  close(a);
end; 




//modulo A el punto 4
procedure agregarFlor (var a: tArchFlores ; nombre: String; codigo:integer);
var
  reg,nuevo: reg_flor;
  posicion: integer;  
begin
  reset(a);
  read(a,reg); //leemos el reg cabecera
  nuevo.nombre:= nombre; 
  nuevo.codigo:= codigo; 
  if (reg.codigo < 0)then
    begin
      posicion:= reg.codigo*-1; 
      seek(a,posicion);    //me posiciono en el reg borrado
      read(a,reg);         //como existe lo leo para obtener su codigo sig si tiene
      seek(a,filepos(a)-1);
      write(a,nuevo);       //escribo el nuevo
      seek(a,0);            //me posiciono al inicio y escribo el valor del cod sig si existe.
      write(a,reg);
      writeln('la flor se agrego con exito');
    end
  else
    begin
      writeln('no hay espacio para agregar otra flor');
    end;  
  close(a);
end; 


//modulo B del punto 4 
procedure imprimir(var a: tArchFlores);
var
  reg: reg_flor; 
begin
  writeln('se listaran las flores que contiene este archivo');
  reset(a);
  seek(a,1); // salto el primer reg ya que es la cabecera de la pila 
  leer(a,reg);
  while(reg.codigo <> valorAlto)do
    begin
      // si el codigo no es mayor a cero, es porq esta dado de baja
      if (reg.codigo >0)then
        begin
          writeln('flor : ', reg.nombre , ' con el codigo : ', reg.codigo);
          writeln('------------------------------');
        end; 
      leer(a,reg);
    end; 
  close(a);
end; 



var
  a: tArchFlores; 
  reg: reg_flor; 
  i,iteraciones: integer; 
BEGIN
  // creo el archivo
  crearArchivo(a);
  // elimino dos elem
  writeln('ingrese cuantos elementos desea eliminar : ');
  readln(iteraciones);
  for i:= 1 to iteraciones do
    begin
      writeln('ingrese la flor a borrar : ');
      readln(reg.nombre);
      eliminarFlor(a,reg);
    end; 
  // agrego uno solo
  writeln('ingrese cuantas flores desea agregar :');
  readln(iteraciones);
  for i:= 1 to iteraciones do
    begin
      writeln('ingrese el nombre de la flor : ');
      readln(reg.nombre);
      writeln('ingrese el codigo de la flor : ');
      readln(reg.codigo);
      agregarFlor(a,reg.nombre,reg.codigo);
    end; 
  //imrpimo 
  imprimir(a);
END.



