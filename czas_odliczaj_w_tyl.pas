function ZeroPrzed(Str :String):String;
begin
  if(Length(Str) = 1) then ZeroPrzed:= '0'+Str
  else ZeroPrzed:= Str;
end;
//-
function CzasOdliczaj(Str :String):String;
var G, M, S :Shortint;
begin //CzasOdliczaj - Odliczaj czas w tył.
  Str:= Trim(Str);
  if(Str <> '') then begin
    G:= 0; G:= StrToIntDef(Copy(Str, 1, 2), 0);
    M:= 0; M:= StrToIntDef(Copy(Str, 4, 2), 0);
    S:= 0; S:= StrToIntDef(Copy(Str, 7, 2), 0);
    if(S = 0) then begin
      S:= 59;
      if(M = 0) then begin
        M:= 59;
        if(G = 0) then begin
          G:= 23;
        end else G:= G-1;
      end else M:= M-1;
    end else S:= S-1;
    CzasOdliczaj:= ZeroPrzed(IntToStr(G))+':'+
                   ZeroPrzed(IntToStr(M))+':'+
                   ZeroPrzed(IntToStr(S));
  end else CzasOdliczaj:= '?';
end;