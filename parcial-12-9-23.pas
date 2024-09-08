{Una clínica necesita un sistema para el procesamiento de las atenciones realizadas a 
los pacientes.
a) Implementar un módulo que lea información de las atenciones. De cada atención se lee: 
DNI del paciente, numero de mes, y código de diagnóstico (1 a 15). 
La lectura finaliza con el mes 0. 
Se sugiere utilizar el módulo leerAtención().El módulo debe retornar 2 estructuras de datos:
i. Una estructura de datos eficiente para la búsqueda por DNI del paciente. Para cada DNI debe 
almacenarse la cantidad total de atenciones recibidas.
ii. Otra estructura de datos con la cantidad de atenciones realizadas para cada diagnóstico.
b) Implementar un módulo que reciba la estructura generada en a)i. , dos números de DNI y un valor
entero x. Este módulo debe retornar la cantidad de pacientes con más de x atenciones cuyos DNI 
están entre los 2 números de DNI recibidos.
c) Implementar un módulo recursivo que reciba la estructura generada en a) ii. y retorne 
la cantidad de diagnósticos para los cuales la cantidad de atenciones fue cero.}

program parcialSeptiembre2023;

type
  rango = 1..15;
  
  atencion = record
    dni:integer;
    mes:integer;
    codigo:rango;
  end;
  
  arbol =^nodo;
  
  nodo = record
    dni:integer;
    cant:integer;
    HI:arbol;
    HD:arbol;
  end;
  
  vector = array [rango] of integer;
  
procedure leerAtencion(var a:atencion);
begin
  a.mes:=random(13);
  if (a.mes <> 0) then begin
    a.dni:=random(100)+1;
    a.codigo:=random(15)+1;
  end;
end;

procedure insertarEnArbol(var a:arbol; aT:atencion);
begin
  if (a = nil) then begin
    new(a);
    a^.dni:= aT.dni;
    a^.cant:=1;
    a^.HI:=nil;
    a^.HD:=nil;
  end
  else begin
    if (a^.dni = aT.dni) then
      a^.cant:=a^.cant + 1
    else
      if (a^.dni < aT.dni) then
        insertarEnArbol(a^.HD,aT)
      else
        insertarEnArbol(a^.HI,aT);
  end;
end;

procedure inicializarVector(var v:vector);
var i:rango;
begin
  for i:= 1 to 15 do 
    v[i]:= 0;
end;

procedure generarEstructuras(var a:arbol; var v:vector);
var
  aT:atencion;
begin
  inicializarVector(v);
  leerAtencion(aT);
  while(aT.mes <> 0) do begin
    insertarEnArbol(a,aT);
    v[aT.codigo]:= v[aT.codigo] + 1;
    leerAtencion(aT);
  end;
end;

function contarEnRango(a:arbol; dni1,dni2:integer; valor:integer):integer;
begin
  if (a = nil) then
    contarEnRango:=0
  else begin
    if (a^.dni > dni1) then begin
      if (a^.dni < dni2) then begin
        if (a^.cant > valor) then
          contarEnRango:= 1 + contarEnRango(a^.HI,dni1,dni2,valor) + contarEnRango(a^.HD,dni1,dni2,valor)
        else
          contarEnRango:=contarEnRango(a^.HI,dni1,dni2,valor) + contarEnRango(a^.HD,dni1,dni2,valor);
      end
      else
        contarEnRango:=contarEnRango(a^.HI,dni1,dni2,valor);
    end
    else
      contarEnRango:=contarEnRango(a^.HD,dni1,dni2,valor);
  end;    
end;

procedure imprimirArbol(a:arbol);
begin
  if (a<>nil) then begin
    imprimirArbol(a^.HI);
    writeln('dni ',a^.dni,' atenciones ',a^.cant);
    imprimirArbol(a^.HD);
  end;
end;

procedure incisoB(a:arbol);
var
  n1,n2,valor,cant:integer;
begin
  writeln();
  writeln('INCISO B: CONTAR CANTIDAD DE PACIENTES CON MAS ATENCIONES QUE UN VALOR, EN UN RANGO');
  write('Igrese el primer dni: ');
  readln(n1);
  write('Ingrese el segundo dni (mayor que el primero)');
  readln(n2);
  write('Ingrese una cantidad de atenciones: ');
  readln(valor);
  cant:=contarEnRango(a,n1,n2,valor);
  writeln('La cantidad de pacientes con mas de ',valor,' atenciones, entre los dni ',n1,' y ',n2,' es ',cant);
end;

function contarVector(v:vector; dimF:integer):integer;
begin
  if (dimF = 0) then
    contarVector:=0
  else begin
    if (v[dimF] = 0) then
      contarVector:= 1 + contarVector(v,dimF-1)
    else
      contarVector:=contarVector(v,dimF-1);
  end;
end;

procedure incisoC(v:vector; dimF:integer);
var
  cant:integer;
begin
  cant:=contarVector(v,dimF);
  writeln('La cantidad de diagnosticos con atencion 0 es ',cant);
end;

procedure imprimirVector(v:vector);
var
  i:rango;
begin
  for i:=1 to 15 do begin
    writeln('VECTOR:'); 
    writeln('diagnostico ',i,' atenciones ',v[i]);
  end;
end;

var
  a:arbol; v:vector; dimF:integer;
begin
  randomize;
  dimF:=15;
  a:=nil;
  generarEstructuras(a,v);
  imprimirArbol(a);  //CONTROL
  imprimirVector(v); //CONTROL
  incisoB(a);
  incisoC(v,dimF);
end.
