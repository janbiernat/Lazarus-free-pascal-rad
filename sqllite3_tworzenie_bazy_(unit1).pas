unit Unit1;
(*--== SQLite3 for Lazarus ==--
            Tworzenie bazy
  Copyright (c)by Jan T. Biernat
=
UWAGA: Przed uruchomieniem programu
       należy sprawdzić, czy w aktualnym
       folderze/katalogu jest plik "sqlite3.dll".
*)
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, sqlite3conn, sqldb, db, Forms, Controls, Graphics, Dialogs,
  StdCtrls, DBGrids, ComCtrls, Grids, MaskEdit, ExtCtrls, LCLType, DBCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    SQLite3Connection1: TSQLite3Connection;
    SQLTransaction1: TSQLTransaction;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    tSciezka: array[0..1] of string;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin //FormCreate.
  Caption:= 'SQLite3 - Tworzenie bazy (c)by Jan T. Biernat';
  tSciezka[0]:= ''; tSciezka[0]:= AnsiLowerCase(ExtractFilePath(ParamStr(0)));
  tSciezka[1]:= ''; tSciezka[1]:= tSciezka[0]+'dane.db';
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  //Tworzenie bazy.
  if(FileExists(tSciezka[1]) = FALSE) then begin
    //Jeżeli baza nie istnieje, to wykonaj poniższe instrukcje (tj. utwórz bazę).
      SQLite3Connection1.Close;
      SQLite3Connection1.KeepConnection:= TRUE;
      SQLite3Connection1.DatabaseName:= tSciezka[1];
      try
        SQLite3Connection1.Open;
        SQLTransaction1.Active:= TRUE;
        SQLite3Connection1.ExecuteDirect('CREATE TABLE "sklep" ('
                                                    +' "ID" Integer NOT NULL PRIMARY KEY AUTOINCREMENT,'
                                                    +' "ID2" Char(16) NOT NULL,'
                                                    +' "Artykul" Char(90) NOT NULL,'
                                                    +' "DataWaz" Char(4) NOT NULL,'
                                                    +' "Cena" Float NOT NULL);');
        SQLTransaction1.Commit;
      finally
      end;
  end;
(*
Legenda:
1. SQLTransaction1:
   1.1. Database = SQLite3Connection1.

2. SQLite3Connection1:
   2.1. DatabaseName = "dane.db".
   2.2. KeepConnection = TRUE.
   2.3. Translation = SQLTransaction1
 *)
end;

end.
