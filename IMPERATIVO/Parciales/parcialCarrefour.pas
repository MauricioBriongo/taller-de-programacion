{El hipermercado carrefour necesita un sistema para obtener estadísticas sobre las compras realizadas
por sus clientes.
a) implementar un modulo que lea la información de todas las compras de 2023, los almacene y
retorne una estructura de datos eficiente para la busqueda por código de cliente, donde para
cada código de cliente se almacenen juntas todas sus compras. 
De cada compra se conoce código de cliente, número de factura, cantidad de productos y monto.
La lectura finaliza con el código de cliente 0.
b) Implementar un módulo que reciba la estructura generada en a), un código de cliente y retorne
la cantidad de compras y el monto total gastado por dicho cliente durante 2023.
c) Realizar un módulo que reciba la estructura generada en a) y dos números de factura X e Y, y
retorne todas las ventas cuyo número de factura estén entre X e Y incluídos.

DUDA: incisoC, pide retornar todas las "ventas", ¿esa información incluye el nro de cliente?
si es así habría que hacer otro tipo de lista que incluya ese dato.
}
program parcialCarrefour;

type
  infoCompra=record
    factura:integer;
    cant:integer;
    monto:real;
  end;

  compra = record
    cliente:integer;
    info:infoCompra;
  end;

  lista=^nodoLista;
  
  nodoLista=record
    dato:infoCompra;
    sig:lista;
  end;
  
  arbol =^nodoArbol;
  
  nodoArbol = record
    cliente:integer;
    pri:lista;
    HI,HD:arbol;
  end;
  
procedure leerCompra(var c:compra);
begin
  c.cliente:=random(100);
  if (c.cliente <> 0) then begin
    c.info.factura:=random(5000)+1;
    c.info.cant:=random(50)+1;
    c.info.monto:=random(1000)+1000;
  end;
end;

procedure agregarAdelante(var l:lista; c:infoCompra);
var
nue:lista;
begin
  new(nue);
  nue^.dato:=c;
  nue^.sig:=l;
  l:=nue;
end;

procedure insertarEnArbol(var a:arbol; c:compra);
begin
  if (a=nil) then begin
    new(a);
    a^.cliente:=c.cliente;
    a^.pri:=nil;
    agregarAdelante(a^.pri,c.info);
    a^.HI:=nil;
    a^.HD:=nil;
  end
  else  begin
    if (a^.cliente = c.cliente) then
      agregarAdelante(a^.pri,c.info)
    else
      if (a^.cliente < c.cliente) then
        insertarEnArbol(a^.HD,c)
      else
        insertarEnArbol(a^.HI,c)
  end;
end;

procedure incisoA(var a:arbol);
var
  c:compra;
begin
  leerCompra(c);
  while (c.cliente <> 0) do begin
    insertarEnArbol(a,c);
    writeln(c.cliente);
    leerCompra(c);
  end;
end;

procedure recorrerLista(l:lista; var cant:integer; var total:real);
begin
  while (l <> nil) do begin
    cant:=cant+1;
    total:=total + l^.dato.monto;
    l:=l^.sig;
  end;
end;

procedure buscarCliente(a:arbol; cli:integer; var cant:integer; var total:real);
begin
  if (a <> nil) then begin
    if (a^.cliente = cli ) then
      recorrerLista(a^.pri,cant,total)
    else begin
      if (a^.cliente < cli) then
        buscarCliente(a^.HD,cli,cant,total)
      else
        buscarCliente(a^.HI,cli,cant,total);
    end;
  end;
end;

procedure incisoB(a:arbol);
var
  cli,cant:integer; total:real;
begin
  cant:=0; total:=0;
  writeln('INCISO B, cantidad de compras y monto gastado por un cliente: ');
  writeln('Ingrese numero de cliente');readln(cli);
  buscarCliente(a,cli,cant,total);
  writeln('El cliente ',cli,' realizo ',cant,' compras por un monto de $',total:2:2);
end;

procedure ventasEntreFac(l:lista; f1,f2:integer; var l2:lista);
begin
  while (l<>nil) do begin
    if (l^.dato.factura >=f1 ) and (l^.dato.factura<=f2) then
      agregarAdelante(l2,l^.dato);
    l:=l^.sig;
  end;
end;

procedure entreFacturas(a:arbol; f1,f2:integer; var l:lista); //si bien es una búsqueda en un rango, al no estar ordenado por ese criterio hay que recorrer todo el árbol
begin
  if (a <> nil) then begin
    entreFacturas(a^.HI,f1,f2,l);
    ventasEntreFac(a^.pri,f1,f2,l);
    entreFacturas(a^.HD,f1,f2,l);
  end; 
end;

procedure imprimirLista(l:lista);
begin
  while (l<>nil) do begin
    writeln('factura ',l^.dato.factura,' productos ',l^.dato.cant,' monto ',l^.dato.monto:2:2);
    l:=l^.sig;
  end;
end;

procedure incisoC(a:arbol); 
var
  f1,f2:integer;
  l:lista;
begin
  l:=nil;
  writeln('INCISO C, ventas comprendidas entre numeros de factura: ');
  write('Primer factura numero: ');
  readln(f1);
  writeln('Ultima factura numero: ');
  readln(f2);
  entreFacturas(a,f1,f2,l);
  imprimirLista(l);
end;

var
  a:arbol;
begin
  a:=nil;
  incisoA(a);
  incisoB(a);
  incisoC(a);
end.
