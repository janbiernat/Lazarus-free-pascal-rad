unit Unit1;
(*--== SQLite3 for Lazarus ==-
         Wstaw nowy rekord
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
    Button2: TButton;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    MaskEdit1: TMaskEdit;
    SQLite3Connection1: TSQLite3Connection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
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

function ZeroPrzed(L :Word):String;
begin
  if(Length(IntToStr(L)) = 1) then ZeroPrzed:= '0'+IntToStr(L)
  else ZeroPrzed:= IntToStr(L);
end;

function DataCzasID:String;
var R, M, D, G, Min, Sek, MiSek :Word;
begin
  R:= 0; M:= 0; D:= 0;
  G:= 0; Min:= 0; Sek:= 0; MiSek:= 0;
  DecodeDate(Now, R, M, D);
  DecodeTime(Now, G, Min, Sek, MiSek);
  DataCzasID:= IntToStr(R)+ZeroPrzed(M)+ZeroPrzed(D)
              +ZeroPrzed(G)+ZeroPrzed(Min)+ZeroPrzed(Sek)
              +IntToStr(MiSek);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin //FormCreate.
  Caption:= 'SQLite3 - Wstaw nowy rekord (c)by Jan T. Biernat';
  tSciezka[0]:= ''; tSciezka[0]:= AnsiLowerCase(ExtractFilePath(ParamStr(0)));
  tSciezka[1]:= ''; tSciezka[1]:= tSciezka[0]+'dane.db';
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  //Wyszukaj wg artykułu.
    if(FileExists(tSciezka[1]) = TRUE) then begin
    try
      SQLite3Connection1.Close;
      SQLite3Connection1.DatabaseName:= tSciezka[1];
      SQLite3Connection1.KeepConnection:= TRUE;
      SQLite3Connection1.Connected:= TRUE;
      SQLQuery1.SQL.Clear;
      SQLQuery1.SQL.Text:= 'SELECT * FROM "sklep" WHERE LOWER("Artykul") LIKE LOWER("'+Trim(Edit1.Text)+'%") ORDER BY "Artykul" ASC';
      SQLQuery1.Open;
      DataSource1.DataSet:= SQLQuery1;
      DBGrid1.DataSource:= DataSource1;
      DBGrid1.Columns.Items[1].Width:= 200;
      Label2.Caption:= 'Artykułów jest:'+#32+IntToStr(SQLQuery1.RecordCount);
      //DBGrid1.AutoFillColumns:= TRUE;
    finally
    end;
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  //Wstaw nowy rekord.
    if((Trim(Edit2.Text) <> '') and (Trim(MaskEdit1.Text) <> '')
  and (Trim(Edit3.Text) <> '') and (FileExists(tSciezka[1]) = TRUE)) then begin
    try
      SQLite3Connection1.Close;
      SQLite3Connection1.DatabaseName:= tSciezka[1];
      SQLite3Connection1.Open;
      SQLTransaction1.Active:= TRUE;
      SQLQuery1.Clear;
      SQLQuery1.SQL.Text:= 'INSERT INTO "sklep" (ID2, Artykul, DataWaz, Cena)'
                          +' VALUES(:ID2, :Artykul, :DataWaz, :Cena)';
      SQLQuery1.Params.ParamByName('ID2').AsString:= DataCzasID;
      SQLQuery1.Params.ParamByName('Artykul').AsString:= Trim(Edit2.Text);
      SQLQuery1.Params.ParamByName('DataWaz').AsString:= Trim(MaskEdit1.Text);
      SQLQuery1.Params.ParamByName('Cena').AsCurrency:= StrToFloatDef(Trim(Edit3.Text), 0);
      SQLQuery1.ExecSQL;
      SQLTransaction1.Commit;
    finally
    end;
    FormShow(Sender);
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  //Usuń wybrany rekord.
    if(DBGrid1.Columns.Items[0].Field.AsInteger > 0) then begin
      DBNavigator1.BtnClick(nbDelete);
      Button2.Enabled:= TRUE;
    end else Button2.Enabled:= FALSE;
(*
 1. SQLQuery1:
    1.1. sqoAutoApplyUpdates = true.
    1.2. sqoAutoCommit = true.
    1.3. sqoKeepOpenOnCommit = true.
 *)
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Edit1.Text:= '';
  Edit2.Text:= '';
  Edit3.Text:= '';
  MaskEdit1.Text:= '';
  with DBNavigator1 do begin
    DataSource:= DataSource1;
    Top:= -999; Left:= -999;
    Visible:= FALSE;
    VisibleButtons:= [nbDelete,nbEdit,nbPost,nbRefresh];
  end;
  //Wczytanie danych do bazy.
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
      Label2.Caption:= 'Artykułów jest:'+#32+IntToStr(SQLQuery1.RecordCount);
      //DBGrid1.AutoFillColumns:= TRUE;
    finally
    end;
  end;
end;

end.

