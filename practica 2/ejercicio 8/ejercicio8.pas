{
Se cuenta con un archivo que posee información de las ventas que realiza una empresa a
los diferentes clientes. Se necesita obtener un reporte con las ventas organizadas por
cliente. Para ello, se deberá informar por pantalla: los datos personales del cliente, el total
mensual (mes por mes cuánto compró) y finalmente el monto total comprado en el año por el
cliente. Además, al finalizar el reporte, se debe informar el monto total de ventas obtenido
por la empresa.
El formato del archivo maestro está dado por: cliente (cod cliente, nombre y apellido), año,
mes, día y monto de la venta. El orden del archivo está dado por: cod cliente, año y mes.
Nota: tenga en cuenta que puede haber meses en los que los clientes no realizaron
compras. No es necesario que informe tales meses en el reporte.
}

program ventas_empresa;
const
  valorAlto = 9999;
type 
  clientee = record
    cod: integer; 
    nombre :String; 
    apellido: String; 
  end; 

  venta = record
    cliente : clientee; 
    anio: integer; 
    mes: integer; 
    dia: integer; 
    monto : real; 
  end; 

  am = file of venta; 



procedure leer(var maestro: am; var reg : venta);
begin
  if(not eof (maestro))then
    read(maestro,reg)
  else
    reg.cliente.cod:= valorAlto; 
end; 

procedure informar(var maestro : am);
var
  cli: clientee; 
  mes: integer;
  gastos_mes: real;  
  anio: integer; 
  gastos_anio:real;  
  recaudacion_tot_empresa: real; 
  ven : venta; 
begin
  reset(maestro);
  leer(maestro,ven);
  recaudacion_tot_empresa:= 0;
  while (ven.cliente.cod <> valorAlto)do
    begin
      //guardo mi cliente actual
      cli.nombre:= ven.cliente.nombre;
      cli.apellido := ven.cliente.apellido; 
      cli.cod:= ven.cliente.cod;
      writeln('-------------------------');
      writeln('cliente : ', cli.nombre, 'apellido : ', cli.apellido, 'codigo : ', cli.cod);
     
      while (ven.cliente.cod = cli.cod)do
        begin
           //configuramos el año actual
           anio:= ven.anio;
           gastos_anio:=0;
           //ahora itero por año //configuramos el año actual
           while ((ven.cliente.cod = cli.cod) and (ven.anio = anio))do
             begin
               gastos_mes:=0;
               mes:= ven.mes;
               while( (ven.cliente.cod = cli.cod) and (ven.anio = anio) and (ven.mes = mes) )do
                 begin
                   gastos_mes := gastos_mes + ven.monto;  
                   leer(maestro,ven);
                 end;
               recaudacion_tot_empresa:= recaudacion_tot_empresa + gastos_mes;
               writeln('los gastos del mes : ', mes, 'es de : ', gastos_mes:3:3);
               //le sumo al total de gastos en ese año
               gastos_anio:= gastos_anio + gastos_mes; 
             end; 
           writeln('los gastos en el año : ', anio, 'del cliente , fue : ', gastos_anio:3:3);
        end; 
    end; 
  writeln('lo recaudado por la empresa es de : ', recaudacion_tot_empresa:3:3 );
  close(maestro);
end; 

var 
  maestro: am; 
BEGIN
  assign(maestro,'ArchivoMaestro');
  informar(maestro);
END.

