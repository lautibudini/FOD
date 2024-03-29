{ Una empresa posee un archivo con información de los ingresos percibidos por diferentes
empleados en concepto de comisión, de cada uno de ellos se conoce: código de empleado,
nombre y monto de la comisión. La información del archivo se encuentra ordenada por
código de empleado y cada empleado puede aparecer más de una vez en el archivo de
comisiones.
* 
Realice un procedimiento que reciba el archivo anteriormente descripto y lo compacte. En
consecuencia, deberá generar un nuevo archivo en el cual, cada empleado aparezca una
única vez con el valor total de sus comisiones.
* 
NOTA: No se conoce a priori la cantidad de empleados. Además, el archivo debe ser
recorrido una única vez.}

program Comisones_empresa;
const
  valorAlto = 9999;
type

  empleado = record
    codigo : integer; 
    nombre : String; 
    comision : real; 
  end; 
  
  archivo = file of empleado; 
  
{esto me sirve pra poder reemplazar cuando pregunta por eof y tiene un corte de control}
procedure leer(var x : archivo; var dato: empleado);
begin
  if (not eof(x))then
    read(x,dato)
  else
    dato.codigo:= valorAlto; 
end;

procedure compactar(var d : archivo; var m : archivo);
var
  e: empleado;
  act: empleado; 
  aux : real;  
begin
  reset(d);
  rewrite(m);
  leer(d,e);
  while (e.codigo <> valorAlto)do  { verifica que no se termine detalle (while (not eof(d))do)}
    begin
      aux:= 0; 
      act.codigo := e.codigo; 
      act.nombre := e.nombre; 
      while ( e.codigo = act.codigo)do  {mientras que sea igual a mi codigo itera sumando la comision}
        begin                  {no pregunta si se termino el archivo porq con el proc leer si es eof no lo lee y tira valorAlto}
          aux:= aux + e.comision; 
          leer(d,e);
        end; 
      {una vez que tengo el total de comisiones de un empleado agrego al maestro}
      act.comision:= aux; 
      write(m,e);
    end; 
  close(m);
  close(d);
end;

var
  maestro : archivo;
  detalle : archivo; 
BEGIN
  assign(maestro,'nombre de archivo fisico');
  assign(detalle,'nombre de archivo fisico' );
  compactar(detalle,maestro);
END.

