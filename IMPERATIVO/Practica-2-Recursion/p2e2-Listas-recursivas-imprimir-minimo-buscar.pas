{2.- Escribir un programa que:
a. Implemente un módulo recursivo que genere y retorne una lista de números enteros
“random” en el rango 100-200. Finalizar con el número 100.
b. Un módulo recursivo que reciba la lista generada en a) e imprima los valores de la lista en el
mismo orden que están almacenados.
c. Implemente un módulo recursivo que reciba la lista generada en a) e imprima los valores de
la lista en orden inverso al que están almacenados.
d. Implemente un módulo recursivo que reciba la lista generada en a) y devuelva el mínimo
valor de la lista.
e. Implemente un módulo recursivo que reciba la lista generada en a) y un valor y devuelva
verdadero si dicho valor se encuentra en la lista o falso en caso contrario.
}

program p2e2;

type

  lista=^nodo;
  
  nodo = record
    dato:integer;
    sig:lista;
  end;
  

procedure generarListaRecursion(var l:lista); //INCISO A
var
  num:integer; nue:lista;
begin
  num:=abs( random(10) ); //abs me asegura que serán positivos
  if (num <> 0) then begin
    generarListaRecursion(l);
    new(nue);
    nue^.dato:=num;
    nue^.sig:=l;
    l:=nue;
  end
  else
    l:=nil;
end;

procedure imprimirLista(l:lista); //módulo para corroborar
begin
  while (l<>nil) do begin
    writeln(l^.dato);
    l:=l^.sig;
  end;
end;

procedure imprimirListaOrden(l:lista);
begin
  if (l<>nil) then begin
    writeln(l^.dato);
    imprimirListaOrden(l^.sig);
  end; 
end;

procedure imprimirListaInversa(l:lista);
begin
  if (l<>nil) then begin
    imprimirListaInversa(l^.sig);
    writeln(l^.dato);
  end; 
end;

function minimo(n1:integer; n2:integer):integer;
begin
  if (n1 <=n2) then
    minimo:=n1
  else
    minimo:=n2;
end;

function minimoEnLista(l:lista):integer;
begin
  if (l=nil) then
    minimoEnLista:=999
  else
    minimoEnLista:=minimo(l^.dato,minimoEnLista(l^.sig));   
end;

procedure minimoValor(l:lista);
var
  min:integer;
begin
  min:=minimoEnLista(l);
  if (min <> 999) then
    writeln('El minimo valor de la lista es ',min)
  else
    writeln('La lista no tiene elementos');
end;

function buscar(l:lista; num:integer):boolean;
begin
  if (l <> nil) then
    if (l^.dato <> num) then
      buscar:=buscar(l^.sig,num)
    else
      buscar:=true
  else
    buscar:=false;
end;

procedure buscarEnLista(l:lista);
var
  num:integer;
begin
  write('Ingrese un numero a buscar en la lista: ');
  readln(num);
  if (buscar(l,num)) then
    writeln('El numero ',num,' SI esta en la lista')
  else
    writeln('El numero ',num,' NO esta en la lista')
end;

var
l:lista;
begin
randomize;
generarListaRecursion(l);
writeln();
writeln('LISTA IMPRESA RECURSIVAMENTE EN ORDEN:');
imprimirListaOrden(l);
writeln('LISTA IMPRESA RECURSIVAMENTE EN ORDEN INVERSO:');
imprimirListaInversa(l);
writeln();
minimoValor(l);
buscarEnLista(l);
end.
