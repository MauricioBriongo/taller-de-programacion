{Una agencia dedicada a la venta de autos ha organizado su stock y, tiene la información de
los autos en venta. Implementar un programa que:
a) Genere la información de los autos (patente, año de fabricación (2010..2018), marca y
modelo, finalizando con marca ‘MMM’) y los almacene en dos estructuras de datos:
i. Una estructura eficiente para la búsqueda por patente.
ii. Una estructura eficiente para la búsqueda por marca. Para cada marca se deben
almacenar todos juntos los autos pertenecientes a ella.
b) Invoque a un módulo que reciba la estructura generado en a) i y una marca y retorne la
cantidad de autos de dicha marca que posee la agencia.
c) Invoque a un módulo que reciba la estructura generado en a) ii y una marca y retorne
la cantidad de autos de dicha marca que posee la agencia.
d) Invoque a un módulo que reciba el árbol generado en a) i y retorne una estructura con
la información de los autos agrupados por año de fabricación.
e) Invoque a un módulo que reciba el árbol generado en a) i y una patente y devuelva el
modelo del auto con dicha patente.
f) Invoque a un módulo que reciba el árbol generado en a) ii y una patente y devuelva el
modelo del auto con dicha patente.}

program p5e2;

type
  rango = 2010..2018;

  infoLista = record
    patente:integer;
    anio:rango;
    modelo:String
  end;
  
  infoRegistro = record
    marca:String;
    anio:rango;
    modelo:String;
  end;
  
  infoVector = record
    marca:String;
    patente:integer;
    modelo:String;
  end;

  auto = record
    marca:String;
    patente:integer;
    anio:integer;
    modelo:String;
  end;
  
  arbolPorPatentes=^nodoPat;
  
  nodoPat = record   //EFICIENTE PARA BUSQUEDA POR PATENTE
    patente:integer;
    dato:infoRegistro;
    HI,HD:arbolPorPatentes;
  end;
  
  lista=^nodoLista;
  
  nodoLista = record  
    dato:infoLista;
    sig:lista;
  end;
  
  arbolLista=^nodoMarca;
  
  nodoMarca = record  //UN NODO ORDENADO POR MARCA ALMACENA TODOS LOS AUTOS DE ESA MARCA
    marca:String;
    pri:lista;
    HI,HD:arbolLista;
  end;
  
  listaVector=^nodoListaV;
  
  nodoListaV = record
    dato:infoVector;
    sig:listaVector;
  end;
  
  vector = array [rango] of listaVector;
  
procedure leerAuto(var a:auto);
var v : array[1..5] of String=('Nuevo','Usado','Gasolero','0km','chatarra');
begin
  write('Marca: ');
  readln(a.marca);
  if (a.marca <> 'mmm') then begin
    a.patente:=random(1000)+1;
    a.anio:=random(9)+2010;
    a.modelo:=v[random(5)+1];
  end;
end;

procedure armarNodoPat(a:auto; var info:infoRegistro);
begin
  info.marca:=a.marca;
  info.anio:=a.anio;
  info.modelo:=a.modelo;
end;

procedure armarNodoLista(a:auto; var info:infoLista);
begin
  info.patente:=a.patente;
  info.anio:=a.anio;
  info.modelo:=a.modelo;
end;

procedure armarNodoVector(a:arbolPorPatentes; var info:infoVector);
begin
  info.marca:=a^.dato.marca;
  info.patente:=a^.patente;
  info.modelo:=a^.dato.modelo;
end;

procedure agregarListaEnVector(var l:listaVector; info:infoVector);
var
  nue:listaVector;
begin
  new(nue);
  nue^.dato:=info;
  nue^.sig:=l;
  l:=nue;
end;

procedure agregarAdelante(var l:lista;dato:infoLista);
var
  nue:lista;
begin
  new(nue);
  nue^.dato:=dato;
  nue^.sig:=l;
  l:=nue;
end;

procedure insertarEnArbolListas(var a:arbolLista; au:auto);
var
  info:infoLista;
begin
  if (a = nil) then begin
    new(a);
    a^.marca:=au.marca;
    armarNodoLista(au,info);
    a^.pri:=nil;
    agregarAdelante(a^.pri,info);
    a^.HI:=nil;
    a^.HD:=nil;
  end
  else begin
    if (a^.marca = au.marca) then begin
      armarNodoLista(au,info);
      agregarAdelante(a^.pri,info);
    end
    else
      if (a^.marca > au.marca) then
        insertarEnArbolListas(a^.HI,au)
      else
        insertarEnArbolListas(a^.HD,au)
  end;
end;

procedure insertarEnArbolPatentes(var a:arbolPorPatentes; au:auto);
var
  info:infoRegistro;
begin
  if (a = nil) then begin
    new(a);
    armarNodoPat(au,info);
    a^.patente:=au.patente;
    a^.dato:=info;
    a^.HI:=nil;
    a^.HD:=nil;
  end
  else
    if (a^.patente > au.patente) then
      insertarEnArbolPatentes(a^.HI,au)
    else
      insertarEnArbolPatentes(a^.HD,au);
end;

procedure cargarArboles(var aP:arbolPorPatentes; var aL:arbolLista);
var
  au:auto;
begin
  leerAuto(au);
  while (au.marca <> 'mmm') do begin
    insertarEnArbolPatentes(aP,au);
    insertarEnArbolListas(aL,au);
    leerAuto(au);
  end;
end;

function contarMarca(aP:arbolPorPatentes; marca:String):integer; //debe recorrer todo el arbol
begin
  if (aP = nil) then
    contarMarca:=0
  else
    if (aP^.dato.marca = marca) then
      contarMarca:= 1 + contarMarca(aP^.HI,marca) + contarMarca(aP^.HD,marca)
    else
      contarMarca:=contarMarca(aP^.HI,marca) + contarMarca(aP^.HD,marca);
end;

function contarLista(l:lista):integer;
var
  aux:integer;
begin 
  aux:=0;
  while (l<>nil) do begin
    aux:=aux+1;
    l:=l^.sig;
  end;
  contarLista:=aux;
end;

function contarMarcaOrdenado(aL:arbolLista; marca:String):integer;
begin
  if (aL = nil) then
    contarMarcaOrdenado:=0
  else begin
    if (aL^.marca = marca) then
      contarMarcaOrdenado:=contarLista(aL^.pri)
    else 
      if (aL^.marca < marca) then
        contarMarcaOrdenado:=contarMarcaOrdenado(aL^.HD,marca)
      else
        contarMarcaOrdenado:=contarMarcaOrdenado(al^.HI,marca);
  end;
end;

procedure incisoB(aP:arbolPorPatentes);
var
  m:String;
begin
  writeln();
  writeln('INCISO B, CONTAR CANTIDAD DE AUTOS DE UNA MARCA (en un arbol ordenado por patente:');
  writeln();
  write('Igrese un marca:');
  readln(m);
  writeln('La cantidad de autos de esa marca en la agencia es de ',contarMarca(aP,m));
end;

procedure incisoC(aL:arbolLista);
var
  m:String;
begin
  writeln();
  writeln('INCISO C, CONTAR CANTIDAD DE AUTOS DE UNA MARCA (en un arbol ordenado por marca:');
  writeln();
  write('Igrese un marca:');
  readln(m);
  writeln('La cantidad de autos de esa marca en la agencia es de ',contarMarcaOrdenado(aL,m));
end;

procedure inicializarVector(var v:vector);
var
  i:rango;
begin
  for i:=2010 to 2018 do
    v[i]:=nil;
end;

procedure incisoD(aP:arbolPorPatentes; var v:vector);  //recibe un arbol ordenado por patente y retorna un vector de listas que agrupa por año
var
  info:infoVector;
begin
  if (aP<>nil) then begin
    incisoD(aP^.HI,v);
    armarNodoVector(aP,info);
    agregarListaEnVector(v[aP^.dato.anio],info);
    incisoD(aP^.HD,v);
  end;
end;

procedure imprimriLista(l:listaVector);
begin
  while (l<> nil) do begin
    writeln('marca ',l^.dato.marca,' patente ',l^.dato.patente,' modelo ',l^.dato.modelo);
    l:=l^.sig;
  end;
end;

procedure busquedaPatente(aP:arbolPorPatentes;pat:integer; var modelo:String);
begin
  if (aP=nil) then
    modelo:='null'
  else begin
    if (aP^.patente = pat) then
      modelo:=aP^.dato.modelo
    else begin
      if (aP^.patente < pat) then
        busquedaPatente(aP^.HD,pat,modelo)
      else
        busquedaPatente(aP^.HI,pat,modelo);
    end;
  end;   
end;

procedure incisoE(aP:arbolPorPatentes);
var
  p:integer; m:String;
begin
  writeln();
  writeln('INCISO E, BUSCAR UNA PATENTE E IMPRIMIR EL MODELO DE DICHA PATENTE:');
  writeln();
  write('Ingrese un patente a buscar: ');
  readln(p);
  busquedaPatente(aP,p,m);
  writeln(m);
  if (m <>'null') then
    writeln('La patente ',p,' pertenece a un auto modelo ',m)
  else
    writeln('La patente ',p,' no se encuentra en esta agencia');
end;

procedure buscarEnLista(l:lista; pat:integer; var modelo:String; var encontrado:boolean);
begin
  while((l<>nil) and (not encontrado)) do begin
     if (l^.dato.patente = pat) then begin
       encontrado:=true;
       modelo:=l^.dato.modelo;
     end;
     l:=l^.sig;
   end;
end;

procedure buscarEnArbolLista(aL:arbolLista; p:integer;var m:String; var encontrado:boolean);
begin
  if ((aL <> nil) and (not encontrado)) then begin
    buscarEnArbolLista(aL^.HI,p,m,encontrado);
    buscarEnLista(aL^.pri,p,m,encontrado);
    buscarEnArbolLista(aL^.HD,p,m,encontrado);
  end;  
end;

procedure incisoF(aL:arbolLista);
var
  p:integer; m:String; encontrado:boolean;
begin
  writeln();
  writeln('Inciso F:');
  writeln('Ingrese una patente:');
  readln(p);
  encontrado:=false;
  buscarEnArbolLista(aL,p,m,encontrado);
  if (encontrado) then 
    writeln('El modelo de esa patente es ',m)
  else
    writeln('No se encuentra esa patente');
end;


procedure imprimirVectorDeListas(v:vector);
var
  i:integer;
begin
  for i:=2010 to 2018 do begin
    if (v[i] <> nil) then begin
      writeln('anio ',i,' :');
      imprimriLista(v[i]);
    end
    else
      writeln('anio ',i,' vacio');
    end;
end;

var
  aP:arbolPorPatentes; aL:arbolLista; v:vector;
begin
  randomize;
  aP:=nil; aL:=nil;
  cargarArboles(aP,aL);
  incisoB(aP);
  incisoC(aL);
  inicializarVector(v);
  incisoD(aP,v);
//  imprimirVectorDeListas(v);
  incisoE(aP);
  incisoF(aL);
end.
