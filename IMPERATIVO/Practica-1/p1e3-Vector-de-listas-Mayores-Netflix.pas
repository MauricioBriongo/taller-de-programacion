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

IMPORTANTE: (SE PRESUME QUE HAY POR LO MENOS UNA PELÍCULA PARA CADA GENERO)

}
program p1e3;

const 
  finVector=8;

type

  rangoGen = 1..finVector;
  
  infoPeli = record  //info a guardar en la lista, para no repetir la información de género
    codigo:integer;
    puntaje:real;
  end;
  
  pelicula=record
    genero:rangoGen;
    info:infoPeli;
  end;
  
  lista=^nodo;
  
  nodo=record
    dato:infoPeli;
    sig:lista;
  end;
  
  punterosPelis=record
    l:lista;
    ul:lista;
  end;
  
  vector = array[rangoGen] of punterosPelis; //es vector de listas, pero para agregar atrás guardo un puntero al último también, por lo que queda un vector de registros con 2 campos punteros
  
  vectorMejores=array[rangoGen] of  infoPeli;
  
  procedure leerPeli(var p:pelicula);
  begin
    write('Codigo: ');
    readln(p.info.Codigo);
    {p.info.codigo:=random(100)-1;      //para probar con grandes cantidades de peliculas
    writeln('Codigo: ',p.info.codigo);}
    if (p.info.Codigo<>-1) then begin
      p.genero:=random(8)+1;
      writeln('Genero: ',p.genero);
      p.info.puntaje:=random(10)+1;
      writeln('Puntaje: ',p.info.puntaje:2:2);
    end;
  end;

  procedure inicializarVector(v:vector);
  var
   i:rangoGen;
  begin
    for i:=1 to 8 do
      v[i].l:=nil;
  end;
  
  procedure agregarAtras(var l,ul:lista; p:infoPeli);
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
    inicializarVector(v);
    while (p.info.Codigo <>-1) do begin
      agregarAtras(v[p.genero].l,v[p.genero].ul,p.info);
      writeln();
      leerPeli(p);
    end;
  end;
  
procedure mejorPuntaje(l:lista; var p:infoPeli);
var

max:real;
mejorP:infoPeli;
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
  i:rangoGen; p:infoPeli;
begin
  for i:= 1 to 8 do begin
    mejorPuntaje(v[i].l,p);
    vec[i]:=p;
  end;
end;

procedure imprimirMejores(v:vectorMejores);
var
  i:rangoGen;
begin
  for i:= 1 to 8 do begin
    write('Pelicula: ',v[i].codigo,' puntaje: ',v[i].puntaje:2:2);
    case i of
      1: writeln(' accion');
      2: writeln(' aventura');
      3: writeln(' drama');
      4: writeln(' suspenso');
      5: writeln(' comedia');
      6: writeln(' belico');
      7: writeln(' documental');
      8: writeln(' terror');
    end;
  end;
end;

procedure ordenarVector(var v:vectorMejores);
var
  i,j,pos:rangoGen; p:infoPeli;
begin
  for i:=1 to finVector-1 do begin
    pos:=i;
    for j:=i+1 to finVector do
      if (v[j].puntaje < v[pos].puntaje) then
        pos:=j;
    p:=v[pos];
    v[pos]:=v[i];
    v[i]:=p;
  end;
end;

procedure mejorYPeor(v:vectorMejores);
begin
  writeln('El codigo de la pelicula con mejor puntaje es: ',v[8].codigo);
  writeln('El codigo de la pelicula con menor puntaje es: ',v[1].codigo);
end;

var
  v:vector; vM:vectorMejores;
begin
  randomize;
  generarVector(v);
  retornarMejores(v,vM);
  writeln();
  imprimirMejores(vM);
  ordenarVector(vM);
  writeln('-------Vector ordenado: -----------');
  imprimirMejores(vM);
  writeln();
  mejorYPeor(vM);
end.
