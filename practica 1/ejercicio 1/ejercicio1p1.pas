program archivoEnteros;
type
  archivo = file of integer;
{uses crt;}
var 
  enteros: archivo;
  num: integer;
  nomFisico : String;
BEGIN
  writeln('ingrese el nombre fisico del archivo : ');
  readln(nomFisico);
  assign(enteros, nomFisico);
  rewrite(enteros);
  writeln('ingrese un numero entero para guardar en el archivo : ');
  readln(num);
  while (num <> 3000)do
    begin
      write(enteros,num);
      writeln('ingrese otro numero entero para guardar en el archivo : ');
      readln(num);
    end;
  close(enteros);
END.

