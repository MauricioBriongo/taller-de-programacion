program aBinario;


procedure decimalABinario(num:integer);
begin
  if (num <>  0) then begin        
    decimalABinario(num div 2);
    write(num mod 2); //despues del llamado para que imprima de izquierda a derecha
  end;
end;


var
  num:integer;
begin
  writeln('Ingrese un numero para pasarlo a binario: ');
  readln(num);
  write('El numero ',num,' en binario es: ');
  decimalABinario(num);
end.
