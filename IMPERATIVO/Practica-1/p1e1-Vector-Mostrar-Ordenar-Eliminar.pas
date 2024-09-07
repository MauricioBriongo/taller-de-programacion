{1.- Se desea procesar la información de las ventas de productos de un comercio (como máximo50).
Implementar un programa que invoque los siguientes módulos:
a. Un módulo que retorne la información de las ventas en un vector. De cada venta se conoce el
día de la venta, código del producto (entre 1 y 15) y cantidad vendida (como máximo 99
unidades). El código debe generarse automáticamente (random) y la cantidad se debe leer. El
ingreso de las ventas finaliza con el día de venta 0 (no se procesa).
b. Un módulo que muestre el contenido del vector resultante del punto a).
c. Un módulo que ordene el vector de ventas por código.
d. Un módulo que muestre el contenido del vector resultante del punto c).
e. Un módulo que elimine, del vector ordenado, las ventas con código de producto entre dos
valores que se ingresan como parámetros.
f.
Un módulo que muestre el contenido del vector resultante del punto e).
g. Un módulo que retorne la información (ordenada por código de producto de menor a
mayor) de cada código par de producto junto a la cantidad total de productos vendidos.
h. Un módulo que muestre la información obtenida en el punto g)}


program p1e1;

const dimF=50;

type
rangoCod = 1..15;
rangoCant=0..99;


venta = record
  dia:integer;
  codigo:rangoCod;
  cant:rangoCant;
end;

ventas = array [rangoCant] of venta;

procedure leerVenta(var v:venta);
begin
  write('Ingrese el dia de la venta: '); readln(v.dia);
  if (v.dia <> 0) then
  begin
    write('Ingrese la cantidad de ventas(0 a 99): '); readln(v.cant);
    randomize;
    writeln('Generando codigo ...');
    v.codigo:= random(14)+1;
  end;
end;

procedure cargarVector(var v: ventas; var dimL:integer);
var
  ven:venta;
begin
  dimL:=0;
  leerVenta(ven);
  while (ven.dia <> 0) and (dimL <dimF) do 
    begin
      dimL:=dimL +1;
      v[dimL]:=ven;
      leerVenta(ven);
    end;
end;

procedure imprimirVector(vec: ventas; dlog:integer);
var i:integer;
begin
  for i:= 1 to dlog do
    begin
      write('Dia ',vec[i].dia);
      write(' | Cantidad de ventas: ',vec[i].cant);
      write(' |Codigo: ',vec[i].codigo,'   |');
      writeln();
    end;
end;

procedure ordenarPorInsercion(var v:ventas; dimL:integer);
var
  i,j:integer; actual:venta;
begin
  for i:=2 to dimL do
    begin
	    actual:=v[i];
	    j:=i-1;
	    while (j>0) and (v[j].codigo > actual.codigo) do
	    begin
	      v[j+1]:= v[j];
	      j:= j-1;
	    end;
	    v[j+1]:= actual;
	  end;
end;

procedure eliminar(var vec:ventas; var dimL:integer; valor1,valor2:rangoCod);
var
i, pI, pF, aBorrar:rangoCod;
begin
  pI:=1;
  while (pI <= dimL) and (vec[pI].codigo <= valor1) do
    pI:=pI+1;
  pF:= pI;
    while (pF <= dimL) and (vec[pF].codigo <= valor2) do
      pF:=pF+1;
  aBorrar:= pF-pI;
  writeln('elementos a borrar: ',aborrar);
  if (aBorrar > 0) then begin
    for i:= pI to dimL - aBorrar do
      vec[i]:= vec[i + aBorrar];
    end;
  dimL:= dimL-aBorrar;
end;

function esCodidoPar(cod: rangoCod):boolean;
BEGIN
	esCodidoPar:=(cod MOD 2 = 0);
END;


procedure retornarPares(v: ventas; dl:integer);
var
i, total: integer;
begin
  ordenarPorInsercion(v,dl);
  total:=0;
  for i:= 1 to dl do
  begin
  total:= total + v[i].cant;
    if (esCodidoPar(v[i].codigo)) then
    begin
      write('Dia ',v[i].dia);
      write(' | Cantidad de ventas: ',v[i].cant);
      write(' |Codigo: ',v[i].codigo,'   |');
      writeln();
    end;
  end;
  writeln('La cant total de productos vendidos es: ', total);
end;

var
vec: ventas;
dL:integer;

begin
  cargarVector(vec, dL);
  imprimirVector(vec, dL);
  {ordenarPorInsercion(vec, dL);
  writeln();
  writeln('Vector ordenado por codigo:');
  writeln();
  imprimirVector(vec, dL);
  eliminar(vec, dl, 5, 10);
  writeln(dL);
  imprimirVector(vec,dl);}
  WRITELN();
  writeln('INCISO H ---------');
  retornarPares(vec,dl);
end.
