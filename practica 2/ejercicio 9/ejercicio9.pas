{
Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
provincia y localidad. Para ello, se posee un archivo con la siguiente información: código de
provincia, código de localidad, número de mesa y cantidad de votos en dicha mesa.
Presentar en pantalla un listado como se muestra a continuación:
* 
* 
Código de Provincia
Código de Localidad               Total de Votos
................................ ......................
................................ ......................
Total de Votos Provincia: ____


Código de Provincia
Código de Localidad                Total de Votos
................................ ......................
Total de Votos Provincia: ___


…………………………………………………………..
Total General de Votos: ___   
NOTA: La información está ordenada por código de provincia y código de localidad.
}
program mesas_electorales;
const
  valorAlto = 999;
type

  mesa = record
    provincia : integer; 
    localidad : integer; 
    mesa : integer; 
    votos : integer; 
  end; 

  am = file of mesa; 


procedure leer(var maestro : am; var reg : mesa);
begin
  if (not eof(maestro))then
    read(maestro,reg)
  else
    reg.provincia := valorAlto; 
end; 


procedure informe(var maestro : am);
var
  votosL,votosP,tot:integer; 
  reg : mesa; 
  prov,loc:integer; 
begin
  reset(maestro);
  tot:=0; 
  leer(maestro,reg);
  while(reg.provincia <> valorAlto)do
    begin
      prov:= reg.provincia; 
      writeln('-------------------------------------');
      writeln('codigo de provincia : ', prov);
      votosP:=0;
      while ( reg.provincia = prov)do
        begin
          loc := reg.localidad;  
          votosL:=0; 
          while ( (reg.provincia = prov)and (reg.localidad = loc) )do
            begin
              votosL:= votosL + reg.votos;
              votosP:= votosP + reg.votos; 
              tot:= tot + reg.votos; 
              leer(maestro,reg);
            end;
          writeln('localidad : ', loc, '    votos : ', votosL);
        end;
      writeln('total votos de la provincia :  ', votosP);   
    end; 
  close(maestro);
end; 


var
  maestro : am; 
BEGIN
  assign(maestro, 'maestro');
  informe(maestro); 
END.

