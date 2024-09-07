{El administrador de un edificio de oficinas tiene la información del pago de las expensas
de dichas oficinas. Implementar un programa con:
a) Un módulo que retorne un vector, sin orden, con a lo sumo las 300 oficinas que
administra. Se deben cargar, para cada oficina, el código de identificación, DNI del
propietario y valor de la expensa. La lectura finaliza cuando llega el código de
identificación 0.
b) Un módulo que reciba el vector retornado en a) y retorne dicho vector ordenado por
código de identificación de la oficina. Ordenar el vector aplicando uno de los métodos
vistos en la cursada.
c) Un módulo que realice una búsqueda dicotómica. Este módulo debe recibir el vector
generado en b) y un código de identificación de oficina. En el caso de encontrarlo, debe
retornar la posición del vector donde se encuentra y en caso contrario debe retornar 0.
Luego el programa debe informar el DNI del propietario o un cartel indicando que no
se encontró la oficina.
d) Un módulo recursivo que retorne el monto total de las expensas.}
program p5e1;

const
  dimF=300;

type

  oficina = record
    codigo:integer;
    dni:integer;
    expensas:integer;
  end;
  
  vector = array [1..dimF] of oficina;
  
  
procedure crearOficina(var o:oficina);
begin
  o.codigo:=random(100);
  if (o.codigo <> 0) then
  begin
    o.dni:=random(1000)+1000;
    o.expensas:=random(51)*100;
  end;
end;

procedure cargarOficinas(var v:vector; var dl:integer);
var
  o:oficina;
begin
  dl:=0;
  crearOficina(o);
  while (o.codigo <> 0) and (dl<dimF) do begin
    dl:=dl+1;
    v[dl]:=o;
    crearOficina(o);
  end;
end;
  
procedure ordenarVector(var v:vector; dl:integer);
var
i,j:integer; actual:oficina;
begin
  for  i:=2 to dl do begin
    j:=i-1;
    actual:=v[i];
    while (j>0) and (v[j].codigo > actual.codigo) do begin
      v[j+1]:=v[j];
      j:=j-1;
    end;
    v[j+1]:=actual;
  end;
end;
  
procedure imprimirVector(v:vector;dl:integer);
var 
  i:integer;
begin
  for i:=1 to dl do
    writeln(i,'-',' dni ',v[i].dni,' codigo ',v[i].codigo,' expensas ',v[i].expensas);
end;
  
procedure busquedaDicotomica(v:vector; ini,fin,cod:integer; var pos:integer);
var
  medio:integer;
begin
  if (ini >=fin) then
    pos:=0
  else begin
    medio:=(ini + fin) div 2;
    writeln(medio);
    if (v[medio].codigo = cod) then
      pos:=medio
    else begin
      if (v[medio].codigo < cod) then begin
        ini:=medio+1;
        busquedaDicotomica(v,ini,fin,cod,pos);
      end
      else begin
        fin:=medio-1;
        busquedaDicotomica(v,ini,fin,cod,pos);
      end;
    end;
  end;
end; 

procedure incisoC(v:vector;dl:integer);
var
  ini,fin,cod,pos:integer;
begin
  ini:=1;
  fin:=dl;
  writeln();
  writeln('---- INCISO C ---- ');
  write('INGRESE UN CODIGO PARA BUSCAR SU POSICION EN EL VECTOR:');
  readln(cod);
  busquedaDicotomica(v,ini,fin,cod,pos);
  if (pos <> 0) then
    writeln('El codigo ',cod,' esta en la posicion ',pos)
  else
    writeln('El codigo ',cod,' no esta en el vector');
end;

function montoTotal(v:vector; dl:integer):integer;
begin
  if (dl=0) then
    montoTotal:=0
  else begin
    montoTotal:= v[dl].expensas + montoTotal(v,dl-1);
  end;
end;

procedure totalExpensas(v:vector; dl:integer);
begin
  writeln();
  writeln('El monto total de todas las expensa es',montoTotal(v,dl));
end;

var
  v:vector;
  dl:integer;
begin
  randomize;
  cargarOficinas(v,dl);
  writeln();
  writeln('Vector de oficinas desordenado');
  imprimirVector(v,dl);
  writeln('dimlog=',dl);
  ordenarVector(v,dl);
  writeln();
  writeln('Vector de oficinas ordenado por codigo:');
  imprimirVector(v,dl);
  incisoC(v,dl);
  totalExpensas(v,dl);
end.
