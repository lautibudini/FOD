{A partir de información sobre la alfabetización en la Argentina, se necesita actualizar un
archivo que contiene los siguientes datos: nombre de provincia, cantidad de personas
alfabetizadas y total de encuestados. Se reciben dos archivos detalle provenientes de dos
agencias de censo diferentes, dichos archivos contienen: nombre de la provincia, código de
localidad, cantidad de alfabetizados y cantidad de encuestados. Se pide realizar los módulos
necesarios para actualizar el archivo maestro a partir de los dos archivos detalle.

NOTA: Los archivos están ordenados por nombre de provincia y en los archivos detalle
pueden venir 0, 1 ó más registros por cada provincia.
 
}
program Alfabetizacion;
const
  valorAlto = 'zzz';
type
  
  main = record
    provincia: String; 
    alfab : integer; 
    encuestados : integer; 
  end; 
  
  agencia = record
    provincia : String;
    localidad : integer;
    alfab : integer; 
    encuestados : integer; 
  end; 
  
  aM = file of main; 
  aD = file of agencia; 
  

{modulos para actualizar el maestro}
procedure leer(var detalle: aD ; var det : agencia);
begin
  if (not eof(detalle))then
    read(detalle,det)
  else
    det.provincia := valorAlto;
end; 


procedure minimo(var detalle1,detalle2: aD; var det1: agencia; var det2: agencia;  var min : agencia);
begin
  if (det1.provincia <det2.provincia)then
    begin
      min:= det1; 
      leer(detalle1, det1);
    end
  else 
    min:= det2;
    leer(detalle2,det2);
end; 
  
  
procedure actualizar(var maestro: aM ; var detalle1, detalle2: aD);
var
  act: main; 
  det1: agencia;
  det2: agencia; 
  min : agencia; 
begin
  reset(maestro); reset(detalle1); reset(detalle2);
  leer(detalle1,det1); leer(detalle2,det2); 
  minimo(detalle1,detalle2,det1, det2, min);
  //read(maestro, act); va mejor dentro del while.
  while (min.provincia <> 'zzz')do
    begin
      read(maestro, act);
      //busco en el maestro la provincia, si no estoy en ella
      while (min.provincia <> act.provincia) do
        begin
          read(maestro, act);
        end; 
      //si hay mas de un reg en el detalle debo iterar
      while (min.provincia = act.provincia)do
        begin
          act.alfab := act.alfab + min.alfab; 
          act.encuestados := act.encuestados + min.encuestados; 
          minimo(detalle1,detalle2,det1,det2,min);
        end; 
      //una vez ya iterado los iguales se actualiza el maestro
      seek(maestro,filepos(maestro)-1);
      write(maestro,act);
    end; 
  close(maestro);close(detalle1);close(detalle2);
end;  
  
var
  maestro: aM;
  detalle1,detalle2 : aD; 
BEGIN
  assign(maestro,'maestroo');
  assign(detalle1,'detallee1');
  assign(detalle2,'detallee2');
  actualizar(maestro,detalle1,detalle2);
END.

