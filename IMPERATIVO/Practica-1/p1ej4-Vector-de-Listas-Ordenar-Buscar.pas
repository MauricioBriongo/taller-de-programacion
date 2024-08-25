{4.- Una librería requiere el procesamiento de la información de sus productos. De cada producto
se conoce el código del producto, código de rubro (del 1 al 8) y precio.
Implementar un programa que invoque a módulos para cada uno de los siguientes puntos:
a. Lea los datos de los productos y los almacene ordenados por código de producto y agrupados
por rubro, en una estructura de datos adecuada. El ingreso de los productos finaliza cuando se
lee el precio 0.
b. Una vez almacenados, muestre los códigos de los productos pertenecientes a cada rubro.
c. Genere un vector (de a lo sumo 30 elementos) con los productos del rubro 3. Considerar que
puede haber más o menos de 30 productos del rubro 3. Si la cantidad de productos del rubro 3
es mayor a 30, almacenar los primeros 30 que están en la lista e ignore el resto.
d. Ordene, por precio, los elementos del vector generado en c) utilizando alguno de los dos
métodos vistos en la teoría.
e. Muestre los precios del vector resultante del punto d).
f. Calcule el promedio de los precios del vector resultante del punto d).}

program vectorDeListas;

uses crt; //declaracion para usar el comando ClrScr que limpia la pantalla

type

  subRubro=1..8;
  
  infoProd=record
    codigo:integer;
    precio:real;
  end;
  
  producto = record   
    rubro:integer;
    info:infoProd;
  end;
  
  listaProd=^nodo;
  
  nodo=record
    dato:infoProd;
    sig:listaProd;
  end;
  
  vectorProd = array[subRubro] of listaProd;
  
  vectorRubro3 = array[1..30] of listaProd;
  
  //------------MODULOS--------------------- 
procedure leerProducto(var p:producto);
begin
  write('Ingrese el precio del producto: ');
  readln(p.info.precio);
  if (p.info.precio <> 0) then
  begin
    Write('Ingrese codigo de producto: ');
    readln(p.info.codigo);
    write('Ingrese el rubro del producto (1 a 8): ');
    readln(p.rubro);
    while (p.rubro < 1) or (p.rubro > 8) do begin
      writeln('Rubro incorrecto, ingrese numero entre 1 y 8 ');
      readln(p.rubro);
    end;
  end;
end;

procedure insertarOrdenado(var l:listaProd; p:infoProd);
var
  nue,act,ant:listaProd;
begin
  new(nue); 
  nue^.dato:=p; 
  ant:=l;
  act:=l;
  while ((act <> nil) and (p.codigo > act^.dato.codigo)) do
  begin
    ant:=act;
    act:=act^.sig;
  end; 
  if (act = ant) then
    l:=nue
  else
    ant^.sig:=nue;
  nue^.sig:=act;
end;

procedure inicializarVector(var v:vectorProd);
var
  i:subRubro;
begin
  for i:=1 to 8 do
    v[i]:=nil;
end;

procedure cargarVector(var v:vectorProd);
var
  p:producto;
begin
  leerProducto(p);
  while (p.info.precio <> 0) do begin
    insertarOrdenado(v[p.rubro],p.info);
  //  ClrScr;
    leerProducto(p);  
  end;
end;

procedure imprimiVector(v:vectorProd);
var
  i:integer;
begin
  for i:=1 to 8 do
    begin
      write('Rubro: ',i,' - ');
      while (v[i] <> nil ) do 
        begin
          write('producto: ',v[i]^.dato.codigo,' - ');
          v[i]:=v[i]^.sig;
        end;
        writeln();
    end;
end;

procedure imprimirVector3(v:vectorRubro3;dl:integer);
var
  i:integer;
begin
  writeln('Rubro3: ');
  for i:= 1 to dl do
  begin
    writeln(v[i]^.dato.codigo,' $ ',v[i]^.dato.precio:2:2);   
  end;
end;

procedure productosRubro3(var v3:vectorRubro3;var dl:integer; v:vectorProd);
  
begin
  dl:=0;
  while (v[3] <> nil) and (dl<30) do
  begin
    dl:=dl+1;
    v3[dl]:=v[3];
    v[3]:=v[3]^.sig;
  end;
end;

procedure ordenarVector(var v:vectorRubro3; dl:integer); //ordena por precio ascendente
var
i,j:integer;
actual:listaProd;
begin
  for i:=2 to dl do
  begin
    actual:=v[i];
    j:=i-1;
    while (j>0) and (v[j]^.dato.precio > actual^.dato.precio) do
    begin
      v[j+1]:=v[j];
      j:=j-1;
    end;
    v[j+1]:=actual;
  end;
end;

function promedioPrecios(v:vectorRubro3; dl:integer):real;
var
  i:integer;
  aux:real;
begin
  aux:=0;
  for i:=1 to dl do
  begin
    aux:=aux+v[i]^.dato.precio;
  end;
  promedioPrecios:= aux / dl;
end;

var
  v:vectorProd;
  v3:vectorRubro3;
  dl:integer;
begin
  cargarVector(v);
  clrScr;
  imprimiVector(v);
  writeln();
  writeln();
  productosRubro3(v3,dl,v);
  imprimirVector3(v3,dl);
  writeln();
  ordenarVector(v3,dl);
  writeln();
  imprimirVector3(v3,dl);
  writeln();
  writeln('El promedio de precios del rubro 3 es: ',promedioPrecios(v3,dl):2:2);
end.
