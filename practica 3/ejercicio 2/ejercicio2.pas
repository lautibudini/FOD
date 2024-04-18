{
 Definir un programa que genere un archivo con registros de longitud fija conteniendo
información de asistentes a un congreso a partir de la información obtenida por
teclado. Se deberá almacenar la siguiente información: nro de asistente, apellido y
nombre, email, teléfono y D.N.I. Implementar un procedimiento que, a partir del
archivo de datos generado, elimine de forma lógica todos los asistentes con nro de
asistente inferior a 1000.
Para ello se podrá utilizar algún carácter especial situándolo delante de algún campo
String a su elección. Ejemplo: ‘@Saldaño’.
}

program congreso;
const 
  valorAlto = 9999; 
type
  
  asistente = record
    nro: integer; 
    apellido: String; 
    nombre : String; 
    email : String; 
    telefono : integer; 
    dni : integer; 
  end; 

  archivo = file of asistente; 
  
procedure crear(var a: archivo);
var
  registro: asistente; 
begin
  rewrite(a);
  writeln('ingrese el numero de asistente: ');
  readln(registro.nro);
  while (registro.nro <> valorAlto)do
    begin
      writeln('ingrese el apellido del asistente: ');
      readln(registro.apellido);
      writeln('ingrese el nombre del asistente: ');
      readln(registro.nombre);
      writeln('ingrese el email del asistente: ');
      readln(registro.email);
      writeln('ingrese el telefono del asistente: ');
      readln(registro.telefono);
      writeln('ingrese el dni del asistente: ');
      readln(registro.dni);
      //escribo en el archivo el empleado: 
      write(a,registro);
      
      writeln('ingrese el numero de asistente: ');
      readln(registro.nro);
    end; 
  close(a);  
end; 




procedure leer(var a :archivo; var reg: asistente);
begin
  if (not eof (a))then
    read(a,reg)
  else
    reg.nro := valorAlto; 
end; 

{borro logicamente los aistentes con numero menor a 1000}
{pondre un @ delante de su nombre para identificarlos}
procedure eliminar(var a : archivo);
var
  reg: asistente; 
begin
  reset(a);
  leer(a,reg);
  while (reg.nro <> valorAlto)do
    begin
      if (reg.nro < 1000)then
        begin
          reg.nombre:= '@' + reg.nombre;
          seek(a,filepos(a)-1);
          write(a,reg);
        end; 
      leer(a,reg);
    end; 
  close(a);
end; 

{modulo para imprimir y poder corroborar que este correcto}

procedure imprimir(var a : archivo);
var
  reg : asistente; 
begin
  reset(a);
  leer(a,reg);
  while (reg.nro <> valorAlto)do
    begin
      writeln('nombre del asistente : ', reg.nombre);
      writeln('numero del asistente: ', reg.nro);
      leer(a,reg);
    end; 
  close(a);
end; 

var 
  a: archivo; 
BEGIN
  assign(a, 'asistentes');
  crear(a);
  eliminar(a);
  imprimir(a);
END.

