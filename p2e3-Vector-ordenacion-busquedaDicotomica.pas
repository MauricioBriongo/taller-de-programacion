{3.- Implementar un programa que invoque a los siguientes módulos.
a. Un módulo recursivo que retorne un vector de 20 números enteros “random” mayores a 300
y menores a 1550 (incluidos ambos).
b. Un módulo que reciba el vector generado en a) y lo retorne ordenado. (Utilizar lo realizado
en la práctica anterior)
c. Un módulo que realice una búsqueda dicotómica en el vector, utilizando el siguiente
encabezado:
Procedure busquedaDicotomica (v: vector; ini,fin: indice; dato:integer; var pos: indice);
Nota: El parámetro “pos” debe retornar la posición del dato o -1 si el dato no se encuentra
en el vector.

}
program p2e3;

const
  limInf=300;
  limSup=1550;

type
  indice= -1..20;
  
  vector = array [1..20] of integer;
  
procedure generarVector(var v:vector; var dl:integer);
var
  num:integer;
begin
  num:=limInf + (random(limSup - limInf)+1);
  writeln('random: ',num);
  if (dl<20) then begin
    v[dl]:=num;
    dl:=dl+1;
    generarVector(v,dl);
  end;
  v[dl]:=num;
end;

procedure imprimirVector(v:vector;dl:integer);
begin
  if (dl <> 0) then begin
    imprimirVector(v,dl-1); 
    writeln(dl,' - ',v[dl]);
  end;
end;

procedure ordenarVector(var v:vector; dl:integer);
var
  i,j,act:integer;
begin
  for i:= 2 to dl do begin
    act:=v[i];
    j:=i-1;
    while (j > 0) and (v[j]>act) do begin
      v[j+1]:=v[j];
      j:=j-1;
    end;
    v[j+1]:=act;  
  end;
end;

procedure busquedaDicotomica(v:vector; ini,fin:indice;dato:integer; var pos:indice );
var
  medio:indice;  
begin
  if (ini >= fin ) then
    pos:=-1
  else begin
    medio:= (ini + fin) div 2;
    if (dato = v[medio]) then
      pos:=medio
    else begin
      if (dato < v[medio]) then begin
        fin:=medio -1;
        busquedaDicotomica(v,ini,fin,dato,pos);
      end
      else begin
        ini:=medio +1;
        busquedaDicotomica(v,ini,fin,dato,pos)
      end;
    end;
  end;
end;

procedure buscarPosicion(v:vector;dl:integer);
var
  ini,fin,pos:indice;
  dato:integer;
begin
  writeln('-----------INCISO C  ------------');
  ini:=1;
  fin:=dl;
  write('Ingrese un dato a buscar en el vector: ');
  readln(dato);
  busquedaDicotomica(v,ini,fin,dato,pos);
  if (pos = -1) then
    writeln('El numero ',dato,' no se encuentra en el vector')
  else
    writeln('El numero ',dato, ' se encuentra en la posicion ',pos);
end;

var
  v:vector;
  dl:integer;
begin
  Randomize;
  dl:=1;
  generarVector(v,dl);
  imprimirVector(v,dl);
  writeln();
  ordenarVector(v,dl);
  writeln('vector ordenado:');
  imprimirVector(v,dl);
  writeln();
  buscarPosicion(v,dl);
end.
