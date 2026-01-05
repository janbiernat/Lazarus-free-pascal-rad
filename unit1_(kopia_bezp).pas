unit unit1;
//--== Kopia bezpieczeństwa: codzienne ==--
//Copyright (c)by Jan T. Biernat
{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls,
  FileUtil;
  //FileUtil - biblioteka ta umożliwia użycie funkcji CopyFile(p1, p2, false),
  //           która służy do kopiowania pliku z lokalizacji źródłowej
  //           do lokalizacji docelowej.
  //           W parametrze 1 (p1) umieszcza się ścieżkę dostępu wraz
  //                               z nazwą pliku źródłowego.
  //                               Np.: c:\katalog_z\plik1.txt
  //           W parametrze 2 (p2) umieszcza się ścieżkę dostępu wraz
  //                               z nazwą pliku docelowego.
  //                               Ścieżka dostępu określa, gdzie plik
  //                               docelowy ma zostać zapisany.
  //                               Np.: c:\katalog_d\plik2.txt
  //           W parametrze 3 umieszcza się przełącznik FALSE,
  //                          który powoduje nadpisanie wcześniej
  //                          zapisanego pliku w lokalizacji docelowej.

type {TForm1}
  TForm1 = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
    //Prywatne deklaracje
  public
    //Publiczne deklaracje
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure KopiaBezp(Lokalizacja, NazwaPliku, Roz:String);
const dniTyg:array[1..7] of string = ('ni', 'po', 'wt', 'sr', 'cz', 'pi', 'so');
  var FfS, FtT:String;
begin //KopiaBezp: Wykonuje kopię bezpieczeństwa podanego pliku w podanej lokalizacji.
  FfS:= ''; FtT:= '';
  Lokalizacja:= Trim(AnsiLowerCase(Lokalizacja));
  NazwaPliku:= Trim(AnsiLowerCase(NazwaPliku));
  Roz:= Trim(AnsiLowerCase(Roz));
  if((Lokalizacja<>'')
  and (NazwaPliku<>'')
  and (Roz<>'')) then begin
    FfS:= Lokalizacja+NazwaPliku+'.'+Roz;
    FtT:= Lokalizacja+NazwaPliku+'#'+dniTyg[DayOfWeek(Now)]+'.'+Roz;
     CopyFile(FfS, FtT, false);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var Kat:array[1..2]of String;
begin //FormCreate: Ustawienia startowe dla programu.
  Caption:= 'Kopia bezpieczeństwa: codzienne';
  Application.Title:= Caption;
  //=
    Kat[1]:= ''; Kat[1]:= Trim(AnsiLowerCase(Application.ExeName));
    Kat[2]:= ''; Kat[2]:= ExtractFilePath(Kat[1]);
    KopiaBezp(Kat[2], 'dane', 'txt');
    ShowMessage('Kopia pliku DANE.TXT została wykonana!');
    Application.Terminate;
end;

end.

