{PARCIAL TOMADO EL 13-9-24 TURNO I RECURSANTES.
Una empresa de alquiler de autos desea procesar la información de sus alquileres.
a)Implementar un módulo que lea la información de los alquileres y retorne un vector
que agrupe a los alquileres de acuerdo a la cantidad de días de alquiler. Para cada
cantidad de días los alquileres deben almacenarse en un árbol binario de búsqueda,
ordenado por número de chasis del auto. De cada alquiler se lee:
dni del cliente, número de chasis y cantidad de días (1 a 7). La lectura finaliza con el
número de chasis 0.
b) Implementar un módulo que reciba la esctructura generada en a) y un dni D. Este móduolo
debe retornar la cantidad de alquileres realizados por el dni D.
c)Implementar un módulo que reciba la estructura generada en a) un número de día D,
y dos números de chasis n1 y n2. Este módulo debe retornar la cantidad de alquileres realizados
en el día D, para los chasis entre n1 y n2 (ambos incluidos).
}
program parcial;

type
rangoDias=1..7;

  infoAlquiler=record
    chasis:integer;
    dni:integer;
  end;

  alquiler=record
    dias:rangoDias;
    info:infoAlquiler;
  end;
  
  arbol=^nodo;
  
  nodo=record
    dato:infoAlquiler;
    HI,HD:arbol;
  end;
  
  vector=array[rangoDias] of arbol;
  
procedure leerAlquiler(var a:alquiler);
begin
  a.info.chasis:=random(10000);
  if (a.info.chasis <> 0) then begin
    a.info.dni:=random(1000)+1;
    a.dias:=random(7)+1;
  end;
end;
  
procedure insertarEnArbol(var a:arbol; aL:infoAlquiler);
begin
  if (a=nil) then begin
    new(a);
    a^.dato:=aL;
    a^.HI:=nil;
    a^.HD:=nil;
  end
  else begin
    if (a^.dato.chasis < aL.chasis) then
      insertarEnArbol(a^.HD,aL)
    else
      insertarEnArbol(a^.HI,aL)
  end;
end;

procedure inicializarVector(var v:vector);
var
 i:rangoDias;
begin
  for i:=1 to 7 do
    v[i]:=nil;
end;

procedure incisoA(var v:vector);
var
 aL:alquiler;
begin
  inicializarVector(v);
  leerAlquiler(aL);
  while (aL.info.chasis <> 0) do begin
    insertarEnArbol(v[aL.dias],aL.info);
    leerAlquiler(aL);
  end;
end;

function cantAlqui(a:arbol; dni:integer):integer;
begin
  if (a=nil) then
    cantAlqui:=0
  else begin
    if (a^.dato.dni = dni) then
      cantAlqui:= 1 + cantAlqui(a^.HI,dni) + cantAlqui(a^.HD,dni) //se presume que un cliente puede alquilar más de un auto.
    else
      cantAlqui:=cantAlqui(a^.HI,dni) + cantAlqui(a^.HD,dni);
  end;
end;

procedure incisoB(v:vector);
var
  i,cant,dni:integer;
begin
  cant:=0;
  writeln('INCISO B, contar la cantidad de alquileres de un DNI:');
  write('DNI: '); readln(dni);
  for i:=1 to  7 do begin
    cant:=cant+cantAlqui(v[i],dni);
  end;
  writeln('La cantidad de alquileres del dni ',dni,' es ',cant);
end;

function contarEnRango(a:arbol; n1,n2:integer):integer;
begin
  if (a=nil) then
    contarEnRango:=0
  else begin
    if (a^.dato.chasis >= n1) then begin
      if (a^.dato.chasis <= n2) then
        contarEnRango:= 1 + contarEnRango(a^.HI,n1,n2) + contarEnRango(a^.HD,n1,n2)
      else
        contarEnRango:=contarEnRango(a^.HI,n1,n2);
    end
    else
      contarEnRango:=contarEnRango(a^.HD,n1,n2);
  end;
end;

procedure incisoC(v:vector);
var
  d,n1,n2,cant:integer;
begin
  writeln('INCISO C, contar cantidad de alquileres de un dia entre 2 nros de chasis: ');
  write('Igrese cantidad de dias (1 a 7) '); readln(d);
  write('Ingrese primer nro de chasis '); readln(n1);
  write('Ingrese ultimo nro de chasis '); readln(n2);
  cant:=contarEnRango(v[d],n1,n2);
  writeln('La cantidad de alquileres entre chasis ',n1,' y ',n2,' de ',d,' dias es ',cant);
end;

procedure imprimirArbol(a:arbol);
begin
  if (a<>nil) then begin
    imprimirArbol(a^.HI);
    writeln('chasis: ',a^.dato.chasis,' cliente ',a^.dato.dni);
    imprimirArbol(a^.HD);
  end;
end;

procedure imprimirVector(v:vector);
var
  i:rangoDias;
begin
 for i:=1 to 7 do begin
   writeln(i,' Dias :');
   imprimirArbol(v[i]);
 end;
end;

var 
  v:vector;
begin
  randomize;
  incisoA(v);
//  imprimirVector(v); //CONTROL
  incisoB(v);
  incisoC(v);
end.
