{2. Escribir un programa que:
a. Implemente un módulo que genere aleatoriamente información de ventas de un comercio.
Para cada venta generar código de producto, fecha y cantidad de unidades vendidas. Finalizar
con el código de producto 0. Un producto puede estar en más de una venta. Se pide:
i. Generar y retornar un árbol binario de búsqueda de ventas ordenado por código de
producto. Los códigos repetidos van a la derecha.
ii. Generar y retornar otro árbol binario de búsqueda de productos vendidos ordenado por
código de producto. Cada nodo del árbol debe contener el código de producto y la
cantidad total de unidades vendidas.
iii. Generar y retornar otro árbol binario de búsqueda de productos vendidos ordenado por
código de producto. Cada nodo del árbol debe contener el código de producto y la lista de
las ventas realizadas del producto.
Nota: El módulo debe retornar TRES árboles.
b. Implemente un módulo que reciba el árbol generado en i. y una fecha y retorne la cantidad
total de productos vendidos en la fecha recibida
c. Implemente un módulo que reciba el árbol generado en ii. y retorne el código de producto
con mayor cantidad total de unidades vendidas.
c. Implemente un módulo que reciba el árbol generado en iii. y retorne el código de producto
con mayor cantidad de ventas.
}
program p3e2Arboles;

type

  rangoDia = 1..31;
  
  rangoMes = 1..12;
  
  fecha = record
    dia:rangoDia;
    mes:rangoMes;
    anio:integer;
  end;
  
  infoVenta = record
    fec:fecha;
    cant:integer;
  end;
  
  venta = record
    codigo:integer;
    info:infoVenta;
  end;
  
  ventas = ^nodoVentas; //arbol inciso i
  
  nodoVentas = record
    dato:venta;
    HD:ventas;
    HI:ventas;
  end;
  
  cantVendidos =^nodoVendidos; //arbol inciso ii
  
  nodovendidos = record
    codigo:integer;
    cant:integer;
    HD:cantVendidos;
    HI:cantVendidos;
  end;
  
  listaVentas=^nodoLista;
  
  nodoLista = record
    dato:infoVenta;
    sig:listaVentas;
  end;
  
  arbolDeListas =^nodoArbolDeListas; //arbol inciso iii
  
  nodoArbolDeListas = record
    codigo:integer;
    dato:listaVentas;
    HI:arbolDeListas;
    HD:arbolDeListas;
  end;
  
  
procedure generarFechaAleatoria(var f:fecha);
begin
  f.anio:=random(24)+2001;
  f.mes:=random(12)+1;
  case f.mes of                              //PARA QUE NO SE GENERE UN 31 DE FEBRERO
    1,3,5,7,8,10,12 : f.dia:= random(31)+1;
    4,6,9,11: f.dia:=random(30)+1;
    2: f.dia:=random(28)+1;
  end;
end;
  
procedure generarVenta(var v:venta);
begin
  v.codigo:=random(100);
  if (v.codigo <> 0) then begin
    generarFechaAleatoria(v.info.fec);
    v.info.cant:=random(100)+1;
  end;
end;

procedure cargarArbolVentas(var a:ventas; v:venta);
begin
  if (a = nil) then begin
    new(a);
    a^.dato:= v;
    a^.HI:=nil;
    a^.HD:=nil;
  end
  else begin
  if (v.codigo < a^.dato.codigo) then
    cargarArbolVentas(a^.HI,v)
  else
    cargarArbolVentas(a^.HD,v);
  end;
end;

procedure cargarArbolVendidos(var a:cantVendidos; v:venta);
begin
  if (a=nil) then begin
    new(a);
    a^.codigo:=v.codigo;
    a^.cant:=v.info.cant;
    a^.HI:=nil;
    a^.HD:=nil;
  end
  else begin
    if (v.codigo = a^.codigo) then
      a^.cant:= a^.cant + v.info.cant
    else begin
      if (v.codigo < a^.codigo) then
        cargarArbolVendidos(a^.HI,v)
      else
         cargarArbolVendidos(a^.HD,v);
    end;
  end;
end;

procedure agregarAdelante(var l:listaVentas; dato:infoVenta);
var
  nue:listaVentas;
begin
  new(nue);
  nue^.dato:=dato;
  nue^.sig:=l;
  l:=nue;    
end;

procedure cargarArbolListas(var a:arbolDeListas; v:venta);
begin
  if (a = nil) then begin
    new(a);
    a^.codigo:=v.codigo;
    a^.dato:=nil;
    agregarAdelante(a^.dato,v.info);
    a^.HI:=nil;
    a^.HD:=nil;
  end
  else
    if (a^.codigo = v.codigo) then
      agregarAdelante(a^.dato,v.info)
    else begin
      if (a^.codigo > v.codigo) then
        cargarArbolListas(a^.HI,v)
      else
        cargarArbolListas(a^.HD,v);
    end;
end;

procedure generarArboles(var aV:ventas; var aV2:cantVendidos; var aV3:arbolDeListas);
var
  v:venta;
begin
  aV:=nil;
  aV2:=nil;
  generarVenta(v);
  while (v.codigo <> 0) do begin
    cargarArbolVentas(aV,v);
    cargarArbolVendidos(aV2,v);
    cargarArbolListas(aV3,v);
    generarVenta(v);
  end;
end;


procedure imprimirArbol(a:ventas);
begin
  if (a<>nil) then begin
    imprimirArbol(a^.HI);
    writeln('cod. ',a^.dato.codigo,' ',a^.dato.info.fec.dia,'/',a^.dato.info.fec.mes,'/',a^.dato.info.fec.anio,' cantidad: ',a^.dato.info.cant);
    imprimirArbol(a^.HD);
  end;
end; 

procedure imprimirArbolVendidos(a:cantVendidos);
begin
  if (a<>nil) then begin
    imprimirArbolVendidos(a^.HI);
    writeln('cod. ',a^.codigo,' cant. ',a^.cant);
    imprimirArbolVendidos(a^.HD);
  end;
end;
  
procedure imprimirVenta(v:venta);
begin
  writeln(v.codigo);
  write(v.info.fec.dia,' ');
  write(v.info.fec.mes,' ');
  writeln(v.info.fec.anio,' ');
  writeln(v.info.cant);
end;

procedure imprimirLista(l:listaVentas);
begin
  while (l<>nil) do begin
    writeln(l^.dato.fec.dia,'/',l^.dato.fec.mes,'/',l^.dato.fec.anio,' cant: ',l^.dato.cant);
    l:=l^.sig;
  end;
  writeln();
end;

procedure imprimirArbolDelistas(a:arbolDeListas);
begin
  if (a<>nil) then begin
    imprimirArbolDelistas(a^.HI);
    write(a^.codigo,' | ');
    imprimirLista(a^.dato);
    imprimirArbolDelistas(a^.HD);
  end;
end;

function mismaFecha(f1:fecha; f2:fecha):boolean;
begin
  mismaFecha:=(f1.dia=f2.dia)and(f1.mes=f2.mes)and(f1.anio=f2.anio);
end;

function productosEnFecha(a:ventas; f:fecha):integer;
begin
  if (a<>nil) then begin
    if (mismaFecha(a^.dato.info.fec,f))then
      productosEnFecha:= 1 + productosEnFecha(a^.HI,f) + productosEnFecha(a^.HD,f)
    else
      productosEnFecha:=productosEnFecha(a^.HI,f)+productosEnFecha(a^.HD,f);
  end
  else
  productosEnFecha:=0
end;

function max(n1,n2:integer):integer;
begin
  if (n1 < n2) then
    max:= n2
  else
    max:=n1;
end;

procedure mayorCant(a:cantVendidos; var max:integer; var maxCod:integer);
begin
  if (a <> nil) then begin
    if (a^.cant > max) then begin
      max:=a^.cant;
      maxCod:=a^.codigo;
    end;
    mayorCant(a^.HI,max,maxCod);
    mayorCant(a^.HD,max,maxCod);
  end;
end;

procedure productoMasVendido(a:cantVendidos);
var
  max:integer;
  maxCod:integer;
begin 
  max:=-1;
  mayorCant(a,max,maxCod);
  if (max = -1) then
    writeln('Estructura sin elementos')
  else
    writeln('El codigo de producto con mas unidades vendidas es ',maxCod);
end;

function contarLista(l:listaVentas):integer;
begin
  if (l <> nil) then
    contarLista:= 1 + contarLista(l^.sig)  
  else
    contarLista:=0;
end;

procedure cantVentas(a:arbolDelistas; var max:integer; var cod:integer); //recorre los nodos del arbol contando la cantidad de elementos que tiene el dato lista de cada uno y retorna el mayor 
var
  aux:integer; //para no calcular 2 veces la funcion contarlista
begin
  if (a <> nil) then begin
    aux:=contarLista(a^.dato);
    if (aux > max) then begin
      max:=aux;
      cod:=a^.codigo;
    end;
    cantVentas(a^.HI,max,cod);
    cantVentas(a^.HD,max,cod);
  end;
end;

procedure contarCantArbolDeListas(a:arbolDeListas);
var
  max,cod:integer;
begin
  max:=-1; cod:=-1;
  cantVentas(a,max,cod);
  if (max <> -1) then
    writeln('El codigo con mayor cantidad de ventas es ',cod)
  else
    writeln('El arbol no tiene elementos');
end;

  
var
aV:ventas;
aV2:cantVendidos;
av3:arbolDeListas;
cant:integer;
fec:fecha;
begin
  randomize;
  generarArboles(aV,aV2,aV3);
  writeln();
  writeln('Arbol de ventas ordenado por codigo de produto:');
  imprimirArbol(aV);
  writeln();
  writeln('Ingrese un fecha a buscar');
  write('DIA: ');
  readln(fec.dia);
  write('MES: ');
  readln(fec.mes);
  write('Anio: ');
  readln(fec.anio);
  cant:=productosEnFecha(aV,fec);
  writeln('cantidad: ',cant);
  writeln('presiona enter para continuar');
  readln();
  writeln();
  writeln('Arbol de cantidad de unidades vendidas por producto ordenado por codigo:');
  imprimirArbolVendidos(aV2);
  writeln(' //// INCISO C ////');
  productoMasVendido(aV2);
  writeln();
  writeln('Arbol de listas de ventas, ordenado por codigo:');
  imprimirArbolDelistas(aV3);
  contarCantArbolDeListas(aV3);
end.
