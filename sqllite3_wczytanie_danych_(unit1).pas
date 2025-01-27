unit Unit1;
(*--== SQLite3 for Lazarus ==--
          Wczytanie danych
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
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    Label1: TLabel;
    SQLite3Connection1: TSQLite3Connection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
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
  Caption:= 'SQLite3 - Wczytanie danych (c)by Jan T. Biernat';
  tSciezka[0]:= ''; tSciezka[0]:= AnsiLowerCase(ExtractFilePath(ParamStr(0)));
  tSciezka[1]:= ''; tSciezka[1]:= tSciezka[0]+'dane.db';
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  if(FileExists(tSciezka[1]) = TRUE) then begin
    try
      SQLite3Connection1.Close;
      SQLite3Connection1.DatabaseName:= tSciezka[1];
      SQLite3Connection1.KeepConnection:= TRUE;
      SQLite3Connection1.Connected:= TRUE;
      SQLQuery1.SQL.Clear;
      SQLQuery1.SQL.Text:= 'SELECT * FROM "sklep" ORDER BY "Artykul" ASC';
      SQLQuery1.Open;
      DataSource1.DataSet:= SQLQuery1;
      DBGrid1.DataSource:= DataSource1;
      DBGrid1.Columns.Items[1].Width:= 200;
      Label1.Caption:= 'Artykułów jest:'+#32+IntToStr(SQLQuery1.RecordCount);
      //DBGrid1.AutoFillColumns:= TRUE;
    finally
    end;
  end;
end;

end.

