{
   
Se necesita contabilizar los votos de las diferentes mesas electorales registradas por
localidad en la provincia de Buenos Aires. Para ello, se posee un archivo con la
siguiente información: código de localidad, número de mesa y cantidad de votos en
dicha mesa. Presentar en pantalla un listado como se muestra a continuación:
Código de Localidad Total de Votos
................................ ......................
................................ ......................
Total General de Votos: ………………
NOTAS:
● La información en el archivo no está ordenada por ningún criterio.
● Trate de resolver el problema sin modificar el contenido del archivo dado.
● Puede utilizar una estructura auxiliar, como por ejemplo otro archivo, para
llevar el control de las localidades que han sido procesadas.
   
}

program mesas_electorales;
const
  valorAlto = 9999; 
type

  informacion = record
    codigo: integer; 
    mesa : integer; 
    cantVotos: integer; 
  end; 

  aM = file of informacion; 
  
  localidad = record
    codigo : integer; 
    cantVotos : integer; 
  end; 
  
  aNuevo = file of localidad; 
  







// MODULOS PARA CREAR EL ARCHIVO MAESTRO 


procedure leerM(var maestro : aM; var reg :informacion );
begin
  if(not eof(maestro))then
    read(maestro,reg)
  else
    reg.codigo:= valorAlto; 
end; 

procedure leerN(var nuevo: aNuevo; var reg : localidad);
begin
  if(not eof(nuevo))then
    read(nuevo,reg)
  else
    reg.codigo:= valorAlto; 
end; 


procedure leerReg(var reg : informacion);
begin
  writeln(' ingrese el codigo de la localidad : ');
  readln(reg.codigo);
  if (reg.codigo <> valorAlto)then
    begin
      writeln('ingrese el numero de mesa : ');
      readln(reg.mesa);
      writeln(' ingrese la cantidad de votos de esa mesa  : ');
      readln(reg.cantVotos);
    end; 
end; 


procedure cargarMaestro(var original : aM);
var
  reg : informacion; 
begin
  writeln('creacion del archivo principal : ');
  writeln(' ');
  rewrite(original);
  leerReg(reg); 
  while (reg.codigo <> valorAlto)do
    begin
      write(original,reg);
      leerReg(reg); 
    end; 
  close(original);
  writeln(' se creo el archivo principal');
end; 

procedure informar2(var maestro : aM);
var
  reg: informacion; 
begin
  reset(maestro);
  leerM(maestro,reg);
  while (reg.codigo <> valorAlto)do
    begin
      writeln(' Codigo de localidad : ', reg.codigo, ' Cantidad de votos en la localidad : ', reg.cantVotos);
      writeln(' ');
      leerM(maestro,reg);
    end; 
  close(maestro);
end; 


// MODULOS PARA CREAR EL ARCHIVO AUXILIAR & INFORMAR


procedure procesar(var maestro: aM; var nuevo : aNuevo; var votosTot: integer);
var
  reg: informacion; 
  reg2: localidad; 
begin 
  reset(maestro);
  rewrite(nuevo);
  // Empiezo a recorrer el archivo principal, leyendo todos sus registros
  leerM(maestro,reg);
  while (reg.codigo <> valorAlto)do
    begin
      // Busco en el archivo nuevo, si no esta entonces agrego al final y sino actualizo
      seek(nuevo,0);
      leerN(nuevo,reg2);
      while((reg2.codigo <> valorAlto) and (reg2.codigo <> reg.codigo))do
        begin
          leerN(nuevo,reg2);
        end; 
      // Pudo salir xq lo encontro o no
      if (reg2.codigo = reg.codigo)then
        begin
          //actualizo 
          reg2.cantVotos := reg2.cantVotos + reg.cantVotos; 
          seek(nuevo,filepos(nuevo)-1);
          write(nuevo,reg2);
        end
      else
        begin
          // Agrego ya que no existe , y esta posicionado en eof
          reg2.codigo := reg.codigo;
          reg2.cantVotos := reg.cantVotos;  
          write(nuevo,reg2);
        end;  
      votosTot:= votosTot + reg.cantVotos;
      leerM(maestro,reg); 
    end; 
  close(maestro);
  close(nuevo);
end; 

procedure informar(var nuevo : aNuevo; votosTot : integer);
var
  reg: localidad; 
begin
  reset(nuevo);
  leerN(nuevo,reg);
  while (reg.codigo <> valorAlto)do
    begin
      writeln(' Codigo de localidad : ', reg.codigo, ' Cantidad de votos en la localidad : ', reg.cantVotos);
      writeln(' ');
      leerN(nuevo,reg);
    end; 
  writeln(' Total general de votos : ', votosTot); 
  close(nuevo);
end; 

var
  nuevo : aNuevo; 
  original : aM; 
  votosTot: integer; 
BEGIN
  votosTot:=0;
  assign(original,'maestro');
  assign(nuevo,'nuevo'); 
  //cargarMaestro(original);
  informar2(original);
  procesar(original,nuevo,votosTot);
  informar(nuevo,votosTot);	
END.

