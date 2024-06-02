{
   
   
   Se cuenta con un archivo que almacena información sobre especies de aves en vía
de extinción, para ello se almacena: código, nombre de la especie, familia de ave,
descripción y zona geográfica. El archivo no está ordenado por ningún criterio. Realice
un programa que elimine especies de aves, para ello se recibe por teclado las
especies a eliminar. Deberá realizar todas las declaraciones necesarias, implementar
todos los procedimientos que requiera y una alternativa para borrar los registros. 
* 
* Para ello deberá implementar dos procedimientos, uno que marque los registros a borrar y
posteriormente otro procedimiento que compacte el archivo, quitando los registros
marcados. Para quitar los registros se deberá copiar el último registro del archivo en la
posición del registro a borrar y luego eliminar del archivo el último registro de forma tal
de evitar registros duplicados.
Nota: Las bajas deben finalizar al recibir el código 500000.
   
   
}
program especies;
const
  valorAlto = 9999; 
type

  ave = record
    cod : integer; 
    nombre : String; 
    familia : String; 
    descripcion : String; 
    zona : String ;
  end; 

  //El archivo no está ordenado por ningún criterio
  archivo = file of ave; 

// PROCEDIMIENTOS COMPLEMENTARIOS PARA PROBAR EL PROGRAMA


// mi corte es cuando en cod me mande valorAlto q termino el archivo. No especificado en el enunciado.
procedure leer(var a: archivo; var reg :ave);
begin
  if (not eof(a))then
    read(a,reg)
  else
    reg.cod:= valorAlto; 
end; 


procedure leerReg(var reg : ave);
begin
  writeln('ingrese el codigo del ave : (corta el ingreso con - 9999 -)');
  readln(reg.cod);
  if (reg.cod <> valorAlto)then
    begin
      writeln('ingrese el nombre del ave:  ');
      readln(reg.nombre);
      writeln('ingrese la familia del ave:  ');
      readln(reg.familia);
      writeln('ingrese la descripcion del ave:  ');
      readln(reg.descripcion);
      writeln('ingrese la zona geografica del ave:  ');
      readln(reg.zona);
    end; 
end; 

procedure crearArchivo(var a : archivo);
var
  reg :ave; 
begin
  rewrite(a);
  leerReg(reg);
  while ( reg.cod <> valorAlto)do
    begin
      write(a,reg);
      leerReg(reg);
    end; 
  close(a);
end;



procedure imprimir (var a : archivo);
var
  reg : ave; 
begin
  reset(a);
  leer(a,reg);
  while (reg.cod <> valorAlto)do
    begin
      writeln('el nombre del ave:  ', reg.nombre );
      writeln('el codigo del ave : ', reg.cod);
      writeln(' ');
      leer(a,reg);
    end; 
  close(a);
end; 






// PROCEDIMIENTOS PARA LA ELIMINACION Y COMPACTACION DE LOS ARCHIVOS.

procedure eliminacionLogica(var a : archivo; var cant_eliminados: integer);
var
  cod : integer;
  reg : ave;  
begin
  writeln(' ingrese el codigo de ave a eliminar : - Termina este procedimiento ingresando 5000 - ');
  readln(cod);
  reset(a);
  while (5000 <> cod)do
    begin
      seek(a,0);
      leer(a,reg);
      // Busco el codigo de mi ave.
      while ( (reg.cod <> valorAlto) and (reg.cod <> cod))do
        begin
          leer(a,reg);
        end; 
      // Si existe modifico , sino informo 
      if (reg.cod = cod)then
        begin
          // le pongo la marca de borrado
          reg.nombre:= 'eliminado';
          seek(a,filepos(a)-1);
          write(a,reg); 
          // Sumo uno a los eliminados.
          cant_eliminados:= cant_eliminados +1; 
          writeln('marcado como borrado. ');
        end
      else
        writeln('no existe el codigo');
      // Pido otro codigo de ave : 
      writeln(' ingrese el codigo de ave a eliminar : - Termina este procedimiento ingresando 5000 - ');
      readln(cod);
    end; 
  close(a);
end; 



procedure compactar(var archivo : archivo; cant_eliminados: integer);
var
  reg,aux: ave; 
  pos : integer; 
  dl: integer;
  borrados : integer;
begin
  {Debo recorrer el archivo hasta hacer la baja fisica de los eliminados, y en cada posicion de eliminacion logica, tomo
   el ultimo elemento y lo intercambio por el ultimo. Ese ultimo puede no ser valido, por lo que debo buscar uno que si lo sea. 
  
  Se presenta una situacion donde puede haber mas de un elemento al final del archivo eliminados de manera logica, 
  asi q para trabajar de esta manera, me desago de ellos antes de reemplazar un eliminado por uno del final 
  * ej: [valido, valido, eliminado, valido, eliminado,eliminado]
  
  al querer reemplazar el primer eliminado por el ultimo estaria cometiendo un error, por ende debo buscar 
  hasta tener uno valido en el final para poder reemplazar.
  pero pueden ocurrir dos casos: 
  *  Donde a partir de un elimando todos despues de ese sean eliminados [valido, eliminado, eliminado , eliminado]
  * ,o el ya mencionado, entonces debemos manejar las posiciones del reg (pos) a reemplazar y el reg (pos) que encontre como valido.
  
  Por ultimo, puede ocurrir el caso que todos los archivos esten eliminados, en ese caso trunco al principio, lo manejo con contadores.
  * }
  
  
  reset(archivo);
  // Para no recorrer todo el archivo, llevo un contador de borrados y corto cuando llegue a esa cantidad de borrados.
  borrados:= 0;
  // Uso dl como el ultimo registro valido que tengo en el archivo.
  dl:= fileSize(archivo)-1;
  if (cant_eliminados = (dl + 1))then
    begin
      writeln('todos los archivos estan eliminados, no queda ningun elemento valido');
      // Como esta posicionado en el principio del archivo trunco ahi 
      truncate(archivo);
    end
  else
    begin
	  leer(archivo,reg);
	  while ((reg.cod <> valorAlto) and (borrados <> cant_eliminados) )do
		begin
		  // Si encuentro un registro borrado entonces : 
		  if (reg.nombre = 'eliminado')then
			begin
			  // me guardo la posicion a reemplazar. Es la anterior ya que al leerlo avanzo.
			  pos:= filepos(archivo)-1;
			  // Leo el ultimo registro para ver si es un eliminado o esta disponible.
			  seek(archivo,dl);
			  // Lo leo con auxiliar asi lo reemplazo, y no me quedan repetidos
			  leer(archivo,aux);
			  // Si es un eliminado debo verificar que como ultimo me quede uno valido en dl.
			  while(aux.nombre = 'eliminado' )do
				begin
				  //Como al leerlo avanza al siguiente, entonces me posiono en el anterior al que lei.
				  dl:= dl -1;
				  seek(archivo,dl);
				  leer(archivo,aux);
				end;
			  // Puede entrar o no al while dependiendo si el ultimo esta o no eliminado.
			  // Entre o no voy a estar parado uno despues al registro valido seria dl +1.
			  // Aca debo corroborar si a partir del que quiero reemplazar estan todos borrados o puedo hacer el intercambio: 
			  if (pos>=dl)then
				begin
				  {Si la posicion a reemplazar es mas grande que mi dl(registro no borrado) entonces debo truncar todo a partir de pos
				   ya que estan todos eliminados}
				   // Entonces para que salga del while y trunque me posiciono el el fin del archivo para que tome valor alto. 
				  //seek(archivo,filesize(archivo));
				  borrados:= cant_eliminados;
				end
			  else
				begin
				  // Sino , puedo hacer el intercambio
				  seek(archivo,dl);
				  // Escribo en dl el borrado logicamente que estaba en pos
				  write(archivo,reg);
				  // Escribo en pos el registro valido e incremento en uno los borrados(reemplazados).
				  seek(archivo,pos);
				  write(archivo,aux);
				  dl:= dl - 1; 
				  borrados:= borrados + 1; 
				end;
			end; 
		  //leo el siguiente elemento.
		  leer(archivo,reg);
		end; 
	  // Cuando salgo debo truncar en dl +1 , ya que es el primer registro no valido.
	  dl:= dl +1;
	  seek(archivo,dl);
	  truncate(archivo);
    end; 
  close(archivo);
end; 



var
  a : archivo; 
  cant_eliminados: integer;
BEGIN
  assign(a,'aves');
  //crearArchivo(a);
  writeln('---------- archivo original -------------------------------------');
  imprimir(a);
  eliminacionLogica(a,cant_eliminados);
  writeln('-----------archivo despues de la eliminacion logica -------------- ');
  imprimir(a);
  writeln('Cantidad de archivos eliminados : ', cant_eliminados);
  compactar(a,cant_eliminados);
  writeln('-----------archivo final, compactado -----------------------------');
  imprimir(a);
END.

