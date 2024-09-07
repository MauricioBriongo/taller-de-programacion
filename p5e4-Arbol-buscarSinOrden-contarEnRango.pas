{Una oficina requiere el procesamiento de los reclamos de las personas. De cada reclamo
se ingresa código, DNI de la persona, año y tipo de reclamo. El ingreso finaliza con el
código de igual a 0. Se pide:
a) Un módulo que retorne estructura adecuada para la búsqueda por DNI. Para cada DNI
se deben tener almacenados cada reclamo y la cantidad total de reclamos que realizó.
b) Un módulo que reciba la estructura generada en a) y un DNI y retorne la cantidad de
reclamos efectuados por ese DNI.
c) Un módulo que reciba la estructura generada en a) y dos DNI y retorne la cantidad de
reclamos efectuados por todos los DNI comprendidos entre los dos DNI recibidos.
d) Un módulo que reciba la estructura generada en a) y un año y retorne los códigos de
los reclamos realizados en el año recibido.}

program p5e4;
type

  infoReclamo = record
    codigo:integer;
    tipo:integer;
    anio:integer;
  end;

  reclamo = record
    dni:integer;
    info:infoReclamo;
  end;

  lista =^nodoLista; //lista de reclamos
  
  nodoLista = record
    dato:infoReclamo;
    sig:lista
  end;
  
  arbol =^nodoArbol;
  
  nodoArbol = record
    dni:integer;
    cant:integer;
    pri:lista;
    HD:arbol;
    HI:arbol;
  end;
  
  listaCodigos=^nodoCodigos;
  
  nodoCodigos=record
    dato:integer;
    sig:listaCodigos;
  end;
  
procedure leerReclamo(var r:reclamo);
begin
  write('Codigo: ');
  readln(r.info.codigo);
  if (r.info.codigo <> 0) then begin
    write('dni: ');
    readln(r.dni);
    write('Tipo: ');
    readln(r.info.tipo);
    write('anio: ');
    readln(r.info.anio);
  end;
end;

procedure agregarCodigo(var l:listaCodigos; c:integer);
var
  nue:listaCodigos;
begin
  new(nue);
  nue^.dato:=c;
  nue^.sig:=l;
  l:=nue;
end;

procedure agregarAdelante(var l:lista; r:infoReclamo);
var 
  nue:lista;
begin
    new(nue);
    nue^.dato:=r;
    nue^.sig:=l;
    l:=nue;
end;

procedure insertarEnArbol(var a:arbol ; r:reclamo);
begin
  if (a=nil) then begin
    new(a);
    a^.dni:=r.dni;
    a^.cant:=1;
    a^.pri:=nil;
    agregarAdelante(a^.pri,r.info);
    a^.HI:=nil;
    a^.HD:=nil;
  end
  else
    if (a^.dni = r.dni) then begin
      agregarAdelante(a^.pri,r.info);
      a^.cant:=a^.cant+1;
    end
    else begin
      if (a^.dni < r.dni) then
        insertarEnArbol(a^.HD,r)
      else
        insertarEnArbol(a^.HI,r);
    end;
end;


procedure cargarArbol(var a:arbol);
var
  r:reclamo;
begin
  leerReclamo(r);
  while (r.info.codigo <> 0) do begin
    insertarEnArbol(a,r);
    leerReclamo(r);
  end;
end;

function cantReclamos(a:arbol; dni:integer):integer;
begin
  if (a = nil) then
    cantReclamos:=0
  else begin
    if (a^.dni = dni) then
      cantReclamos:=a^.cant
    else
      if (dni < a^.dni) then
        cantReclamos:=cantReclamos(a^.HI,dni)
      else
        cantReclamos:=cantReclamos(a^.HD,dni);
  end;
end;

procedure incisoB(a:arbol);
var
  dni:integer;
begin
  writeln('Inciso B: buscar cantidad de reclamos');
  write('DNI :');
  readln(dni);
  writeln('La cantidad de reclamos de ese dni es ',cantReclamos(a,dni));
end;

procedure buscarAnio(l:lista; anio:integer; var listaCod:listaCodigos);
begin
  while (l<>nil) do begin
    if (l^.dato.anio = anio) then begin
      agregarCodigo(listaCod,l^.dato.codigo);//porque dice retorne debe devolver una lista con dichos codigos.
    end;
    l:=l^.sig;
  end;
end;

procedure incisoD(a:arbol; anio:integer; var l:listaCodigos);
begin
  if (a <> nil) then begin
    incisoD(a^.HI,anio,l);
    buscarAnio(a^.pri,anio,l);
    incisoD(a^.HD,anio,l);
  end;
end;

procedure codigosEnAnio(a:arbol);
var
  anio:integer;
  l:listaCodigos;
begin
  l:=nil;
  writeln('Ingrese año a buscar: ');
  readln(anio);
  writeln();
  incisoD(a,anio,l);
  writeln('Codigos de reclamos de ese anio: ');
  while (l<>nil) do begin
    writeln(l^.dato);
    l:=l^.sig;
  end;
end;

function contarEnRango(a:arbol;dni1,dni2:integer):integer;
begin
  if (a=nil) then
    contarEnRango:=0
  else begin
    if (a^.dni > dni1) then
      if (a^.dni < dni2) then
        contarEnRango:=a^.cant + contarEnRango(a^.HI,dni1,dni2) + contarEnRango(a^.HD,dni1,dni2)
      else
        contarEnRango:=contarEnRango(a^.HI,dni1,dni2)
    else
      contarEnRango:=contarEnRango(a^.HD,dni1,dni2);
  end;
end;

procedure incisoC(a:arbol);
var
  d1,d2:integer;
begin
  writeln('');
  writeln('Inciso C, contar reclamos entre 2 dni:');
  write('Ingrese el primer numero de dni:');
  readln(d1);
  write('Ingrese el segundo numero de dni:');
  readln(d2);
  writeln('La cantidad de reclamos entre esos dni es',contarEnRango(a,d1,d2));
  writeln();
  
end;

var
 a:arbol;
begin
  a:=nil;
  cargarArbol(a);
  incisoB(a);
  codigosEnAnio(a);
  incisoC(a);
end.
