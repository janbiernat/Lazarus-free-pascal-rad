function DataSpr(Str:String):String; 
var R         :Integer; 
    M, D, Dni :Shortint; 
    T, MM, DD :String; 
begin 
  //DataSpr - Funkcja sprawdza poprawność daty w formacie RRRR-MM-DD. 
  //Copyright (c)by Jan T. Biernat 
  // 
  R:= 0; M:= 0; D:= 0; Dni:= 0; T:= ''; MM:= ''; DD:= ''; 
  Str:= Trim(Copy(Str, 1, 10)); 
  if(Str<>'') then begin 
    R:= StrToIntDef(Copy(Str, 1, 4), 0); 
    M:= StrToIntDef(Copy(Str, 6, 2), 0); 
    D:= StrToIntDef(Copy(Str, 9, 2), 0); 
    if(R > 1947) then begin 
      if((M > 0) and (M < 13)) then begin 
        if(M in [1, 3, 5, 7, 8, 10, 12]) then Dni:= 31 
        else if(M in [4, 6, 9, 11]) then Dni:= 30 
             else if(M = 2) then begin 
                    if(((R mod 4 = 0) and (R mod 100 <> 0)) or (R mod 400 = 0)) then Dni:= 29 
                    else Dni:= 28; 
                  end; 
        if((D > 0) and (D < Dni+1)) then begin 
          MM:= IntToStr(M); DD:= IntToStr(D); 
          if(Length(MM) = 1) then MM:= '0'+MM; 
          if(Length(DD) = 1) then DD:= '0'+DD; 
          T:= IntToStr(R)+'-'+MM+'-'+DD; 
        end; 
      end; 
    end; 
  end; 
  DataSpr:= T; 
end; 