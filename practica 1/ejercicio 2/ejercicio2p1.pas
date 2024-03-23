program ejercicio2p1;
type
  archivo = file of integer;
  
procedure procesarArchivo(var a: archivo);
var
  cantMenores: integer; {menores a 1500}       {cant de nums para promedio y su suma}
  cantNum: integer;
  sumaNum: integer;
  num:integer;
begin
  cantMenores:=0;
  cantNum:= 0;
  sumaNum:=0;
  writeln('contenido del archivo: ');
  while (not eof(a))do
    begin
      read(a,num);       {leo el numero y lo guardo en el registro}
      if(num<1500) then cantMenores:= cantMenores + 1;    {si es menor a 1500 sumo uno}
      cantNum:= cantNum + 1;                              {cuentas para el promedio}
      sumaNum:= sumaNum + num;
      writeln(num);
    end;
  writeln('la cantidad de numeros menores a 1500 son : ', cantMenores);
  writeln('el promedio de numeros ingresados es : ', (sumaNum/cantNum):3:3);
end;
var
  enteros: archivo;
  nom: String;
BEGIN
  writeln('ingrese el nombre del archivo fisico');
  readln(nom);
  assign(enteros,nom);
  reset(enteros); {abro el archivo para trabajar en el }
  procesarArchivo(enteros);
  close(enteros); {cierro el archivo ya que no trabajo mas con el}
END.

