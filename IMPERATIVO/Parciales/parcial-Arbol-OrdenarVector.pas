{Play station store requiere procesar las compras realizadas por sus clientes durante el año 2022.
a) Implementar un módulo que lea compras de videojuegos. De cada compra se lee:
código de videojuego,código de cliente, día y mes. La lectura finaliza con el código de cliente 0.
Se deben retornar 2 estructuras de datos:
i) Una estructura eficiente para la búsqueda por código de cliente.
ii) Otra estructura que almacena la cantidad de compras en cada mes.
b) Implementar	un módulo que reciba la estructura generada en a)i. ,un código de cliente y retorne todas
las compras que realizó dicho cliente.
c)Implementar un módulo que reciba la estructura generada en a)ii. y retorne la misma estructura
ordenada por cantidad de mayor a menor.
}
program parcialArbolyOrdenarVector;

type

  rangoDia=1..31;
  rangoMes=1..12;

  infoCompra = record
    codVideo:integer;
    dia:rangoDia;
    mes:rangoMes;
  end;

  compra = record
    cliente:integer;
    info:infoCompra;
  end;
  
  lista =^nodoLista;
  
  nodoLista = record
    dato:infoCompra;
    sig:lista;
  end;
  
  arbol =^nodoArbol;
  
  nodoArbol = record
    cod:integer;
    pri:lista;
    HI,HD:arbol;
  end;
  
  vector = array [rangoMes] of integer;
  
procedure leerCompra(var c:compra);
begin
  c.cliente:=random(100);
  if (c.cliente <> 0) then begin
    c.info.codVideo:=random(20000)+1;
    c.info.dia:=random(31)+1;
    c.info.mes:=random(12)+1;
    writeln(c.cliente);
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
    a^.cod:=c.cliente;
    a^.pri:=nil;
    agregarAdelante(a^.pri,c.info);
    a^.HI:=nil;
    a^.HD:=nil;
  end
  else begin
    if(a^.cod = c.cliente) then
      agregarAdelante(a^.pri,c.info)
    else
      if (a^.cod < c.cliente) then
        insertarEnArbol(a^.HD,c)
      else
        insertarEnArbol(a^.HI,c);
  end;
end;

procedure inicializarVector(var v:vector);
var 
  i:rangoMes;
begin
  for i:=1 to 12 do
    v[i]:=0;
end;

procedure incisoA(var a:arbol; var v:vector);
var 
  c:compra;
begin
  inicializarVector(v);
  leerCompra(c);
  while (c.cliente <> 0) do begin
    insertarEnArbol(a,c);
    v[c.info.mes]:=v[c.info.mes] + 1;
    leerCompra(c);
  end;
end;

function retornarLista(a:arbol; cod:integer):lista;
begin
  if (a=nil) then
    retornarLista:=nil
  else begin
    if (a^.cod = cod) then
      retornarLista:=a^.pri
    else begin
      if (a^.cod > cod) then
        retornarLista:=retornarLista(a^.HI,cod)
      else
        retornarLista:=retornarLista(a^.HD,cod);
    end;
  end; 
end;

procedure imprimirLista(l:lista);
begin
  while (l<>nil) do begin
    writeln('juego ',l^.dato.codVideo,' el ',l^.dato.dia,'/',l^.dato.mes);
    l:=l^.sig;
  end;
end;

procedure incisoB(a:arbol);
var
  cod:integer; l:lista;
begin
  writeln();
  writeln('INCISO B: Buscar por codigo de cliente y retornar todas sus compras:');
  write('Ingrese un numero de cliente a buscar:');
  readln(cod);
  l:=retornarLista(a,cod);
  if (l=nil) then 
    writeln('Cliente no encontrado')
  else 
    writeln('Las compras del cliente ',cod,' son : ');
    imprimirLista(l);
end;

procedure ordenarVector(var v:vector);
var
  i,j,actual:integer;
begin
  for i:=2 to 12 do begin
    actual:=v[i];
    j:=i-1;
    while (j > 0) and (v[j] < actual) do begin
      v[j+1]:=v[j];
      j:=j-1;
    end;
    v[j+1]:=actual;
  end;
end;

procedure imprimirVector(v:Vector);
var
 i:rangoMes;
begin
  for i:=1 to 12 do 
    writeln('mes ',i,'compras ',v[i]);
end;

procedure incisoC(v:vector);
begin
  writeln();
  writeln('Inciso C - ORDENAR VECTOR');
  writeln();
  writeln('Vector desordenado:');
  imprimirVector(v);
  writeln();
  writeln('Vector ordenado por cantidad de mayor a menor: ');
  ordenarVector(v);
  imprimirVector(v);
end;

var
  a:arbol; v:vector;
begin
  Randomize;
  a:=nil;
  incisoA(a,v);
  incisoB(a);
  incisoC(v);
end.
