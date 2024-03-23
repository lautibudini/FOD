program tienda_celulares;
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
  des:= ' '+ des; {por como esta escrito delante del string debe haber un espacio}
  reset(a);
  while (not eof(a))do
    begin
      read(a,c);
      if (c.descripcion = des)then imprimirDatos(c)

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
  assign(txt, 'celulares_nuevo.txt');
  rewrite(txt);
  while(not eof(a))do
    begin
      read(a,c);
      writeln(txt, c.cod, c.precio, c.marca);
      writeln(txt, c.sDisponible, c.sMinimo, c.descripcion);
      writeln(txt, c.nombre);
    end;
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
    readln(numero);
    case numero of
      0: writeln('fin de las operaciones');
      1: crearArchivo(a,ac);
      2: listadoStockMM(a);
      3: listadoDeCoincidencia(a);
      4: exportar(a);
    else
      writeln('numero no valido');
    end;
  end;
end;
var 
  a : archivo;
  ac : text;
BEGIN
  menu(a,ac);
END.

