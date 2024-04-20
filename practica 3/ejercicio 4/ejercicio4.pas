{
   
   
   Dada la siguiente estructura:

    type
      reg_flor = record
      nombre: String[45];
      codigo:integer;
      end;
      
      tArchFlores = file of reg_flor;

Las bajas se realizan apilando registros borrados y las altas reutilizando registros
borrados. El registro 0 se usa como cabecera de la pila de registros borrados: el
número 0 en el campo código implica que no hay registros borrados y -N indica que el
próximo registro a reutilizar es el N, siendo éste un número relativo de registro válido.


a. Implemente el siguiente módulo:
        Abre el archivo y agrega una flor, recibida como parámetro
        manteniendo la política descrita anteriormente
 
        procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);


b. Liste el contenido del archivo omitiendo las flores eliminadas. Modifique lo que
considere necesario para obtener el listado.
   
   
}


program flores;
type

  reg_flor = record
    nombre: String[45];
    codigo:integer;
  end;
      
  tArchFlores = file of reg_flor;


procedure agregarFlor (var a: tArchFlores ; nombre: string; codigo:integer);
var
  reg,nuevo: reg_flor;
  posicion: integer;  
begin
  reset(a);
  read(a,reg); //leemos el reg cabecera
  nuevo.nombre:= nombre; 
  nuevo,codigo:= codigo; 
  if (reg.codigo < 0)then
    begin
      posicion:= reg.codigo*-1; 
      seek(a,posicion);    //me posiciono en el reg borrado
      read(a,reg);         //como existe lo leo para obtener su codigo sig si tiene
      seek(a,filepos(a)-1);
      write(a,nuevo);       //escribo el nuevo
      seek(a,0);            //me posiciono al inicio y escribo el valor del cod sig si existe.
      write(a,reg);
      writeln('la flor se agrego con exito');
    end
  else
    begin
      writeln('no hay espacio para agregar otra flor');
    end;  
  close(a);
end; 



procedure imprimir(var a: archivos);
var
  reg: reg_flor; 
begin
  writeln('se listaran las flores que contiene este archivo');
  reset(a);
  seek(a,1); // salto el primer reg ya que es la cabecera de la pila 
  leer(a,reg);
  while(reg.codigo <> valorAlto)do
    begin
      // si el codigo no es mayor a cero, es porq esta dado de baja
      if (reg.codigo >0)then
        begin
          writeln('flor : ', reg.nombre , ' con el codigo : ', reg.codigo);
          writeln('------------------------------');
        end; 
    end; 
  close(a);
end; 



var

BEGIN
	
	
END.

