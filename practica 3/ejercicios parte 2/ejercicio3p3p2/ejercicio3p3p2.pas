{
   
   Suponga que trabaja en una oficina donde está montada una LAN (red local). La
misma fue construida sobre una topología de red que conecta 5 máquinas entre sí y
todas las máquinas se conectan con un servidor central. Semanalmente cada
máquina genera un archivo de logs informando las sesiones abiertas por cada usuario
en cada terminal y por cuánto tiempo estuvo abierta. Cada archivo detalle contiene
los siguientes campos: cod_usuario, fecha, tiempo_sesion. Debe realizar un

procedimiento que reciba los archivos detalle y genere un archivo maestro con los
siguientes datos: cod_usuario, fecha, tiempo_total_de_sesiones_abiertas.
Notas:
● Los archivos detalle no están ordenados por ningún criterio.
● Un usuario puede iniciar más de una sesión el mismo día en la misma máquina,
o inclusive, en diferentes máquinas
   
}
program red_lan;
const
  tot = 2; // pongo 2 para probarlo rapido 
  valorAlto = 9999; 
type 

  sesion = record
    usuario : integer; 
    fecha : integer; // para facilidad uso como un entero 
    tiempo : real ; 
  end; 

  archivo = file of sesion;  
   
  vec_detalle = array[1..tot] of archivo; 
  
// CREACION DE LOS ARCHIVOS DETALLES


procedure leerReg(var reg : sesion);
begin
  writeln(' ingrese el  codigo de usuario -para finalizar ingrese 9999-');
  readln(reg.usuario);
  if (reg.usuario <> 9999)then
    begin
      writeln(' ingrese el  tiempo de sesion');
      readln(reg.tiempo);
      writeln(' ingrese la fecha de la sesion');
      readln(reg.fecha);
    end; 
end; 

procedure leer(var ar : archivo ;var reg : sesion);
begin
  if (not eof(ar))then
    read(ar,reg)
  else
    reg.usuario:= valorAlto; 
end; 


procedure informar(var detalle : archivo);
var
  reg : sesion; 
begin
  reset(detalle);
  leer(detalle,reg);
  while (reg.usuario <> valorAlto)do
    begin
      writeln(' cod usuario : ', reg.usuario, ' fecha : ', reg.fecha, ' tiempo : ', reg.tiempo:1:1);
      writeln(' ');
      leer(detalle,reg);
    end; 
  close(detalle);
end; 


procedure crearDetalles(var vec_detalle : vec_detalle);
var
  i: integer;
  detalle : archivo; 
  reg : sesion;  
begin
  writeln('creacion de los archivos detalles');
  for i:= 1 to tot do
    begin
      detalle:= vec_detalle[i]; 
      rewrite(detalle);
      leerReg(reg);
      while (reg.usuario <> valorAlto)do
        begin
          write(detalle,reg);
          leerReg(reg);
        end; 
      writeln('se creo el detalle numero : ', i );
      close(detalle);
    end; 
end; 







// CREACION DEL ARCHIVO MAESTRO 


procedure procesar ( var vec_detalle : vec_detalle ; var maestro : archivo);
// Al estar desordenado los archivos, lo que debo hacer es recorrer de a uno los 5 archivos
// e ir agregando y actualizando segun usuario y fecha de sesion, puede haber un usuario con sesiones
// en distintos dias y distintas fechas 
var
  i : integer;
  detalle : archivo;
  reg,reg2: sesion; 
  usuario_act, fecha_act: integer;   
begin
  rewrite(maestro);
  // Abro todos los detalles
  for i:= 1 to tot do
    begin
      reset(vec_detalle[i]);
    end; 
  // Empiezo a crear el maestro, recorriendo cada  detalle
  for i:= 1 to tot do
    begin
      detalle:= vec_detalle[i]; 
      leer(detalle,reg);
      // Recorro el archivo detalle hasta que se termine y voy completando
      while(reg.usuario <> valorAlto)do
        begin
          // actualizo con el reg actual del detalle
          usuario_act:= reg.usuario; 
          fecha_act:= reg.fecha; 
          seek(maestro,0);
          leer(maestro,reg2);
          // busco en el maestro si existe el registro 
          while ((reg2.usuario <> valorAlto) and (reg2.usuario <> usuario_act) and (reg2.fecha <> fecha_act))do
            begin
              leer(maestro,reg2);
            end;
          // salio porq lo encontro o porq no existe 
          if ((reg2.usuario = usuario_act) and (reg2.fecha = fecha_act))then
            begin
              // al ser el mismo usuario en la misma fecha actualizo
              reg2.tiempo:= reg2.tiempo + reg.tiempo; 
              seek(maestro,filepos(maestro)-1);
              write(maestro,reg2);
            end
          else
            begin
              // no existe entonces agrego al final del maestro como nuevo
              seek(maestro,filesize(maestro));
              write(maestro,reg);
            end; 
          // paso al siguiente elem de este detalle
          leer(detalle,reg);
        end; 
    end; 
  // Cierro todos los detalles
  for i:= 1 to tot do
    begin
      close(vec_detalle[i]);
    end; 
  close(maestro);
end; 




var
  maestro : archivo; 
  vec_detalles : vec_detalle; 
  i: integer; 
  istr : String; 
BEGIN
  // Hago el assign de todos los detalles
  for i:= 1 to tot do
    begin
      Str(i,istr);  //convierte un valor numerico en una cadena de caracteres
      assign(vec_detalles[i],'detalle'+ istr);
    end; 
  assign(maestro,'resultado');
  //crearDetalles(vec_detalles);
  writeln('como quedaron los detalles : ');
  writeln(' ');
  for i:= 1 to tot do
    begin
      writeln('res del detalle', i , ':'  );
      informar(vec_detalles[i]);
    end; 
  procesar(vec_detalles, maestro);
  writeln('resultado del maestro : ');
  informar(maestro);
END.

