{ Se dispone de un archivo con información de los alumnos de la Facultad de Informática. Por
cada alumno se dispone de su código de alumno, apellido, nombre, cantidad de materias
(cursadas) aprobadas sin final y cantidad de materias con final aprobado. Además, se tiene
un archivo detalle con el código de alumno e información correspondiente a una materia
(esta información indica si aprobó la cursada o aprobó el final).
* 
Todos los archivos están ordenados por código de alumno y en el archivo detalle puede
haber 0, 1 ó más registros por cada alumno del archivo maestro. Se pide realizar un
programa con opciones para:

a. Actualizar el archivo maestro de la siguiente manera:
  
  i.Si aprobó el final se incrementa en uno la cantidad de materias con final aprobado,
    y se decrementa en uno la cantidad de materias sin final aprobado.

  ii.Si aprobó la cursada se incrementa en uno la cantidad de materias aprobadas sin final.

b. Listar en un archivo de texto aquellos alumnos que tengan más materias con finales
aprobados que materias sin finales aprobados. Teniendo en cuenta que este listado
es un reporte de salida (no se usa con fines de carga), debe informar todos los
campos de cada alumno en una sola línea del archivo de texto.
* 
NOTA: Para la actualización del inciso a) los archivos deben ser recorridos sólo una vez}
program Facultad;
const
  valorAlto = 9999;
type
  alumno = record
    codigo : integer; 
    apellido: String; 
    nombre: String; 
    cursadasA: integer; 
    materiasA: integer; 
  end; 
  
  info = record
    codigo: integer; 
    cursada: char; 
    finall : char; 
  end; 
  
  amaestro = file of alumno; 
  adetalle = file of info;
  
procedure crearMaestro(var m : amaestro);
var
  carga: text;
  a: alumno; 
begin
  assign(carga,'alumnos.txt');
  reset(carga);
  rewrite(m);
  while (not eof(carga))do
    begin
      readln(carga,a.apellido);
      readln(carga,a.codigo, a.cursadasA, a.materiasA, a.nombre);
      write(m,a);
    end; 
  close(m);
  close(carga);
end; 
  
procedure crearDetalle(var d : adetalle);
var
  carga: text;
  i: info; 
begin
  assign(carga,'detalle.txt');
  reset(carga);
  rewrite(d);
  while (not eof(carga))do
    begin
      readln(carga,i.nombre);
      readln(carga,i.cursada);
      readln(carga,i.finall);
      write(d,i);
    end; 
  close(d);
  close(carga);
end; 

{procedure leer para el detalle }
{aca si se repite el alumno en el detalle , no acumulo (while (act = detalle.nombre) deberia hacerlo ?)}
procedure actualizarMaestro(var maestro: amaestro; var detalle: adetalle);
var
  act : info;
  act2: alumno; 
begin
  reset(maestro);
  reset(detalle);
  leer(act,detalle);
  read(maestro,act2);
  while (act.codigo <> valorAlto)do
    begin
      {debo buscar en el maestro el alumno}
      while( act.codigo <> act2.codigo)do
        begin
          read(maestro,act2);
        end; 
      {me fijo que debo sumar}{aca preguntar si esta bien con un char / tambien si no se modifica y se escribe igual (mejorar esa parte) }
      if (act.cursada = "v")then act2.cursadasA:= act2.cursadasA + 1; 
      if (act.finall = "v")then 
        begin
          act2.materiasA := act2.materiasA + 1;
          act2.cursadasA:= act2.cursadasA - 1
        end; 
      if ( (act.cursada = "v") or (act.finall = "v")) then
        begin
          {seek(maestro, filepos(maestro)-1); no deberia hacerlo xq ya estoy en la posicion}
          write(maestro,act2);
        end; 
      leer(act,detalle);
    end; 
  close(detalle);
  close(maestro);
end; 

procedure exportarTxt( var maestro : amaestro);
var
  nuevo : text;
  a: alumno; 
begin
  assign(nuevo, 'alumnos.txt');
  rewrite(nuevo);
  reset(maestro);
  while (not eof(maestro)) do
    begin
      read(maestro,a);
      writeln(nuevo, a.codigo, '-', a.apellido,'-', a.nombre,'-', a.cursadasA,'-',a.materiasA)
    end;
  close(nuevo);
  close(maestro);
end;


var 
  maestro : amaestro;
  detalle : adetalle; 
BEGIN
  assign(maestro,'nombre');
  assign(detalle,'nombree');
  crearMaestro(maestro);
  crearDetalle(detalle);
  actualizarMaestro(maestro,detalle);
  exportarTxt(maestro);
END.

