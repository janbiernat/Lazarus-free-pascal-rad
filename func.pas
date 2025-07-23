(*--== [func.pas] Biblioteka Funkcji/Procedur ==--
 Copyright (c)by Jan T. Biernat
 =
 Opis: Bibliotekę w formie pliku z kodem źródłowym (który teraz czytasz/widzisz)
       można podłączyć do kodu źródłowego pisanego programu
       za pomocą dyrektywy $I umieszczonej pomiędzy nawiasami
       klamrowymi.
       Przykład 1: {$I nazwa_pliku.pas}
                   Konstrukcja tej dyrektywy musi być umieszczona poniżej wiersza,
                   w którym znajduje się instrukcja USES.
                   Przykład 1a: uses unit1, unit2;
                                {$I func.pas}
*)
//
//Stałe globalne.
const SG_NazwyMiesiecyP:array[1..12] of string = ('stycznia', 'lutego', 'marca'
                                                , 'kwietnia', 'maja', 'czerwca'
                                                , 'lipca', 'sierpnia', 'września'
                                                , 'października', 'listopada', 'grudnia');
      SG_dniTygodnia:array[1..7] of string = ('niedziela', 'poniedziałek', 'wtorek'
                                            , 'środa', 'czwartek', 'piątek', 'sobota');
//
//Funkcje i procedury.
function NrPESELnaDateUrRMD(Str:String):String;
var _DateUr, R, D:String;
begin //NrPESELnaDateUrRMD: Zamienia nr PESEL na datę urodzenia (np. 70072113423 -> 1970-07-21).
  _DateUr:= ''; R:= ''; D:= '';
  Str:= Trim(Str);
  if(Length(Str) = 11) then begin
    R:= Copy(Str, 1, 2); D:= Copy(Str, 5, 2);
    if(Str[3] = '3') then begin
      //Urodzeni w roku 2000 i później oraz w miesiącach od nr 10 do 12 włącznie.
        _DateUr:= '20'+R+'-1'+Str[4]+'-'+D;
    end else if(Str[3] = '2') then begin
               //Urodzeni w roku 2000 i później.
                 _DateUr:= '20'+R+'-0'+Str[4]+'-'+D;
             end else begin
                        //Urodzeni przed rokiem 2000.
                          _DateUr:= '19'+R+'-'+Copy(Str, 3, 2)+'-'+D;
                      end;
  end;
  Result:= _DateUr;
end;

function DataDMRnaRMD(Str:String):String;
var D, M, R:String;
begin //DataDMRnaRMD: Zamienia datę 24-12-2024 na 2024-12-24.
  D:= ''; M:= ''; R:= '';
  Str:= Trim(Str);
  if((Length(Str) = 10) and (Str <> '')) then begin
    D:= Copy(Str, 1, 2);
    M:= Copy(Str, 4, 2);
    R:= Copy(Str, 7, 4);
    Result:= R+'-'+M+'-'+D;
  end else Result:= '';
end;

function DataDMRk(Str:String):String;
var D, M, R:String;
begin //DataDMRk: Zamienia datę 24-12-2024 na 24.12.2024.
  D:= ''; M:= ''; R:= '';
  Str:= Trim(Str);
  if((Length(Str) = 10) and (Str <> '')) then begin
    D:= Copy(Str, 1, 2);
    M:= Copy(Str, 4, 2);
    R:= Copy(Str, 7, 4);
    Result:= D+'.'+M+'.'+R;
  end else Result:= '';
end;

function DataRMDnaDMR(Str:String):String;
var D, M, R:String;
begin //DataRMDnaDMR: Zamienia datę 2024-12-24 na 24-12-2024.
  D:= ''; M:= ''; R:= '';
  Str:= Trim(Str);
  if((Length(Str) = 10) and (Str <> '')) then begin
    R:= Copy(Str, 1, 4);
    M:= Copy(Str, 6, 2);
    D:= Copy(Str, 9, 2);
    Result:= D+'-'+M+'-'+R;
  end else Result:= '';
end;

function ZeroPrzed(L:Integer):String;
begin
  if(Length(IntToStr(L)) = 1) then ZeroPrzed:= '0'+IntToStr(L)
  else ZeroPrzed:= IntToStr(L);
end;

function DataTeraz:String;
var R, M, D:Word;
begin //DataTeraz: Zwraca datę systemową.
  R:= 0; M:= 0; D:= 0;
  DecodeDate(Now, R, M, D);
  DataTeraz:= IntToStr(R)+'-'+ZeroPrzed(M)+'-'+ZeroPrzed(D);
end;

function DataCzasID:String;
var R, M, D, G, Min, Sek, MiSek:Word;
begin //DataCzasID: Zwraca datę i czas w formacie RRRRMMDDGGMMSSS.
  R:= 0; M:= 0; D:= 0;
  G:= 0; Min:= 0; Sek:= 0; MiSek:= 0;
  DecodeDate(Now, R, M, D);
  DecodeTime(Now, G, Min, Sek, MiSek);
  DataCzasID:= IntToStr(R)+ZeroPrzed(M)+ZeroPrzed(D)
              +ZeroPrzed(G)+ZeroPrzed(Min)+ZeroPrzed(Sek)
              +IntToStr(MiSek);
end;

function DATA_IloscDniWMiesiacu(DataRM:String):Shortint;
var Miesiac, IleJestDni:Shortint;
    Rok                :Integer;
begin //DATA_IloscDniWMiesiacu: Funkcja zwraca liczbę dni w danym miesiącu.
  Miesiac:= 0; IleJestDni:= 0; Rok:= 0;
  DataRM:= Trim(DataRM);
  if(DataRM <> '') then begin
    Rok:= StrToIntDef(Copy(DataRM, 1, 4), 0);
    Miesiac:= 0; Miesiac:= StrToIntDef(Copy(DataRM, 6, 2), 0);
    IleJestDni:= 0;
    if(Miesiac in [1, 3, 5, 7, 8, 10, 12]) then IleJestDni:= 31;
    if(Miesiac in [4, 6, 9, 11]) then IleJestDni:= 30;
    if(Miesiac = 2) then begin
      IleJestDni:= 28;
      if((Rok mod 4 = 0) and (Rok mod 100 <>0))
      or (Rok mod 400 = 0) then begin
        IleJestDni:= 0; IleJestDni:= 29;
      end;
    end;
  end;
  Result:= IleJestDni;
end;

function DATA_JutroJest(DataRMD:String):String;
var Miesiac, Dzien, NrDnia:Shortint;
                       Rok:Integer;
begin //DATA_JutroJest: Funkcja zwraca datę jutrzejszą.
  Miesiac:= 0; Dzien:= 0; NrDnia:= 0; Rok:= 0;
  Rok:= StrToInt(Copy(DataRMD, 1, 4));
  Miesiac:= StrToInt(Copy(DataRMD, 6, 2));
  Dzien:= StrToInt(Copy(DataRMD, 9, 2));
  NrDnia:= DATA_IloscDniWMiesiacu(DataRMD);
  DATA_JutroJest:= Copy(DataRMD, 1, 4)+'-'
                  +ZeroPrzed(Miesiac)
                  +'-'+ZeroPrzed(Dzien+1);
  if(Dzien+1 > NrDnia) then begin
    DATA_JutroJest:= Copy(DataRMD, 1, 4)+'-'
                    +ZeroPrzed(Miesiac+1)+'-01';
    if(Miesiac = 12) then DATA_JutroJest:= IntToStr(Rok+1)+'-01-01';
  end;
end;

function DATA_KiedysBedzie(DataRMD:String; DodajDzien:Integer):String;
var Str:String;
      I:Integer;
begin //DATA_KiedysBedzie: Funkcja zwraca datę dnia za X dni.
  I:= 0; Str:= '';
  if(DodajDzien > 0) then begin
    for I:= 0 to DodajDzien-1 do begin
      Str:= ''; Str:= DATA_JutroJest(DataRMD);
      DataRMD:= ''; DataRMD:= Str;
    end;
    DATA_KiedysBedzie:= Str;
  end else DATA_KiedysBedzie:= DataRMD;
end;

function DATA_WczorajBylo(DataRMD:String):String;
var _Wynik                :String;
    Miesiac, Dzien, NrDnia:Shortint;
    Rok                   :Integer;
begin //DATA_WczorajBylo: Funkcja zwraca datę wczorajszą.
  _Wynik:= '';
  Miesiac:= 0; Dzien:= 0; NrDnia:= 0; Rok:= 0;
  DataRMD:= Trim(DataRMD);
  if(DataRMD <> '') then begin
    Rok:= StrToIntDef(Copy(DataRMD, 1, 4), 0);
    Miesiac:= StrToIntDef(Copy(DataRMD, 6, 2), 0);
    Dzien:= StrToIntDef(Copy(DataRMD, 9, 2), 0);
    NrDnia:= DATA_IloscDniWMiesiacu(Copy(DataRMD, 1, 5)
                                   +ZeroPrzed(Miesiac-1));
    _Wynik:= Copy(DataRMD, 1, 4)+'-'+ZeroPrzed(Miesiac)+'-'+ZeroPrzed(Dzien-1);
    if(Dzien = 1) then begin
      _Wynik:= '';
      _Wynik:= Copy(DataRMD, 1, 4)+'-'+ZeroPrzed(Miesiac-1)+'-'+ZeroPrzed(NrDnia);
      if(Miesiac = 1) then begin
        _Wynik:= ''; _Wynik:= IntToStr(Rok-1)+'-12-31';
      end;
    end;
  end;
  Result:= _Wynik;
end;

function DATA_KiedysBylo(DateRMD:String; OdejmijDzien:Integer):String;
var Str:String;
      I:Integer;
begin //DATA_KiedysBylo: Funkcja zwraca datę dnia z przed X dni.
  Str:= ''; I:= 0;
  if(OdejmijDzien > 0) then begin
    for I:= 0 to OdejmijDzien-1 do begin
      Str:= ''; Str:= DATA_WczorajBylo(DateRMD);
      DateRMD:= ''; DateRMD:= Str;
    end;
    DATA_KiedysBylo:= Str;
  end else DATA_KiedysBylo:= DateRMD;
end;

function WyrazWielkaLitera(T:String):String;
var I:Integer;
    S:String;
begin //WyrazWielkaLitera: turbo pascal -> Turbo Pascal.
  I:= 0; S:= '';
  T:= AnsiLowerCase(Trim(T));
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

function DataSpr(Str:String):String;
var R         :Integer;
    M, D, Dni :Shortint;
    T, MM, DD :String;
begin
  //DataSpr: Funkcja sprawdza poprawność daty w formacie RRRR-MM-DD.
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

function CzasSpr(Str:String):String;
var _W, _Str:String;
    G, M    :Shortint;
begin //CzasSpr: Sprawdza poprawność wpisanej godziny w formacie GG:MM.
  _W:= ''; _Str:= '';
  Str:= Trim(Str);
  if(Str <> '') then begin
    _Str:= Copy(Str, 1, 5);
    if(Length(_Str) = 5) then begin
      G:= 0; G:= StrToIntDef(Copy(_Str, 1, 2), 0);
      M:= 0; M:= StrToIntDef(Copy(_Str, 4, 2), 0);
      if((G > -1) and (G < 24)) then begin
        if((M > -1) and (M < 60)) then begin
          _W:= _Str;
        end;
      end;
    end;
  end;
  Result:= _W;
end;

function ZnakWypelnij(Znak:String; Ile:Integer):String;
var R:String;
    I:Integer;
begin
  R:= ''; I:= 0;
  Znak:= Trim(Znak);
  if((Znak <> '') and (Ile > 0)) then begin
    for I:= 0 to (Ile-1) do R:= R+Znak[1];
  end;
  ZnakWypelnij:= R;
end;
//--== Koniec ==--
