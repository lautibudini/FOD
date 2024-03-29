program tienda_celulares2;
type
  celulares = record
    cod: integer;
    nombre: String;
    descripcion: String;
    marca: String;
    precio: real;
    sMinimo: integer;
    sDisponible: integer;
  end;
  
  archivo = file of celulares;

{crea un archivo a partir del txt. Inciso a }
procedure crearArchivo(var a: archivo; var ac: text);
var
  c:celulares;
  nombre: String;
begin
  writeln('ingrese el nombre del archivo a crear : ');
  readln(nombre);
  assign(a,nombre);
  assign(ac,'celulares.txt');
  rewrite(a);
  reset(ac);
  while (not eof(ac))do
    begin
      readln(ac,c.cod,c.precio,c.marca);
      readln(ac,c.sDisponible,c.sMinimo,c.descripcion);
      readln(ac,c.nombre);
      write(a,c);
    end;
  close(a);
  close(ac);
end;


{modulo para impirmir los datos del celular}
procedure imprimirDatos(c: celulares);
begin
  writeln('codigo del celular: ', c.cod );
  writeln('nombre del celular: ', c.nombre );
  writeln('descripcion del celular: ', c.descripcion );
  writeln('marca del celular: ', c.marca );
  writeln('precio del celular: ', c.precio );
  writeln('stock minimo del celular: ', c.sMinimo );
  writeln('stock disponible del celular: ', c.sDisponible );  
end;

{lista en pantalla los celulares con stock menor al minimo .Inciso b}
procedure listadoStockMM(var a: archivo);
var
  c:celulares;
begin
  reset(a);
  while (not eof(a))do
    begin
      read(a,c);
      if(c.sDisponible < c.sMinimo)then imprimirDatos(c);
    end;
  close(a);
end;

{lista en pantalla los celulares donde la descripcion coincide con una ingresada por pantalla .Inciso c}
procedure listadoDeCoincidencia(var a: archivo);
var
  c: celulares;
  des: String;
begin
  writeln('ingrese una descripcion: ');
  readln(des);
  reset(a);
  des:= ' ' + des; {cuando se lee la cadena del txt le agrega un espacio al inicio}
  while (not eof(a))do
    begin
      read(a,c);
      if (c.descripcion = des)then imprimirDatos(c);
    end; 
  close(a);
end; 

{exportar el archivo creado en el inciso A a un txt con el mismo nombre, repetando lo dicho en el enunciado.Inciso D}
procedure exportar(var a: archivo);
var
  txt: text;
  c: celulares;
begin
  reset(a);
  assign(txt, 'celulares.txt');
  rewrite(txt);
  while(not eof(a))do
    begin
      read(a,c);
      writeln(txt, c.cod,' ', c.precio,' ', c.marca);
      writeln(txt, c.sDisponible,' ', c.sMinimo,' ', c.descripcion);
      writeln(txt, c.nombre);
    end;
end;


{nuevos codigos para el menu }

procedure leerCelular(var c: celulares);
begin
  writeln('ingrese el codigo de celular');
  readln(c.cod);
  writeln('ingrese el nombre del celular');
  readln(c.nombre);
  writeln('ingrese la descripcion del celular');
  readln(c.descripcion);
  writeln('ingrese la marca del celular');
  readln(c.marca);
  writeln('ingrese el precio del celular');
  readln(c.precio);
  writeln('ingrese el stock minimo  del celular');
  readln(c.sMinimo);
  writeln('ingrese el stock disponible del celular');
  readln(c.sDisponible);
end; 

{agrega un celular al archivo.Inciso 6A}
procedure agregarCelular(var a : archivo);
var
  c: celulares;
  cant,i: integer;
begin
  writeln('cuantos celulares desea ingresar:');
  readln(cant);
  reset(a);
  seek(a,filesize(a));
  for i:= 1 to cant do
    begin
      leerCelular(c);
      write(a,c);
    end;
  close(a);
end;

{modifica el stock de un celular dado.Inciso 6B}
procedure modificarStock(var a: archivo);
var
  c:celulares;
  nom: String;
  s:integer;
  corte: boolean;
begin
  corte:= false;
  writeln('ingrese el nombre del celular a actualizar el stock: ');
  readln(nom);
  writeln('ingrese el stock actual del celular: ');
  readln(s);
  reset(a);
  while ((not eof(a)) and (corte <> true))do
    begin
      read(a,c);
      if (c.nombre = nom) then corte:= true
    end; 
  if (corte = true) then
    begin
      c.sDisponible := s; 
      seek(a,filepos(a)-1);
      write(a,c);
    end; 
  close(a);
end; 

{eporta a un archivo de texto los celulares que no tienen stock.Inciso 6A}
procedure exportarSinStock(var a : archivo);
var
  txt: text;
  c: celulares;
begin
  assign(txt,'SinStock.txt');
  rewrite(txt);
  reset(a);
  while (not eof(a))do
    begin
      read(a,c);
      if (c.sDisponible = 0)then
        begin
          writeln(txt, c.cod,' ', c.precio,' ', c.marca);
          writeln(txt, c.sDisponible,' ',c.sMinimo,' ', c.descripcion);
          writeln(txt, c.nombre);
        end;
    end;
  close(txt);
  close(a);
end; 


{menu para el programa}
procedure menu(var a : archivo; var ac: text);
var
  numero: integer;
begin
  numero:= 1;
  while (numero <> 0)do
    begin
      writeln('ingrese 0 si desea finalizar con el menu');
      writeln('ingrese 1 si desea cargar en un archivo todos los datos de los celulares a partir de un archivo de texto');
      writeln('ingrese 2 si desea que se muetre en pantalla los celulares (datos) que tienen stock menor al minimo');
      writeln('ingrese 3 si desea que se muestre en pantalla los celulares (datos) que tengan una descripcion como una ingresada por usted');
      writeln('ingrese 4 si desea exportar el archivo generado a otro archivo de texto');
      writeln('ingrese 5 si desea agregar uno o mas celulares');
      writeln('ingrese 6 si desea actualizar el stock de un celular');
      writeln('ingrese 7 si desea exportar a un txt los datos de los celulares sin stock');
      readln(numero);
      case numero of
        0: writeln('fin de las operaciones');
        1: crearArchivo(a,ac);
        2: listadoStockMM(a);
        3: listadoDeCoincidencia(a);
        4: exportar(a);
        5: agregarCelular(a);
        6: modificarStock(a);
        7: exportarSinStock(a);
      else
        writeln('numero no valido');
      end;
    end;  
end;
var 
  a: archivo;
  ac: text;
BEGIN
  menu(a,ac);
END.

