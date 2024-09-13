{Parcial tomado el 10-9-24 turno E recursantes.
La Feria del libro necesita un sistema para obtener estadísticas sobre los libros
presentados.
a)Implementar un módulo que lea la información de los libros. De cada libro se conoce:
ISBN,código de autor y código de género 1:literario,2:filosofia,3:biologia,4:arte,
5:computacion,6:medicina,7:ingenieria.
La lectura finaliza con el valor 0 para el isbn. 
El módulo debe retornar 2 estructuras:
i)Un árbol binario de búsqueda ordenado por código de autor. Para cada código de autor
debe almacenarse la cantidad de libros correspondientes al código.
ii)Un vector que almacene para cada género,el código del género y la cantidad de libros
del género.
b) Implementar un módulo que reciba el vector generado en a) lo ordene por cantidad
de libros de mayor a menor y retorne el nombre del género con mayor cantidad de libros.
c)Implementar un módulo que reciba el árbol generado en a) y dos códigos. El módulo 
debe retornar la cantidad total de libros correspondientes a los códigos de autores 
entre los códigos ingresados (incluidos ambos).
}
program parcialFeriaLibro;

type

  libro=record
    autor:integer;
    isbn:integer;
    genero:integer;
  end;
  
  arbol =^nodo;
  
  nodo=record
    autor:integer;
    cant:integer;
    HI,HD:arbol;
  end;
  
  infoGenero=record
    genero:integer;
    cant:integer;
  end;
  
  vector = array [1..7] of infoGenero;
  
procedure leerLibro(var l:libro);
begin
  l.isbn:=random(1000);
  if (l.isbn<>0) then begin
    l.autor:=random(100)+1;
    l.genero:=random(7)+1;
  end;
end;

procedure insertarEnArbol(var a:arbol; l:libro);
begin
  if (a=nil) then begin
    new(a);
    a^.autor:=l.autor;
    a^.cant:=1;
    a^.HI:=nil;
    a^.HD:=nil;
  end
  else begin
    if (a^.autor = l.autor) then
      a^.cant:=a^.cant+1
    else
      if (a^.autor < l.autor) then
        insertarEnArbol(a^.HD,l)
      else
        insertarEnArbol(a^.HI,l);
  end;
end;

procedure inicializarVector(var v:vector);
var 
  i:integer;
begin
  for i:=1 to 7 do
    v[i].cant:=0;
end;

procedure incisoA(var a:arbol; var v:vector);
var
  l:libro;
begin
  inicializarVector(v);
  leerLibro(l);
  while (l.isbn <> 0) do begin
    insertarEnArbol(a,l);
    v[l.genero].genero:=l.genero;
    v[l.genero].cant:=v[l.genero].cant + 1;
    leerLibro(l);   
  end;
end;

procedure imprimirArbol(a:arbol);
begin
  if (a<>nil) then begin
    imprimirArbol(a^.HI);
    writeln('autor nro ',a^.autor,' libros ',a^.cant);
    imprimirArbol(a^.HD);
  end;
end;

procedure imprimirVector(v:vector); //para control
var 
  i:integer;
begin
  for i:=1 to 7 do 
    writeln('genero ',v[i].genero,' cantidad ',v[i].cant);
end;

procedure ordenarVector(var v:vector);
var
  i,j:integer; act:infoGenero;
begin 
  for i:=2 to 7 do begin
    j:=i-1;
    act:=v[i];
    while (j>0) and ( v[j].cant < act.cant) do begin
      v[j+1]:=v[j];
      j:=j-1;
    end;
    v[j+1]:=act;
  end;
end;

procedure incisoB(var v:vector);
var
  gen:array [1..7] of String=('literario','filosofia','biologia','arte','computacion','medicina','ingenieria');
begin
  ordenarVector(v);
  writeln('genero con mas publicaciones ',gen[v[1].genero]);
end;

function contarLibros(a:arbol;cod1,cod2:integer):integer;
begin
  if (a = nil) then
    contarLibros:=0
  else  begin
    if (a^.autor >= cod1) then begin
      if (a^.autor <= cod2) then
        contarLibros:=a^.cant + contarLibros(a^.HI,cod1,cod2) + contarLibros(a^.HD,cod1,cod2)
      else
        contarLibros:=contarLibros(a^.HI,cod1,cod2);
    end
    else
      contarLibros:=contarLibros(a^.HD,cod1,cod2);
  end;   
end;

procedure incisoC(a:arbol);
var
  c1,c2,cant:integer;
begin
  writeln('Inciso C, contar cantidad de libros entre 2 codigos de autores: ');
  write('codigo de autor 1: '); readln(c1);
  write('codigo de autor 2: '); readln(c2);
  cant:=contarLibros(a,c1,c2);
  writeln('La cantidad de libros entre esos codigos es ',cant);
end;

var
  a:arbol;
  v:vector;
begin
  randomize;
  a:=nil;
  incisoA(a,v);
  imprimirArbol(a);//para control
  incisoB(v);
  incisoC(a);
end.
