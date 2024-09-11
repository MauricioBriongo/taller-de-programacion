{Parcial tomado el 9-9-24 Turno N
Una clínica necesita un sistema para el procesamiento de las ateanciones realizadas a
pacientes durante el año 2023.
a)Implementar un módulo que lea la información de las atenciones y retorne un vector donde
se almacenen las atenciones agrupadas por mes. Las atenciones de cada mes deben quedar
almacenadas en un árbol binario de búsqueda ordenado por DNI de paciente y solo deben
almacenarse DNI del paciente y código de diagnóstico.
De cada atención se lee: matrícula de médico, DNI de paciente, mes, y 
diagnóstico (valor entre l y p). La lectura finaliza con la matrícula 0.
b)Implementar un módulo recursivo un vector generado en a) y retorne el mes con mayor
cantidad de atenciones.
c)Implementar un módulo que reciba el vector generado en a) y un dni de paciente y retorne si
fue atendido o no, el paciente con el dni ingresado.
}

program ParcialVectorDeArboles;

type

  rangoMes=1..12;
  
  atencion = record
    matricula:integer;
    dni:integer;
    mes:integer;
    diagnostico:char;
  end;

  arbol=^nodoArbol;
  
  nodoArbol = record
    dni:integer;
    dato:char; //diagnostico de 'l' a 'p';
    HI,HD:arbol;
  end;
  
  vector = array[rangoMes]of arbol;

procedure leerAtencion(var a:atencion);
var 
  v:array [1..5] of char = ('l','m','n','o','p');
begin
  a.matricula:=random(100);
  if (a.matricula <> 0) then begin
    a.dni:=random(10000)+1000;
    a.mes:=random(12)+1;
    a.diagnostico:=v[random(5)+1];
  end;
end;

procedure insertarEnArbol(var a:arbol; aT:atencion );
begin
  if (a=nil) then begin
    new(a);
    a^.dni:=aT.dni;
    a^.dato:= aT.diagnostico;
    a^.HI:=nil;
    a^.HD:=nil;
  end
  else begin
    if (a^.dni < aT.dni) then
      insertarEnArbol(a^.HD,aT)
    else
      insertarEnArbol(a^.HI,aT);
  end;
end;

procedure inicializarVector(var v:vector);
var i:rangoMes;
begin
  for i:=1 to 12 do 
    v[i]:=nil;
end;

procedure incisoA(var v:vector);
var
  aT:atencion; 
begin
  inicializarVector(v);
  leerAtencion(aT);
  while (aT.matricula <>0) do begin
    insertarEnArbol(v[aT.mes],aT);
    leerAtencion(aT);
  end;
end;

function contarMes(a:arbol):integer;
begin
  if (a=nil) then
    contarMes:=0
  else 
    contarMes:=1+contarMes(a^.HI)+contarMes(a^.HD);
end;

procedure contarAtenciones(v:vector; var max:integer; var mesMax:integer);
var
  i:rangoMes; aux:integer;
begin
  for i:=1 to 12 do begin
    aux:=contarMes(v[i]);
    if (aux > max) then begin
      max:=aux;
      mesMax:=i;
    end;
  end; 
end;

procedure incisoB(v:vector);
var 
  max,mesMax:integer;
begin
  max:=-1;
  contarAtenciones(v,max,mesMax);
  writeln('mes con mas atencions ',mesMax);
end;

function esta(a:arbol; dni:integer):boolean;
begin
  if (a=nil) then
    esta:=false
  else begin
    if (a^.dni = dni) then
      esta:=true
    else
      if (a^.dni < dni) then
        esta:=esta(a^.HD,dni)
      else
        esta:=esta(a^.HI,dni);
  end;
end;

procedure buscarPaciente(v:vector; dni:integer; var ok:boolean);
var 
  i:integer;
begin
  i:=1;
  ok:=false;
  while (i<=12) and (not ok) do begin //para que corte la búsqueda si lo encuentra
    ok:=esta(v[i],dni);
    i:=i+1;
  end;
end;

procedure incisoC(v:vector);
var
  dni:integer; ok:boolean;
begin
  write('dni a buscar: '); readln(dni);
  buscarPaciente(v,dni,ok);
  writeln(ok);
end;

var
v:vector;
begin
  randomize;
  incisoA(v);
  incisoB(v);
  incisoC(v);
end.
