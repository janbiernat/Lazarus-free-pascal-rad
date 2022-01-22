(*--== Czasomierz ==-- 
  Copyright (c)by Jan T. Biernat 
 *) 
function ZeroPrzed(Str:String):String; 
begin 
  if(Length(Str) = 1) then ZeroPrzed:= '0'+Str 
  else ZeroPrzed:= Str; 
end; 
 
function Czasomierz(Str:String):String; 
var G, M, S :Shortint; 
begin //Czasomierz - Odmierzaj czas do przodu. 
  Str:= Trim(Str); 
  if(Str <> '') then begin 
    G:= 0; G:= StrToIntDef(Copy(Str, 1, 2), 0); 
    M:= 0; M:= StrToIntDef(Copy(Str, 4, 2), 0); 
    S:= 0; S:= StrToIntDef(Copy(Str, 7, 2), 0); 
    if(S = 59) then begin 
      S:= 0; 
      if(M = 59) then begin 
        M:= 0; 
        if(G = 23) then begin 
          G:= 0; 
        end else G:= G+1; 
      end else M:= M+1; 
    end else S:= S+1; 
    Czasomierz:= ZeroPrzed(IntToStr(G))+':' 
                +ZeroPrzed(IntToStr(M))+':' 
                +ZeroPrzed(IntToStr(S)); 
  end else Czasomierz:= '?'; 
end; 