{
Se desea modelar la información necesaria para un sistema de recuentos de casos de covid
para el ministerio de salud de la provincia de buenos aires.
Diariamente se reciben archivos provenientes de los distintos municipios, la información
contenida en los mismos es la siguiente: código de localidad, código cepa, cantidad de
casos activos, cantidad de casos nuevos, cantidad de casos recuperados, cantidad de casos
fallecidos.
El ministerio cuenta con un archivo maestro con la siguiente información: código localidad,
nombre localidad, código cepa, nombre cepa, cantidad de casos activos, cantidad de casos
nuevos, cantidad de recuperados y cantidad de fallecidos.
* 
* 
Se debe realizar el procedimiento que permita actualizar el maestro con los detalles
recibidos, se reciben 10 detalles. Todos los archivos están ordenados por código de
localidad y código de cepa.
Para la actualización se debe proceder de la siguiente manera:
1. Al número de fallecidos se le suman el valor de fallecidos recibido del detalle.
2. Idem anterior para los recuperados.
3. Los casos activos se actualizan con el valor recibido en el detalle.
4. Idem anterior para los casos nuevos hallados.
Realice las declaraciones necesarias, el programa principal y los procedimientos que
requiera para la actualización solicitada e informe cantidad de localidades con más de 50
casos activos (las localidades pueden o no haber sido actualizadas).   
}

program covid;
const
  dimf = 10; 
  valorAlto = 9999;
type

  municipios= record
    codLocalidad: integer; 
    codCepa: integer; 
    casosActivos : integer; 
    casosNuevos : integer; 
    casosRecuperados : integer; 
    casosFallecidos: integer; 
  end; 

  principal = record
    codLocalidad : integer; 
    nomLocalidad : String; 
    codCepa : integer; 
    nomCepa : String; 
    casosActivos : integer; 
    casosNuevos : integer; 
    casosRecuperados : integer; 
    casosFallecidos: integer;
  end; 

  am = file of principal; 
  ad = file of municipios; 
  vec_detalle = array[1..dimf] of ad; 
  vec_reg = array[1..dimf] of municipios; 

//procedimientos necesarios

procedure leer (var detalle: ad; var reg : municipios);
begin
  if (not eof(detalle))then
    read(detalle,reg)
  else
    reg.codLocalidad:= valorAlto;
end; 

procedure minimo(var detalles : vec_detalle; var registros : vec_reg; var min : municipios);
var
  i:integer; 
  reg : municipios; 
  indice: integer; 
begin
  //debo buscar primero el cod de localidad min y dentro de el , el cod de cepa min
  reg.codLocalidad:= 9999;
  reg.codCepa:= 9999; 
  for i:= 1 to dimf do
    begin
      if (registros[i].codLocalidad < reg.codLocalidad)then
        begin
          if (registros[i].codCepa < reg.codCepa)then
            begin
              indice:= i; 
              reg:= registros[i]; 
            end; 
        end;
    end; 
  if (reg.codLocalidad <> valorAlto)then
    leer(detalles[indice],registros[indice]);
end;

procedure actualizarMaestro(var detalles : vec_detalle; var registros: vec_reg; var maestro: am);
var
  i: integer; 
  min: municipios;
  rm: principal; 
begin 
  reset(maestro);
  for i:= 1 to dimf do
    begin
      reset(detalles[i]);
      read(detalles[i],registros[i]);
    end; 
  //procedimiento de actualizacion
  minimo(detalles,registros,min);
  while (min.codLocalidad <> valorAlto)do
    begin
      read(maestro,rm);
      //si no es el que buscamos leemos otro reg del maestro
      while (rm.codLocalidad <> min.codLocalidad)do
        begin
          read(maestro,rm);
        end; 
      while ((min.codLocalidad = rm.codLocalidad) and (min.codCepa = rm.codCepa))do
        begin
          rm.casosFallecidos:= rm.casosFallecidos + min.casosFallecidos; 
          rm.casosRecuperados:= rm.casosRecuperados + min.casosRecuperados; 
          rm.casosActivos := min.casosActivos; 
          rm.casosNuevos := min.casosNuevos; 
        end;
      //una vez que ya procesamos un archivo del maestro lo volvemos a escribir en el actualizado
      seek(maestro,filepos(maestro)-1); 
      write(maestro,rm);
    end; 
  //ya termine de procesar y actualizar todos   
  close(maestro);
  for i:= 1 to dimf do
    begin
      reset(detalles[i]);
    end;
end; 

// lo recorro apare al archivo maestro para sacar las localidades con mas de 50 casos activos
//consultar si esta bien recorrerlo aparte . 
procedure leerM(var maestro : am; var reg: principal);
begin
  if (not eof(maestro))then
    read(maestro,reg)
  else
    reg.codLocalidad := valorAlto; 
end; 


procedure informe(var maestro : am; var tot : integer);
var
  rm : principal; 
  localidad: integer; 
  casos : integer; 
begin
  reset(maestro);
  read(maestro,rm);
  while (rm.codLocalidad <> valorAlto)do
    begin
      localidad:= rm.codLocalidad; 
      casos:=0; 
      while ( (rm.codLocalidad <> valorAlto)and   (rm.codLocalidad = localidad) )do
        begin
          casos:= casos + rm.casosActivos; 
          read(maestro,rm);
        end; 
      if (casos > 50) then tot:= tot + 1 ;
    end; 
  
  close(maestro);
end; 

var
  maestro: am; 
  i: integer; 
  detalles : vec_detalle; 
  registros : vec_reg; 
  istr: String; 
  tot: integer; 
BEGIN
  assign(maestro,'nombre_maestro');
  for i := 1 to dimf do
    begin
      Str(i,istr);
      assign(detalles[i],'detalle'+istr);
    end; 
  actualizarMaestro(detalles,registros,maestro);
  tot:=0; 
  informe(maestro,tot);
  writeln('la cantidad de localidades con casos activos mayor a 50 son : ', tot);
END.

