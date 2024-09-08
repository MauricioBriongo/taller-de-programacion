{Se lee información de las compras realizadas por los clientes a un supermercado en el año 2022.
De cada compra se lee el código del cliente, número de mes y monto gastado.
La lectura finaliza cuando se lee el cliente con código cero.
a) realizar un módulo que lea la información de las compras y retorne una estructura de datos eficiente
para la búsqueda por código de cliente. Para cada cliente esta estructura debe acumular el monto total 
gastado para cada mes del año 2022. Se sugiere utilizar el módulo leer compra().
b) Realizar un módulo que reciba la estructura generada en a) y un cliente, y retorne el mes con mayor
gasto de dicho cliente.
c) Realizar un módulo que reciba la estructura generada en a) y un número de mes, y retorne la cantidad
de clientes que no gastaron nada en dicho mes.  
}
program parcialArbolDeVectores;

type

  rangoMes=1..12;
  
  compra=record
    codigo:integer;
    mes:rangoMes;
    monto:real;
  end;
  
  vector = array [rangoMes] of real;
  
  arbol =^nodo;
  
  nodo = record
    codigo:integer;
    dato:vector;
    HI:arbol;
    HD:arbol;
  end;
  
procedure leerCompra(var c:compra);
begin
  c.codigo:=random(100);
  if (c.codigo <> 0) then begin
    c.mes:=random(12)+1;
    c.monto:=random(20000);
  end;
end;

procedure inicializarVector(var v:vector);
var
  i:integer;
begin
  for i:=1 to 12 do
    v[i]:=0;
end;

procedure cargarVector(var v:vector; c:compra);
begin
  v[c.mes]:=v[c.mes]+c.monto;
end;


procedure insertarEnArbol(var a:arbol; c:compra);
var
  v:vector;
begin
  if (a=nil) then begin
    new(a);
    a^.codigo:=c.codigo;
    inicializarVector(v);
    a^.dato:=v;   
    cargarVector(a^.dato,c);
    a^.HI:=nil;
    a^.HD:=nil;
  end
  else begin
    if (a^.codigo = c.codigo) then
      cargarVector(a^.dato,c)
    else begin
      if (a^.codigo < c.codigo) then 
        insertarEnArbol(a^.HD,c)
	  else
	    insertarEnArbol(a^.HI,c);
	end;
  end;
end;

procedure incisoA(var a:arbol);
var
  c:compra;
begin
  leerCompra(c);
  while(c.codigo <> 0) do begin
    writeln(c.codigo);
    insertarEnArbol(a,c);
    leerCompra(c);
  end;
end;

function maxPos(v:vector):integer;
var
  i,pos:integer; max:real;
begin
  max:=-1;
  for i:=1 to 12 do begin
    if (v[i]>max) then begin
      max:=v[i];
      pos:=i;
    end;
  end;
  maxPos:=pos;
end;

procedure mesMayor(a:arbol; num:integer; var mes:integer);
begin
  if (a = nil) then
    mes:=-1
  else begin
    if (a^.codigo = num) then
      mes:=maxPos(a^.dato)
    else
      if (a^.codigo < num) then
        mesMayor(a^.HD,num,mes)
      else
        mesMayor(a^.HI,num,mes)
  end;
end;

procedure incisoB(a:arbol);
var
  n,mes:integer;
begin
  writeln('INCISO B');
  write('ingrese un numero de cliente');
  readln(n);
  mesMayor(a,n,mes);
  if (mes<>-1) then begin
    writeln('El cliente ',n,' realizo su mayor gasto el mes ',mes)
  end
  else
    writeln('Cliente no encontrado.');
end;

function cantGastoCero(a:arbol; mes:integer):integer;
begin
  if (a = nil) then
    cantGastoCero:=0
  else begin
    if (a^.dato[mes] = 0) then
      cantGastoCero:= 1 + cantGastoCero(a^.HI,mes) + cantGastoCero(a^.HD,mes)
    else
      cantGastoCero:=cantGastoCero(a^.HI,mes) + cantGastoCero(a^.HD,mes);
  end;
end;

procedure incisoC(a:arbol);
var
  mes,cant:integer;
begin
  writeln();
  writeln('INCISO C, para un mes leido contar cantidad de clientes cuyo gasto fue 0 ese mes:');
  write('Ingrese numero de mes: ');
  readln(mes);
  cant:=cantGastoCero(a,mes);
  writeln('La cantidad de clientes cuyo gasto fue 0 el mes ',mes,' es de ',cant);
end;

var
  a:arbol;
begin
  Randomize;
  a:=nil;
  incisoA(a);
  incisoB(a);
  incisoC(a);
end.
