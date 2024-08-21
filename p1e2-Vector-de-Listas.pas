{Implementar un módulo para almacenar en una estructura adecuada, las propiedadesagrupadas por 
zona. 
Las propiedades de una misma zona deben quedar almacenadasordenadas por tipo de propiedad. 
Para cada propiedad debe almacenarse el código, el tipo depropiedad y el precio total. 
De cada propiedad se lee: zona (1 a 5), código de propiedad, tipode propiedad, cantidad de metros cuadrados y precio del metro cuadrado. 
La lectura finalizacuando se ingresa el precio del metro cuadrado -1.}

program pIe2;

type
  propiedad = record
    codigo: integer;
    tipo: string;
    precio: real;
  end;
  
  lista = ^nodo;
  
  nodo = record
    dato: propiedad;
    sig:lista;
  end;
  
  vectorZonas = array [1..5] of lista;
  
procedure leerPropiedad(var pro: propiedad);
var
  precio, metros: integer;
begin
  Write('Ingrese el precio del metro cuadrado: '); readln(precio);
  if (precio <> -1) then
  begin
    write('Ingrese Cantidad de metros cuadrados:'); readln(metros);
    pro.precio:= (precio*metros);
    write('Ingrese el tipo de propiedad:'); readln(pro.tipo);
    write('Ingrese el codigo de la propiedad: '); readln(pro.codigo)
  end
    else
      pro.precio:= precio;
end;


procedure insertarOrdenado(var l:lista; p: propiedad);
var
nue, ant, act: lista;
begin
  new (nue); nue^.dato:= p;
  ant:= l; act:= l;
  while (act <> nil) and (p.tipo < act^.dato.tipo) do
    begin
      ant:=act;
      act:= act^.sig;
    end;
  if (ant = act) then  //si la lista esta vacia, o si va al principio
    l:= nue
  else
    ant:=nue;   //si va al medio o al final
  nue^.sig:=act;
end;

procedure inicializarVectorDeListas(var v: vectorZonas);
var
  i:integer;
begin
  for i:= 1 to 5 do
    v[i]:= nil;
end;

procedure cargarZonas(var vec:vectorZonas);
var
p:propiedad; zona:integer;
begin
  leerPropiedad(p);
  while (p.precio <> -1) do begin
   writeln('Ingrese la zona de la propiedad (1 a 5): '); 
   readln(zona);
   insertarOrdenado(vec[zona],p);
   leerPropiedad(p);
  end;
end;

{b) Implementar un módulo que reciba la estructura generada en a), un número de zona y un
tipo de propiedad y retorne los códigos de las propiedades de la zona recibida y del tipo recibido.}
procedure buscarEnZona(v: vectorZonas; zona:integer; tipo:string);//el problema se facilita si lo que se recibe es la lista directamente, en lugar del vecrtor de listas
begin
  while(v[zona]<>nil) and (v[zona]^.dato.tipo <= tipo)do begin
      if (v[zona]^.dato.tipo = tipo) then
        writeln(v[zona]^.dato.codigo);//agregarAtras
      v[zona]:= v[zona]^.sig;
  end;
      
      
end;

procedure imprimir(v:vectorZonas);
var
  i:integer;
begin
  for i:=1 to 5 do begin
    while(v[i]<>nil) do begin
      write(' cod ',v[i]^.dato.codigo,' tipo ',v[i]^.dato.tipo);
      writeln();
      v[i]:=v[i]^.sig;
    end;
  end;
end;

var
vec:vectorZonas;
begin
  inicializarVectorDeListas(vec);
  cargarZonas(vec);
  imprimir(vec);
  buscarEnZona(vec,1,'casa');
end.
