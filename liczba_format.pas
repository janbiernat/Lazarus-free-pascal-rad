{--== Formatowanie liczby ==-- 
  Copyright (c)by Jan T. Biernat} 
function LiczbaFormat(Str:String):String; 
var I        :Integer; 
    Licznik :Shortint; 
    Znaki   :String; 
begin 
  {LiczbaFormat - Formatuje liczbę 12345 na 12 345.} 
  Licznik:= 0; I:= 0; Znaki:= ''; 
  for I:= Length(Str) downto 1 do begin 
    Znaki:= Str[I]+Znaki; 
    Licznik:= Licznik+1; 
    if(Licznik > 2) then begin 
      Licznik:= 0; Znaki:= #32+Znaki; 
    end; 
  end; 
  {Usuń 1 pusty znak (tzw. spacje).} 
  if(Znaki[1] = #32) then LiczbaFormat:= Copy(Znaki, 2, Length(Znaki)) 
  else LiczbaFormat:= Znaki; 
end; {LiczbaFormat} 