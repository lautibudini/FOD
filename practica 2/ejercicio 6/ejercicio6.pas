{Suponga que trabaja en una oficina donde está montada una LAN (red local). La misma fue
construida sobre una topología de red que conecta 5 máquinas entre sí y todas las
máquinas se conectan con un servidor central. Semanalmente cada máquina genera un
archivo de logs informando las sesiones abiertas por cada usuario en cada terminal y por
cuánto tiempo estuvo abierta. Cada archivo detalle contiene los siguientes campos:
cod_usuario, fecha, tiempo_sesion. Debe realizar un procedimiento que reciba los archivos
detalle y genere un archivo maestro con los siguientes datos: cod_usuario, fecha,
tiempo_total_de_sesiones_abiertas.
* 
Notas:
● Cada archivo detalle está ordenado por cod_usuario y fecha.
● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina, o
inclusive, en diferentes máquinas.
● El archivo maestro debe crearse en la siguiente ubicación física: /var/log.
}

program LAN;
const
  valorAlto = 999;
  dimf = 5;  
type


  //la mejor forma es hacerlo con un reg fecha
  //fechaa = record
  //  dia : integer; 
  //  mes : integer; 
  //  anio: integer; 
  //end; 
  
  infoDetalle = record
    cod : integer; 
    fecha  : integer; //fechaa; 
    tiempo_sesion : real ; 
  end; 
  
  infoMaestro = record
    cod : integer; 
    fecha : integer; //fechaa; 
    tiempo_total_de_sesiones_abiertas : real ; 
  end; 

  ad = file of infoDetalle; 
  vecDetalle = array[1..dimf] of ad;
  vecReg = array[1..dimf] of infoDetalle; 
  am = file of infoMaestro ; 


procedure leer( var detalle : ad ; var reg : infoDetalle);
begin
  if (not eof(detalle))then
    begin
      read(detalle, reg);
    end
  else
    reg.cod := valorAlto; 
end; 

procedure minimo ( var vecDetalle : vecDetalle ; var vecReg : vecReg; var min : infoDetalle);
var
  indice: integer; 
  i: integer; 
begin
  min.cod := 9999999;
  min.fecha := 999999;
  for i := 1 to dimf do
    begin
      if (vecReg[i].cod < min.cod) then
        begin
          if (vecReg[i].fecha < min.fecha) then
            begin
              indice:= i;
              min:= vecReg[i];
            end; 
        end;
    end; 
  //una vez que tengo un minimo actualizo en esa pos el proximo elemento, si no es valor alto 
  if(min.cod <> valorAlto)then
    leer(vecDetalle[indice], vecReg[indice]);
end; 


procedure crearMaestro(var maestro : am; var vecD: vecDetalle ; var vecR : vecReg);
var
  fact,cact: integer; 
  min : infoDetalle; 
  rmaestro : infoMaestro; 
  i: integer;
begin
  //creo el arch maestro
  rewrite(maestro);
  //abro los 5 detalles y leo el primer reg de cada uno 
  for i:= 1 to dimf do 
    begin
      reset(vecD[i]);
      leer(vecD[i], vecR[i]);
    end;
   
  minimo(vecD, vecR, min); 
  //merge
  while (min.cod <> valorAlto)do
    begin 
      //guardo el codigo actual 
      cact:= min.cod; 
      while (min.cod = cact)do
        begin
          //guardo la fecha que voy a iterar
          fact:= min.fecha;
          // copiamos un usario y ahora juntamos todas sus sesiones en UNA fecha
          rmaestro.cod:= min.cod;
          rmaestro.fecha:= min.fecha;
          rmaestro.tiempo_total_de_sesiones_abiertas:= min.tiempo_sesion; 
          while((min.cod <> valorAlto)and (min.cod = cact)and(min.fecha = fact))do
            begin
              //mientras coincida la fecha suma la sesion y lee otro
              rmaestro.tiempo_total_de_sesiones_abiertas:= rmaestro.tiempo_total_de_sesiones_abiertas + min.tiempo_sesion;
              minimo(vecD,vecR,min);
            end; 
          //cuando sale es xq ya termino un archivo entonces debo agregarlo al maestro
          write(maestro,rmaestro);
        end; 
    end; 
  // como ya no trabajo mas con los archivos los cierro 
  close(maestro);
  for i:= 1 to dimf do 
    begin
      close(vecD[i]);
    end;
end; 

var 
  maestro : am; 
  vecD: vecDetalle; 
  vecR: vecReg; 
  i: integer ;
  istr: String; 
BEGIN
  assign(maestro,'nombre_de_maestro');
  for i := 1 to dimf do
    begin
      Str(i,istr); 
      assign(vecD[i], 'detalle '+ istr);
    end; 
  //procedimiento
  crearMaestro(maestro,vecD,vecR);
END.
