program empleadosMenuRenovado;
type
  empleado = record
    numEmpleado :integer;
    apellido : String;
    nombre : String;
    edad :integer;
    dni : integer;
  end;
  archivo = file  of empleado;
  
{modulos del punto anterior}
Procedure leerEmpleado(var e: empleado);
begin
  writeln('ingrese el apellido del empleado: ');
  readln(e.apellido);
  if (e.apellido <> 'fin')then 
    begin
      writeln('ingrese el nombre del empleado: ');
      readln(e.nombre);
      writeln('ingrese el numero del empleado: ');
      readln(e.numEmpleado);
      writeln('ingrese la edad del empleado: ');
      readln(e.edad);
      writeln('ingrese el dni del empleado: ');
      readln(e.dni);
    end;
end;

procedure imprimirEmpleado(e: empleado);
begin
  writeln('numero empleado : ', e.numEmpleado , ' ');
  writeln('apellido : ', e.apellido, '  ');
  writeln('nombre : ', e.nombre, ' ');
  writeln('edad : ', e.edad, ' ' );
  writeln('dni : ', e.dni,'  ');
end;
  
procedure crearArchivo ( var a: archivo);
var
  e: empleado;
begin
  rewrite(a);
  leerEmpleado(e);
  while (e.apellido <> 'fin')do
    begin
      write(a,e);
      leerEmpleado(e);
    end;
  close(a); 
end;

procedure opcion1( var a : archivo);   
var
  reg: empleado;
  aux: string;
begin
  writeln('ingrese el apellido o nombre: ');
  readln(aux);
  reset(a);
  while (not eof(a))do
    begin
      read(a,reg);
      if ((reg.nombre = aux) or (reg.apellido = aux))then imprimirEmpleado(reg);
    end; 
  close(a);
end; 


procedure opcion2( var a : archivo);
var
  reg: empleado;
begin
  reset(a);
  while (not eof(a))do
    begin
      read(a,reg);
      imprimirEmpleado(reg);
    end; 
  close(a);
end; 
procedure opcion3(var a : archivo);
var
  reg: empleado;
begin
  reset(a);
  while (not eof(a))do
    begin
      read(a,reg);
      if ( reg.edad > 70 )then 
        imprimirEmpleado(reg);
    end; 
  close(a);
end; 

{modulos nuevos de este punto}

{añadir un empleado al archivo verificando que no exista }

procedure opcion4 (var a: archivo);
var
  e: empleado;
  seguir: boolean;
  aux: empleado;
begin
  seguir:= true;
  reset(a);
  leerEmpleado(e);
  while ( (not eof(a)) and (seguir <> false) )do
    begin
      read(a,aux);
      if (aux.numEmpleado = e.numEmpleado)then
        seguir:= false;
    end;
  if (seguir = true) then  write(a,e);          {si es true es xq no existe ese numero de empleado y esta en eof}
end;

procedure opcion5 (var a : archivo);
var
  cant: integer;
  edad: integer;
  i : integer;
  nombre: String;
  n: empleado;
begin
  writeln('ingrese la cantidad de personas a las cual le quiere cambiar la edad: ');
  readln(cant);
  reset(a);
  for i:= 1 to cant do
    begin
      seek(a,0);{me posiciono en el inicio del archivo, ya que si ingresa mas de uno, debo arrancar siempre del inicio}
      writeln('ingrese el nombre del empleado a modificar edad : ');
      readln(nombre);
      writeln('ingrese la edad modificada para el empleado: ');
      readln(edad);
      while( not eof(a))do
        begin
          read(a,n);
          if ( nombre = n.nombre) then 
            begin
              n.edad:= edad; 
              seek(a, filePos(a)-1);
              write(a,n);
            end
          else
            writeln('no existe el nombre ingresado');
        end;
    end; 
  close(a);
end;

{Exportar el contenido del archivo a un archivo de texto llamado “todos_empleados.txt”}
procedure opcion6(var a: archivo);
var
  aTexto: text;
  e: empleado;
begin
  assign(aTexto,'todos_empleados.txt');
  rewrite(aTexto);
  reset(a);
  while (not eof(a))do
    begin
      read(a,e);
      writeln(aTexto, e.apellido);
      writeln(aTexto, e.numEmpleado,' ',e.edad,' ',e.dni, ' ',e.nombre);
    end;
  close(a);
  close(aTexto);
  writeln('   se exporto correctamente     ');
end;

{Exportar a un archivo de texto llamado: “faltaDNIEmpleado.txt”, los empleados que no tengan cargado el DNI (DNI en 00).}
procedure opcion7(var a: archivo);
var
  aTextoD: text;
  e: empleado;
begin
  assign(aTextoD, 'faltaDniEmpleado.txt');
  rewrite(aTextoD);
  reset(a);
  while (not eof(a))do
    begin
      read(a,e);
      if (e.dni = 00)then
        writeln(aTextoD, e.apellido);
        writeln(aTextoD, e.numEmpleado,' ',e.edad,' ',e.dni, ' ',e.nombre);
    end;
  close(a);
  close(aTextoD);
  writeln('   se exporto correctamente los que no tienen dni     ');
end;



{variables del pp}
var
  a: archivo;
  nomA: string;
  opcion: integer;
BEGIN
  writeln('ingrese el nombre del archivo fisico: ');
  readln(nomA);
  assign(a,nomA);         {asigno con el nombre fisico}
  crearArchivo(a);
  opcion:= 1;  {por defecto} 
  while (opcion<> 0)do
    begin
      writeln('---------- menu -----------------');
      writeln('ingrese 1 si desea listar en pantalla los empleados con un apellido determinado : ');
      writeln('ingrese 2 si desea listar  a los empleados de a uno por linea : ');            
      writeln('ingrese 3 si desea listar en pantalla empleados a jubilarse : ');
      writeln('ingrese 4 si desea añadir uno o mas empleados al archivo: ');
      writeln('ingrese 5 si desea modificar la edad de un empleado:');
      writeln('ingrese 6 si desea exportar el archivo a un archivo txt:');
      writeln('ingrese 7 si desea exportar los empleados sin dni a un archivo de texto:');
      writeln('ingrese 0 si desea salir del menu : ' );
      readln(opcion);
      case opcion of
        0: writeln('fin de las operaciones');
        1: opcion1(a);
        2: opcion2(a);
        3: opcion3(a);
        4: opcion4(a);
        5: opcion5(a);
        6: opcion6(a);
        7: opcion7(a);
      else
        writeln('numero no valido');
      end
    end;
END.

