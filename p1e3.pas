{Netflix ha publicado la lista de películas que estarán disponibles durante el mes de 
diciembre de 2022. De cada película se conoce: código de película, código de género (1: acción, 
2: aventura, 3: drama, 4: suspenso, 5: comedia, 6: bélico, 7: documental y 8: terror) y puntaje 
promedio otorgado por las críticas. 
Implementar un programa que invoque a módulos para cada uno de los siguientes puntos:
a. Lea los datos de películas, los almacene por orden de llegada y agrupados por código de 
género, y retorne en una estructura de datos adecuada. La lectura finaliza cuando se lee el 
código de la película -1.
b. Genere y retorne en un vector, para cada género, el código de película con mayor puntaje 
obtenido entre todas las críticas, a partir de la estructura generada en a)..
c. Ordene los elementos del vector generado en b) por puntaje utilizando alguno de los dos 
métodos vistos en la teoría. 
d. Muestre el código de película con mayor puntaje y el código de película con menor puntaje, 
del vector obtenido en el punto c).

DUDA: SI EL VECTOR GENERADO EN B NO TIENE ELEMENTOS EN ALGÚN GENERO, SE PUEDE ORDENAR?

}
program p1e3;

const 
  finVector=8;

type

  rangoGen = 1..finVector;
  
  pelicula=record
    codigo:integer;
    genero:rangoGen;
    puntaje:real;
  end;
  
  lista=^nodo;
  
  nodo=record
    dato:pelicula;
    sig:lista;
  end;
  
  punterosPelis=record
    l:lista;
    ul:lista;
  end;
  
  vector = array[rangoGen] of punterosPelis; //es vector de listas, pero para agregar atrás guardo un puntero al último también, por lo que queda un vector de registros con 2 campos punteros
  
  vectorMejores=array[rangoGen] of pelicula;
  
  procedure leerPeli(var p:pelicula);
  begin
    write('Codigo: ');
    readln(p.Codigo);
    if (p.Codigo<>-1) then begin
      p.genero:=random(8)+1;
      writeln('Genero: ',p.genero);
      p.puntaje:=random(9)+1;
      writeln('Puntaje: ',p.puntaje:2:2);
    end;
  end;

  procedure inicializarVector(v:vector);
  var
   i:rangoGen;
  begin
    for i:=1 to 8 do
      v[i].l:=nil;
  end;
  
  procedure agregarAtras(var l,ul:lista; p:pelicula);
  var
    nue:lista;
  begin
    new(nue);
    nue^.dato:=p;
    nue^.sig:=nil;
    if (l=nil) then begin
      l:=nue;
      ul:=nue;
    end
    else begin
      ul^.sig:=nue;
      ul:=nue;
    end;
  end;
  
  procedure generarVector(var v:vector);
  var
    p:pelicula;
  begin
    leerPeli(p);
    inicializarVector(v); //IMPORTANTA INICIALIZAR EN NIL LAS LISTAS QUE CONTIENE EL VECTOR
    while (p.Codigo <>-1) do begin
      agregarAtras(v[p.genero].l,v[p.genero].ul,p);
      leerPeli(p);
    end;
  end;
  
procedure mejorPuntaje(l:lista; var p:pelicula);
var
max:real;
mejorP:pelicula;
begin
  max:=-1;
  while (l<>nil) do begin
    if (l^.dato.puntaje > max) then begin
      max:=l^.dato.puntaje;
      mejorP:=l^.dato;
    end;
    l:=l^.sig;
  end;
  p:=mejorP;
end;

procedure retornarMejores(v:vector; var vec:vectorMejores);
var
  i:rangoGen; p:pelicula;
begin
  for i:= 1 to 8 do begin
    if (v[i].l <> nil) then begin
      mejorPuntaje(v[i].l,p);
      vec[i]:=p;
    end;
  end;
end;

procedure imprimirMejores(v:vectorMejores);
var
  i:rangoGen;
begin
  for i:= 1 to 8 do
    writeln('Pelicula: ',v[i].codigo,' Genero ',i,' puntaje: ',v[i].puntaje:2:2);
end;

procedure ordenarVector(var v:vectorMejores);
var
  i,j:integer; actual:pelicula;
begin
  for i:=2 to finVector do begin
    actual:=v[i];
    j:=i-1;
    while (j > 0) and (v[j].puntaje > actual.puntaje) do begin
      v[j+1]:=v[j];
      j:=j-1;
    end;
    v[j+1]:=actual; //si sale porque j es 0, va en la pos 1, si sale porque v[j] es menor, va en la pos siguiente a j
  end;
end;

procedure mejorYPeor(v:vectorMejores);
begin
  writeln('La pelicula mejor puntuada es ',v[finVector].codigo);
  writeln('La pelicula peor puntuada es ',v[1].codigo);
end;


var
  v:vector; vM:vectorMejores;
begin
  randomize;
  generarVector(v);
  retornarMejores(v,vM);
  imprimirMejores(vM);
  ordenarVector(vM);
  writeln('-------Vector ordenado: -----------');
  imprimirMejores(vM);
  mejorYPeor(vM);
end.
