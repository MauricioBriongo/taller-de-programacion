{Parcial 9-9-2024 turno M Recursantes.
Una clínica necesita un sistema para el procesamiento de las atenciones realizadas a los pacientes
en julio de 2024.
a) Implementar un módulo que lea información de las atenciones. De cada atención se lee:
matrícula del médico, dni del paciente, día y diagnótico (valor entre A y F). La lectura finaliza con
el dni 0.
El módulo debe retornar 2 estructuras:
i) un árbol binario de búsqueda ordenado por matrícula del médico. Para cada matrícula de médico debe
almacenarse la cantidad de atenciones realizadas.
ii) Un vector que almacene en cada posición el tipo de género y la lista de los dni de pacientes
atendidos con ese diagnóstico.
b)Implementar un módulo que reciba el árbol generado en a), una matrícula y retorne la cantidad total
de atenciones realizadas por los médicos con matrícula superior a la matrícula ingresada.
c)Realizar un módulo recursivo que reciba el vector generado en a) y retorne el diagnóstico con 
mayor cantidad de pacientes atendidos.
}

program parcialVectorCaracteres;

type
  rango='a'..'f';
  rangoDia=1..31;

  
  atencion = record
    dni:integer;
    matricula:integer;
    dia:rangoDia;
    diagnostico:rango;
  end;
  
  arbol =^nodoArbol;
  
  nodoArbol = record
    matri:integer;
    cant:integer;
    HD,HI:arbol;
  end;
  
  lista =^nodoLista;
  
  nodoLista = record
    dato:integer; //dni de paciente
    sig:lista;
  end;
  
  vector = array [rango] of lista;
    
procedure leerAtencion(var a:atencion);
var
  v:  array [1..6] of char =('a','b','c','d','e','f');
begin
  a.dni:=random(5000);
    if (a.dni <> 0) then begin
      a.matricula:=random(999)+100;
      a.dia:=random(31)+1;
      a.diagnostico:=v[random(6)+1];
    end;
end;

procedure insertarEnArbol(var a:arbol; aT:atencion);
begin
  if (a=nil) then begin
    new(a);
    a^.matri:=aT.matricula;
    a^.cant:=1;
    a^.HI:=nil;
    a^.HD:=nil;
  end
  else begin
    if (a^.matri = aT.matricula) then
      a^.cant:=a^.cant+1
    else begin
      if (a^.matri > aT.matricula) then
        insertarEnArbol(a^.HI,aT)
      else
        insertarEnArbol(a^.HD,aT);
    end;
  end;
end;

procedure agregarAdelante(var l:lista; dni:integer);
var
  nue:lista;
begin
  new(nue);
  nue^.dato:=dni;
  nue^.sig:=l;
  l:=nue;
end;

procedure cargarVector(var v:vector; aT:atencion);
begin
  agregarAdelante(v[aT.diagnostico],aT.dni);
end;

procedure inicializarVector(var v:vector);
var
  i:char;
begin
  for i:='a' to 'f' do 
    v[i]:=nil;
end;

procedure incisoA(var a:arbol; var v:vector);
var
  aT:atencion;
begin
  inicializarVector(v);
  leerAtencion(aT);
  while (aT.dni <> 0) do begin
    insertarEnArbol(a,aT);
    cargarVector(v,aT);
    leerAtencion(aT);
  end;
end;

function contarAt(a:arbol; mat:integer):integer;
begin
  if (a=nil) then
    contarAt:=0
  else begin
    if (a^.matri > mat) then
      contarAt:= a^.cant + contarAt(a^.HD,mat) + contarAt(a^.HI,mat)
    else
      contarAt:=contarAt(a^.HD,mat);
  end;
end;

procedure incisoB(a:arbol);
var
  cant,mat:integer;
begin
  writeln('INCISO B');
  writeln('Ingrese un numero de matricula');
  readln(mat);
  cant:=contarAt(a,mat);
  writeln('la cantidad de atenciones realizadas por medicos con matricula superior a ',mat,' es ',cant);
end;

function contarLista(l:lista):integer;
var aux:integer;
begin
  aux:=0;
  while (l<>nil) do begin
    aux:=aux+1;
    l:=l^.sig;
  end;
  contarLista:=aux;
end;

procedure imprimirVector(v:vector);
var i:char;
begin
  for i:='a' to 'f' do
    writeln(i,' - ',contarLista(v[i]),' atenciones');
end;

procedure mayorEnVector(v:vector; indice:char; var max:integer;  var pos:char);
var
  aux:integer;
begin
  if (indice < 'g') then begin
    aux:=contarLista(v[indice]);
      if (aux > max) then begin 
        max:=aux;
        pos:=indice;
      end;
      inc(indice);
      mayorEnVector(v,indice,max,pos);  
  end;
end;

procedure incisoC(v:vector);
var
  i,pos:char; max:integer;
begin
  i:='a';
  max:=-1;
  mayorEnVector(v,i,max,pos);
  if(pos<>'x')then
    writeln('El diagnostico con mas cantidad de atenciones es ',pos)
  else
    writeln('Vector vacio');
end;


var
  v:vector; a:arbol;
begin
  randomize;
  a:=nil;
  incisoA(a,v);
  incisoB(a);
  imprimirVector(v);
  incisoC(v);
end.
