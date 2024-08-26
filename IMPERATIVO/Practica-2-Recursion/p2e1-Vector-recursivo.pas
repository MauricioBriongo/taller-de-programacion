{1.- Implementar un programa que invoque a los siguientes m�dulos.
a. Un m�dulo recursivo que retorne un vector de a lo sumo 15 n�meros enteros �random� 
mayores a 10 y menores a 155 (incluidos ambos). La carga finaliza con el valor 20.
b. Un m�dulo no recursivo que reciba el vector generado en a) e imprima el contenido del vector.
c. Un m�dulo recursivo que reciba el vector generado en a) e imprima el contenido del vector.
d. Un m�dulo recursivo que reciba el vector generado en a) y devuelva la suma de los valores pares contenidos en el vector.
e. Un m�dulo recursivo que reciba el vector generado en a) y devuelva el m�ximo valor del vector.
f. Un m�dulo recursivo que reciba el vector generado en a) y un valor y devuelva verdadero si dicho valor se encuentra en el vector o falso en caso contrario.
g. Un m�dulo que reciba el vector generado en a) e imprima, para cada n�mero contenido en el vector, sus d�gitos en el orden en que aparecen en el n�mero. 
Debe implementarse un m�dulo recursivo que reciba el n�mero e imprima lo pedido. Ejemplo si se lee el valor 142, se debe imprimir 1  4  2
}

Program Clase2MI;

uses math;

const dimF = 15;
      min = 10;
      max = 155;
type vector = array [1..dimF] of integer;
     

procedure CargarVector (var v: vector; var dimL: integer);

  procedure CargarVectorRecursivo (var v: vector; var dimL: integer);
  var valor: integer;
  begin
    valor:= min + random (max - min + 1);
    if ((valor <> 20 ) and (dimL < dimF)) 
    then begin
          dimL:= dimL + 1;
          v[dimL]:= valor;
          CargarVectorRecursivo (v, dimL);
         end;
  end;
  
begin
  dimL:= 0;
  CargarVectorRecursivo (v, dimL);
end;
 
procedure ImprimirVector (v: vector; dimL: integer);
var
   i: integer;
begin
     for i:= 1 to dimL do
         write ('----');
     writeln;
     write (' ');
     for i:= 1 to dimL do begin
        write(v[i], ' | ');
     end;
     writeln;
     for i:= 1 to dimL do
         write ('----');
     writeln;
     writeln;
End;     

procedure imprimirVectorRecursivo(v:vector;dimL:integer);
begin
  if (dimL <> 0) then begin
    imprimirVectorRecursivo(v,dimL -1);
    write(v[dimL],' | ');
  end;
end;

function esPar(num:integer):boolean;
begin
  esPar:= num MOD 2 = 0;
end;
    
function SumarPares (v: vector; dimL: integer): integer; 

  function SumarRecursivo (v: vector; pos, dimL: integer): integer;

  Begin
    if (pos <= dimL) then
      if (esPar(v[pos])) then 
        SumarRecursivo:= SumarRecursivo (v, pos + 1, dimL) + v[pos]
      else
        SumarRecursivo:= SumarRecursivo (v, pos + 1, dimL)          
    else SumarRecursivo:=0  
  End;
 
var pos: integer; 
begin
 pos:= 1;
 SumarPares:= SumarRecursivo (v, pos, dimL);
end;

function maxi(n1:integer; n2:integer):integer;
begin
  if (n1 >= n2) then
    maxi:=n1
  else
    maxi:=n2;
end;

function  ObtenerMaximo (v: vector; dimL: integer): integer;
begin
  if (dimL = 0) then
    ObtenerMaximo:=-1
  else
    ObtenerMaximo:= maxi(v[dimL],ObtenerMaximo(v,dimL-1));
end;
  
     
function  BuscarValor (v: vector; dimL, valor: integer): boolean;
begin
  if (dimL = 0) then
    buscarValor:=false
  else
    if (v[dimL] = valor) then
      buscarValor:=true
    else
      buscarValor:=buscarValor(v,dimL -1,valor);
end; 

procedure separarDigitos(num:integer);
var
  digito:integer;
begin
  if (num <> 0) then begin
    digito:=num MOD 10;
    separarDigitos(num DIV 10);
    write(digito,' ');
  end;
end;

procedure ImprimirDigitos (v: vector; dimL: integer);
var
  i:integer;
begin     
  for i:= 1 to dimL do begin
    separarDigitos(v[i]);
    writeln();
  end;
end; 

var dimL, suma, maximo, valor: integer; 
    v: vector;
    encontre: boolean;
Begin 
  randomize;
  CargarVector (v, dimL);
  writeln;
  if (dimL = 0) then writeln ('--- Vector sin elementos ---')
                else begin
                       ImprimirVector (v, dimL);
                       ImprimirVectorRecursivo (v, dimL);
                     end; 
  writeln;
  writeln;                   
  suma:= SumarPares(v, dimL);
  writeln;
  writeln;
  writeln('La suma de los valores pares del vector es ', suma); 
  writeln;
  writeln;
  maximo:=0;
  maximo:= ObtenerMaximo(v, dimL);
  writeln;
  writeln;
  writeln('El maximo del vector es ', maximo); 
  writeln;
  writeln;
  
  write ('Ingrese un valor a buscar: ');
  read (valor);
  encontre:= BuscarValor(v, dimL, valor);
  writeln;
  writeln;
  if (encontre) then writeln('El ', valor, ' esta en el vector')
                else writeln('El ', valor, ' no esta en el vector');
                
  writeln;
  writeln;
  ImprimirDigitos (v, dimL);

end.
