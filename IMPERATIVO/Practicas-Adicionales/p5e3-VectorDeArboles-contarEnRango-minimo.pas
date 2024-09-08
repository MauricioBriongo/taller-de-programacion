{Un supermercado requiere el procesamiento de sus productos. De cada producto se
conoce código, rubro (1..10), stock y precio unitario. Se pide:
a) Generar una estructura adecuada que permita agrupar los productos por rubro. A su
vez, para cada rubro, se requiere que la búsqueda de un producto por código sea lo
más eficiente posible. El ingreso finaliza con el código de producto igual a 0.
b) Implementar un módulo que reciba la estructura generada en a), un rubro y un código
de producto y retorne si dicho código existe o no para ese rubro.
c) Implementar un módulo que reciba la estructura generada en a), y retorne, para cada
rubro, el código y stock del producto con mayor código.
d) Implementar un módulo que reciba la estructura generada en a), dos códigos y
retorne, para cada rubro, la cantidad de productos con códigos entre los dos valores
ingresados.
}
program p5e3;
 
type
  rango=1..10;
  
  infoProd = record
    stock:integer;
    precio:real;
  end;
  
  producto = record
    codigo:integer;
    rubro:rango;
    info:infoProd;
  end;
  
  arbol =^nodo;
  
  nodo=record
    codigo:integer;
    dato:infoProd;
    HI:arbol;
    HD:arbol;
  end;
  
  vector = array [rango] of arbol;
  
  infoMax = record
    cod:integer;
    stock:integer;
  end;
  
  vecMax = array [rango] of infoMAx;
  
  vectorIncisoD = array [rango] of integer;
  
procedure crearProducto(var p:producto);
begin
  p.codigo:=random(100);
  if (p. codigo <> 0) then begin
    p.rubro:=random(10)+1;
    p.info.stock:=random(150);
    p.info.precio:=random(1000)+0.5;
  end;
end;
  
procedure insertarEnArbol(var a:arbol; p:producto);
begin
  if (a=nil) then begin
    new(a);
    a^.codigo:=p.codigo;
    a^.dato:=p.info;
    a^.HI:=nil;
    a^.HD:=nil;
  end
  else
    if (a^.codigo < p.codigo) then
      insertarEnArbol(a^.HD,p)
    else
      insertarEnArbol(a^.HI,p);
end;
  
procedure inicializarVector(var v:vector);
var
  i:rango;
begin
  for i:=1 to 10 do
    v[i]:=nil;
end;

procedure cargarVector(var v:vector);
var
  p:producto;
begin
  inicializarVector(v);
  crearProducto(p);
  while (p.codigo <> 0) do begin
    insertarEnArbol(v[p.rubro],p);
    crearProducto(p);
  end;
end;

procedure imprimirArbol(a:arbol);
begin
  if (a<>nil) then begin
    imprimirArbol(a^.HI);
    writeln('codigo',a^.codigo,' stock ',a^.dato.stock,' precio ',a^.dato.precio:2:2);
    imprimirArbol(a^.HD);
  end;
end;
  
procedure imprimirVectorDeArbol(v:vector);
var
  i:integer;
begin
  for i:=1 to 10 do begin
    if (v[i] <> nil) then begin
      writeln('Rubro ',i,' ----------------');
      imprimirArbol(v[i]);
    end
    else
      writeln('Rubro ',i,' vacio');
  end;
end;
  
function existe(a:arbol; cod:integer):boolean;
begin
  if (a = nil) then
    existe:=false
  else begin
    if (a^.codigo = cod) then
      existe:=true
    else begin
      if (a^.codigo < cod) then
        existe:=existe(a^.HD,cod)
      else
        existe:=existe(a^.HI,cod);
    end;
  end;
end;

procedure incisoB(v:vector);
var
  r:rango; cod:integer;
begin
  writeln();
  writeln('Inciso B, comprobar si existe un codigo en un rubro:');
  write('Ingrese un rubro (de 1 a 10) ');
  readln(r);
  write('Ingrese un codigo: ');
  readln(cod);
  if (existe(v[r],cod)) then
    writeln('El codigo ',cod,' existe en el rubro ',r)
  else
   writeln('El codigo ',cod,' no existe en el rubro ',r);
end;
  
procedure maxCod(a:arbol;var cod:integer; var stk:integer);
begin
  if (a = nil) then
    cod:=-1
  else 
    if (a^.HD = nil) then begin
      cod:=a^.codigo;
      stk:=a^.dato.stock;
    end
    else
      maxCod(a^.HD,cod,stk);
end;

procedure incisoC(v:vector; var vM:vecMax); //como dice RETORNE y no imprima o informe, debe retornar una estructura con lo pedido
var
  i:rango; codM,stk:integer;
begin
  for i:= 1 to 10 do begin
    maxCod(v[i],codM,stk);
    if (codM <> -1) then begin
      vM[i].cod:=codM;
      vM[i].stock:=stk;
    end;
  end;
end;

procedure imprimirMax(vM:vecMax);
var
  i:rango;
begin
  writeln();
  writeln('INCISO C, MAYORES CODIGOS Y SU STOCK DE CADA RUBRO:');
  writeln();
  for i:=1 to 10 do begin
    writeln('Rubro ',i,' codigo mayor ',vM[i].cod,' stock ',vM[i].stock);
  end;
end;
  
function cantEntreCodigos(a:arbol; cod1,cod2:integer):integer;
begin
  if (a = nil) then
    cantEntreCodigos:=0
  else begin
    if (a^.codigo > cod1) then begin
      if (a^.codigo < cod2) then
        cantEntreCodigos:=1 + cantEntreCodigos(a^.HI,cod1,cod2) + cantEntreCodigos(a^.HD,cod1,cod2)
      else
        cantEntreCodigos:= cantEntreCodigos(a^.HI,cod1,cod2);
    end
    else
      cantEntreCodigos:=cantEntreCodigos(a^.HD,cod1,cod2);
  end;
end;

procedure incisoD(v:vector; var v2:vectorIncisoD);
var
 i,cod1,cod2:integer;
begin
  writeln();
  writeln('INCISO D CONTAR CUANTOS PRODUCTOS HAY ENTRE 2 CODIGOS:');
  write('Ingrese codigo 1:');
  readln(cod1);
  write('Ingrese codigo 2: ');
  readln(cod2);
  for i:=1 to 10 do begin
    v2[i]:=cantEntreCodigos(v[i],cod1,cod2)
  end;
end;

procedure informarIncisoD(v:vectorIncisoD);
var
  i:rango;
begin
  for i:= 1 to 10 do begin
    writeln('Rubro ',i,' codigos en rango: ',v[i]);
  end;
end;

var
  v:vector; vM:vecMAx; vD:vectorIncisoD;
begin
  cargarVector(v);
  imprimirVectorDeArbol(v); //para control
  incisoB(v);
  incisoC(v,vM);
  imprimirMax(vM); //para control
  incisoD(v,vd); //para control
  informarIncisoD(vd);
end.
