{--== Każdy wyraz pisz Wielką Literą ==--
 Copyright (c)by Jan T. Biernat
}
function WyrazWielkaLitera(T:String):String;
var I:Integer;
    S:String;
begin
  T:= AnsiLowerCase(Trim(T));
  S:= '';
  if(T <> '') then begin
    for I:= 1 to Length(T) do begin
      if(((T[I-1] = ' ') and (T[I] <> ' '))
      or ((T[I-1] = '-') and (T[I] <> ' '))) then begin
        S:= S+AnsiUpperCase(T[I]);
      end else S:= S+T[I];
    end;
    Result:= AnsiUpperCase(T[1])+Copy(S, 2, Length(S));
  end else Result:= S;
end;