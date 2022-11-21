program project1;
{--== TStringList: Pobieranie danych z pliku tekstowego ==--
 Copyright (c)by Jan T. Biernat
 =
 Wykorzystanie ograniczników tekstu do rozdzielenia
 danych znajdujących się w wierszu.
 Wiersze odczytywane są kolejno z pliku tekstowego.
}
uses SysUtils, Classes;
//
//== Funkcje i/lub procedury ==
//
procedure PobierzDaneWiersza(DaneWiersza:String);
var WyrazLicz, I:Integer;
    T           :String;
begin //PobierzDaneWiersza - Rozbija ciąg znaków na elementy za pomocą separatora tekstu.
  DaneWiersza:= Trim(DaneWiersza);
  WyrazLicz:= 0; I:= 0; T:= '';
  if(DaneWiersza<>'') then begin
    for I:= 1 to Length(DaneWiersza)+1 do begin
      if((DaneWiersza[I] = ';') or (DaneWiersza[I] = '#')
      or (Length(DaneWiersza)+1 = I)) then begin
        WyrazLicz:= WyrazLicz+1;
        Writeln(WyrazLicz, ') ', T, '.');
        T:= '';
      end else begin
                 T:= T+DaneWiersza[I];
               end;
    end;
  end;
end;
//
//Blok główny.
//
const PlikDane = 'dane.txt';
var Dane:TStringList;
    I   :Integer;
begin
  Writeln('--== Pobieranie danych z pliku tekstowego ==--');
  Writeln('Copyright (c)by Jan T. Biernat');
  Writeln; Writeln;
  //=
  Dane:= TStringList.Create;
      Dane.Clear;
      if(FileExists(PlikDane) = TRUE) then begin
        Writeln('Odczytalem plik z danymi: "', PlikDane, '".');
        Dane.LoadFromFile(PlikDane);
        Writeln('Wierszy w pliku jest: ', Dane.Count, '.');
        Writeln; Writeln;
        for I:= 0 to Dane.Count-1 do begin
          PobierzDaneWiersza(Dane.Strings[I]);
        end;
      end else begin
                 Writeln('BLAD -?Brak pliku na dysku!');
               end;
  Dane.Destroy;
  //=
    Writeln; Writeln; Writeln('Nacisnij klawisz ENTER...'); Readln;
end.
