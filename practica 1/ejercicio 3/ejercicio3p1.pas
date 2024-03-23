program menuEmpleados;
type
  empleado = record
    numEmpleado :integer;
    apellido : String;
    nombre : String;
    edad :integer;
    dni : integer;
  end;
  archivo = file  of empleado;
  
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
  aux: String; 
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

var
  a: archivo;
  nomA: String;
  num: integer;
BEGIN
  num := 9; {por defecto para que entre a la iteracion}
  writeln('ingres el nombre del archivo fisico: ');
  readln(nomA);
  assign(a,nomA);         {asigno con el nombre fisico}
  crearArchivo(a);         
  {hasta aca es el inciso A de creacion del archivo }
  {para hacer el menu hay q hacer un loop}
  while (num <> 0) do
    begin
      writeln('ingrese 1 si desea listar en pantalla los empleados con un apellido determinado : ');
      writeln('ingrese 2 si desea listar  a los empleados de a uno por linea : ');            
      writeln('ingrese 3 si desea listar en pantalla empleados a jubilarse : ');
      writeln('ingrese 0 si desea salir del menu : ' );
      readln(num);
      case num of
        0: writeln('fin de las operaciones');
        1: opcion1(a);
        2: opcion2(a);
        3: opcion3(a);
      else
        writeln('opcion incorrecta');
      end
    end;
END.

