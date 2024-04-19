{

Realizar un programa que genere un archivo de novelas filmadas durante el presente
año. De cada novela se registra: código, género, nombre, duración, director y precio.
El programa debe presentar un menú con las siguientes opciones:

   a. Crear el archivo y cargarlo a partir de datos ingresados por teclado. Se
utiliza la técnica de lista invertida para recuperar espacio libre en el
archivo. Para ello, durante la creación del archivo, en el primer registro del
mismo se debe almacenar la cabecera de la lista. Es decir un registro
ficticio, inicializando con el valor cero (0) el campo correspondiente al
código de novela, el cual indica que no hay espacio libre dentro del
archivo.
* 
   b. Abrir el archivo existente y permitir su mantenimiento teniendo en cuenta el
inciso a., se utiliza lista invertida para recuperación de espacio. En
particular, para el campo de ´enlace´ de la lista, se debe especificar los
números de registro referenciados con signo negativo, (utilice el código de
novela como enlace).Una vez abierto el archivo, brindar operaciones para:

     i. Dar de alta una novela leyendo la información desde teclado. Para
esta operación, en caso de ser posible, deberá recuperarse el
espacio libre. Es decir, si en el campo correspondiente al código de
novela del registro cabecera hay un valor negativo, por ejemplo -5,
se debe leer el registro en la posición 5, copiarlo en la posición 0
(actualizar la lista de espacio libre) y grabar el nuevo registro en la
posición 5. Con el valor 0 (cero) en el registro cabecera se indica
que no hay espacio libre.

     ii. Modificar los datos de una novela leyendo la información desde
teclado. El código de novela no puede ser modificado.
     
     iii. Eliminar una novela cuyo código es ingresado por teclado. Por
ejemplo, si se da de baja un registro en la posición 8, en el campo
código de novela del registro cabecera deberá figurar -8, y en el
registro en la posición 8 debe copiarse el antiguo registro cabecera.



c. Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
NOTA: Tanto en la creación como en la apertura el nombre del archivo debe ser
proporcionado por el usuario.

   
   
}
program novelas;
const
  valorAlto = 9999; 
type

  novela = record
    cod : integer; 
    genero : String; 
    nombre : String; 
    duracion  : real;
    director : String; 
    precio : integer; 
  end; 

  archivo = file of novela ; 
  
  


procedure leer(var a : archivo ; var reg : novela );
begin
  if (not eof(a))then
    read(a,reg)
  else
    reg.cod:= valorAlto; 
end; 


procedure leerNombre(var reg: novela);
begin
  writeln('ingrese el codigo de la novela : ' );
  readln(reg.cod);
end; 

procedure leerResto(var reg: novela);
begin
  writeln('ingrese el genero de la novela : ' );
  readln(reg.genero);
  writeln('ingrese el nombre de la novela : ' );
  readln(reg.nombre);
  writeln('ingrese la duracion de la novela : ' );
  readln(reg.duracion);
  writeln('ingrese el director de la novela : ' );
  readln(reg.director);
  writeln('ingrese el precio de la novela : ' );
  readln(reg.precio);
end; 




// crea un archivo de novelas, con datos ingresados desde teclado
// donde la primera posicion se guardara el ultimo elem eliminado, iniciado en 0
// metodo lista invertida 
procedure main(var a : archivo);
var
  reg: novela ;
  nom: String; 
begin
  writeln('ingrese el nombre fisico del archivo  a crear : ');
  readln(nom); 
  assign(a,nom);
  rewrite(a);
  // la primera pos es para guardar las posiciones de la lista invertida: 
  reg.cod:= 0; 
  write(a,reg);
  //empiezo  a cargar el archivo, corto cuando cod == valorAlto
  leerNombre(reg);
  while (reg.cod <> valorAlto)do
    begin
      leerResto(reg);
      //agrego
      write(a,reg);
      leerNombre(reg);
    end; 
  close(a);
end; 



{procedimientos para el menu}


//Dar de alta una novela leyendo la información desde teclado
procedure opcion1(var a : archivo);
var
  reg,indice: novela; 
begin
  reset(a);
  //pido toda la info necesaria
  leerNombre(reg);
  leerResto(reg);
  leer(a,indice);
  if (indice.cod <> 0)then // si no tiene cero es xq hay un indice negativo
    begin
      seek(a,(indice.cod*-1)); //copio el borrado con el enlace si hay de la l-i
      read(a,indice);
      seek(a,filepos(a)-1);
      write(a,reg);         //escribo el nuevo reg
      //copio en el reg principal el valor de indice
      seek(a,0);
      write(a,indice);
    end
  else                // sino lo agrega al final
    begin
      seek(a,filesize(a)); 
      write(a,reg);
    end; 
  close(a);
end; 


//Modificar los datos de una novela leyendo la información desde teclado
procedure opcion2(var a: archivo);

  
  procedure preguntar(var r: novela);
  var
    valor: integer; 
  begin
    valor := 1; // por defecto
    // hacemos un while ya que podrian modificar mas de una cosa.
    while (valor <> 0)do
      begin
        writeln ('SELECCIONE QUE DESEA MODIFICAR DE LA NOVELA : ');
	    writeln ('1) PRECIO');
	    writeln ('2) GENERO');
	    writeln ('3) NOMBRE');
	    writeln ('4) DIRECTOR');
	    writeln ('5) DURACION');
	    writeln('0) SI NO QUIERE MODIFICAR NADA MAS ');
	    readln (valor);
	    case valor of 
	    1: begin
			writeln('ingrese el precio nuevo: '); readln (r.precio);
		   end;
	    2: begin
			writeln('ingrese el nuevo genero: '); readln (r.genero);
		end;
	    3: begin
			writeln('ingrese el nuevo nombre: '); readln (r.nombre);
		end;
	    4: begin
			writeln('ingrese el nuevo director : '); readln (r.director);
		end;
	    5: begin
			writeln('ingrese la nueva duracion : '); readln (r.duracion);
		end;
		0: writeln('fin de modificaciones ');
	    else 
	      writeln('opcion no valida ');
	    end; 
      end; 
  end; 
var
  reg: novela;
  nro:integer; 
begin
  reset(a);
  // me posiciono en el primer reg valido (no es necesario)
  seek(a,1);
  leer(a,reg);
  writeln('ingrese el codigo de novela a modificar : ');
  readln(nro);
  while((reg.cod <> valorAlto) and (reg.cod <> nro))do
    begin
      leer(a,reg);
    end; 
  // puedo encontrarlo o no entonces : 
  if (reg.cod = nro)then
    begin
      preguntar(reg);
      seek(a,filepos(a)-1);
      write(a,reg);
    end
  else
    begin
      writeln('el codigo ingresado no existe o no es valido');
    end; 
  close(a);
end; 


//Eliminar una novela cuyo código es ingresado por teclado.
procedure opcion3(var a: archivo);
var
  reg,aux: novela; 
  num,inegativo: integer; 
begin
  reset(a);
  writeln('ingrese el codigo de novela a borrar : ');
  readln(num);
  read(a,aux); //leo la posicion cero para poder modificar
  leer(a,reg); //arranco a leer los registros del archivo
  while((reg.cod <> valorAlto) and (reg.cod <> num))do
    begin
      leer(a,reg);
    end; 
  if (reg.cod = num)then
    begin
      //en la posicion a borrar escribo el reg del indice prox y queda borrado logicamente
      seek(a,filepos(a)-1);
      inegativo:= filepos(a)*-1; // guardo el indice en negativo para luego escribirlo en la cabecera
      write(a,aux);
      //en la cabecera de mi archivo, dejo los datos con el indice negativo en donde podremos hacer un alta 
      seek(a,0);
      reg.cod:= inegativo; //paso el indice a negativo 
      write(a,reg);
    end
  else
    begin
      writeln('el codigo ingresado no existe o no es valido');
    end; 
  close(a);
end; 


//Listar en un archivo de texto todas las novelas, incluyendo las borradas, que
//representan la lista de espacio libre. El archivo debe llamarse “novelas.txt”.
procedure exportar(var a : archivo);
var
  txt : text; 
  reg : novela; 
begin
  assign(txt,'novelas.txt');
  rewrite(txt);
  reset(a);
  //me posiciono en el primer registro valido , no el primero
  seek(a,1);
  leer(a,reg);
  while (reg.cod <> valorAlto)do
    begin
      if (reg.cod > 0) then
	    writeln(txt,'CODIGO: ',reg.cod,' NOMBRE: ',reg.nombre,' GENERO: ',reg.genero,' DIRECTOR: ',reg.director,' DURACION: ',reg.duracion,' PRECIO: ',reg.precio)
      else
	    writeln(txt,'Espacio libre'); 
	  leer(a,reg);
    end; 
  close(txt);
  close(a);
end; 

procedure menu(var a: archivo);
var
  num: integer; 
begin
  num:=1; 
  writeln('BIENVENIDO AL MENU PRINCIPAL');
  while (num <> 0) do
    begin
      writeln('INGRESE LA OPCION QUE DESEA REALIZAR : ');
      writeln('1- SI desea agregar una novela nueva al archivo : ');
      writeln('2- SI desea modificar los datos de una novela : ');
      writeln('3- SI desea eliminar una novela del archivo ');   
      writeln('0- Si desea salir del menu : ');
      readln(num);
      case num of 
      1: opcion1(a);
      2: opcion2(a);
      3: opcion3(a);
      0: writeln('MENU FINALIZADO ');
      else
        writeln('Opcion  incorrecta ');
      end; 
    end;
  exportar(a); 
end; 


var 
  a: archivo; 
BEGIN
  main(a);
  menu(a);
END.

