{3. Implementar un programa que contenga:
a. Un módulo que lea información de los finales rendidos por los alumnos de la Facultad de
Informática y los almacene en una estructura de datos. La información que se lee es legajo,
código de materia, fecha y nota. La lectura de los alumnos finaliza con legajo 0. La estructura
generada debe ser eficiente para la búsqueda por número de legajo y para cada alumno deben
guardarse los finales que rindió en una lista.
b. Un módulo que reciba la estructura generada en a. y retorne la cantidad de alumnos con
legajo impar.
c. Un módulo que reciba la estructura generada en a. e informe, para cada alumno, su legajo y
su cantidad de finales aprobados (nota mayor o igual a 4).
c. Un módulo que reciba la estructura generada en a. y un valor real. Este módulo debe
retornar los legajos y promedios de los alumnos cuyo promedio supera el valor ingresado.
}
program p3e3;

type

  infoFinal = record
    codigo:integer;
    fecha:String;
    nota:integer;
  end;

  final = record
    legajo:integer;
    info:infoFinal;
  end;

  lista =^nodoLista;
  
  nodoLista = record
    dato:infoFinal;
    sig:lista;
  end;
  
  arbol =^nodoArbol;
  
  nodoArbol = record
    legajo:integer;
    dato:lista;
    HI:arbol;
    HD:arbol;
  end;
  
procedure agregarAdelante(var l:lista; f:infoFinal);
var
  nue:lista;
begin
    new(nue);
    nue^.dato:=f;
    nue^.sig:=l;
    l:=nue 
end;

procedure leerFinal(var f:final);
begin
  write('Nro Legajo:');
  readln(f.legajo);
  if (f.legajo <> 0) then begin
    write('Fecha: ');
    readln(f.info.fecha);
    write('Codigo de materia: ');
    readln(f.info.codigo);
    write('Nota: ');
    readln(f.info.nota);
    writeln();
  end;
end;

procedure cargarArbol(var a:arbol; f:final);
begin
  if (a = nil) then begin
    new(a);
    a^.legajo:=f.legajo;
    a^.dato:=nil;
    agregarAdelante(a^.dato,f.info);
    a^.HI:=nil;
    a^.HD:=nil;
  end
  else
    if (a^.legajo = f.legajo) then
      agregarAdelante(a^.dato,f.info)
    else begin
      if (f.legajo > a^.legajo ) then //repetidos se ubican a derecha en este caso.
        cargarArbol(a^.HD,f)
      else
        cargarArbol(a^.HI,f);
    end;
end;

procedure guardarFinales(var a:Arbol);
var
  f:final;
begin
  leerFinal(f);
  while (f.legajo <> 0) do begin
    cargarArbol(a,f);
    leerFinal(f);
  end;
end;



procedure imprimirArbol(a:arbol);
  
  procedure imprimirLista(l:lista);
  begin
    while (l<>nil) do begin
      write('materia: ',l^.dato.codigo,' Fecha: ',l^.dato.fecha,' Nota: ',l^.dato.nota);
      writeln();
      l:=l^.sig;
    end; 
  end;

begin
  if ( a <> nil) then begin
    imprimirArbol(a^.HI);
    writeln('Legajo ',a^.legajo);
    imprimirLista(a^.dato);
    imprimirArbol(a^.HD);
  end;
end;

procedure imprimirAprobados(a:arbol);

  function contarAprobados(l:lista):integer;
  var
    aux:integer;
  begin
    aux:=0;
    while(l <> nil) do begin
      if (l^.dato.nota >= 4) then
        aux:=aux + 1;
        l:=l^.sig;
    end;
    contarAprobados:=aux;  
  end;
  
begin
  if (a<>nil) then begin
    imprimirAprobados(a^.HI);
    write('legajo: ',a^.legajo);
    writeln(' finales aprobados: ',contarAprobados(a^.dato));
    imprimirAprobados(a^.HD);
  end;
end;

function esImpar(legajo:integer):boolean;
begin
  esImpar:= legajo mod 2 <> 0;
end;

function legajosImpares(a:arbol):integer;
begin
  if (a <> nil) then  begin
    if (esImpar(a^.legajo)) then
      legajosImpares:= 1 + legajosImpares(a^.HD) + legajosImpares(a^.HI)
    else
      legajosImpares:=legajosImpares(a^.HI) + legajosImpares(a^.HD);
  end
  else
    legajosImpares:=0;
end;

function promedio(l:lista):real;
var
  suma:integer;
  cant:integer;
begin
  suma:=0; cant:=0;
  while (l <> nil ) do begin
    suma:=suma+l^.dato.nota;
    cant:=cant + 1 ;
    l:=l^.sig;
  end;
  promedio:=suma / cant;
end;

procedure imprimirMayores(a:arbol; num:real);
var
  aux:real;
begin
  if (a <> nil) then begin
    aux:=promedio(a^.dato);
    imprimirMayores(a^.HI,num);
    if (aux > num) then
      writeln('Alumno: ',a^.legajo,' promedio: ',aux:2:2);
    imprimirMayores(a^.HD,num);   
  end;
end;

var
  a:arbol;
  impares:integer;
  num:real;
begin
  a:=nil;
  guardarFinales(a);
  imprimirArbol(a);
  impares:=legajosImpares(a);
  writeln('La cantidad de legajos impares es : ',impares);
  writeln();
  imprimirAprobados(a);
  writeln('Ingresar una nota para buscar promedios mayores: ');
  readln(num);
  writeln('Los alumanos con promedio mayor a ',num:2:2,' son: ');
  imprimirMayores(a,num);
end.
