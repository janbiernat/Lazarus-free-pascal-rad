unit Unit1;
(*--== SQLite3 for Lazarus ==--
  Utworzenie pliku bazy.
  Odczyt danych do komponentu "StringGrid".
  Wstawienie nowego rekordu do bazy.
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
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    MaskEdit1: TMaskEdit;
    SQLite3Connection1: TSQLite3Connection;
    SQLQuery1: TSQLQuery;
    SQLTransaction1: TSQLTransaction;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: char);
    procedure StringGrid1PrepareCanvas(sender: TObject; aCol, aRow: Integer;
      aState: TGridDrawState);
  private
    tSciezka: array[0..1] of string;
  public
    function StringGridSzukaj(StringGridN:TStringGrid; Kol:Integer; Str:String):String;
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

function TForm1.StringGridSzukaj(StringGridN:TStringGrid; Kol:Integer; Str:String):String;
var I:Integer;
    T:String;
begin //StringGridSzukaj - Wyszukaj dane w wybranej komórce.
  Str:= AnsiLowerCase(Trim(Str));
  with StringGridN do begin
    Col:= Kol; Row:= 1; CellRect(Col, Row);
    if(Str <> '') then begin
      for I:= 0 to RowCount-2 do begin
        T:= ''; T:= AnsiLowerCase(Trim(Cells[Col, 1+I]));
        if(Copy(T, 1, Length(Str)) = Str) then begin
          Row:= 1+I; CellRect(Col, Row); Result:= Cells[Col, Row]; Break;
        end;
      end;
    end else Result:= '';
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin //FormCreate.
  Caption:= 'SQLite3 - Tworzenie bazy (c)by Jan T. Biernat';
  tSciezka[0]:= ''; tSciezka[0]:= AnsiLowerCase(ExtractFilePath(ParamStr(0)));
  tSciezka[1]:= ''; tSciezka[1]:= tSciezka[0]+'dane.db';
  //=
    //Ustawienia startowe.
      Font.Size:= 10;
      Edit1.Text:= '';
       Label2.Caption:= '';
       Button2Click(Sender);
    //StringGrid1:WStępne ustawienia.
      with StringGrid1 do begin
        ColCount:= 5; RowCount:= 2;
        FixedCols:= 0; FixedRows:= 1;
        Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goRangeSelect,goRowSelect,goSmoothScroll];
        Cells[0, 0]:= #32+'LP'; ColWidths[0]:= 53;
        Cells[1, 0]:= #32+'ID2'; ColWidths[1]:= 193;
        Cells[2, 0]:= #32+'Artykuł'; ColWidths[2]:= 153;
        Cells[3, 0]:= #32+'Data waż.'; ColWidths[3]:= 99;
        Cells[4, 0]:= #32+'Cena (zł)'; ColWidths[4]:= 153;
      end;
    //Utworzenie bazy "dane.db".
      if(FileExists(tSciezka[1]) = FALSE) then begin
        SQLite3Connection1.Close;
        SQLite3Connection1.KeepConnection:= TRUE;
        SQLite3Connection1.DatabaseName:= tSciezka[1];
        try
          SQLite3Connection1.Open;
          SQLTransaction1.Active:= TRUE;
          SQLite3Connection1.ExecuteDirect('CREATE TABLE "sklep" ('
                                                      +' "ID" Integer NOT NULL PRIMARY KEY AUTOINCREMENT,'
                                                      +' "id2" Char(16) NOT NULL,'
                                                      +' "artykul" Char(90) NOT NULL,'
                                                      +' "datawaz" Char(4) NOT NULL,'
                                                      +' "cena" Float NOT NULL);');
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

procedure TForm1.Edit1Change(Sender: TObject);
begin
  StringGridSzukaj(StringGrid1, 2, Edit1.Text);
end;

procedure TForm1.Edit1KeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
  );
begin
  if((Key = VK_DOWN)
  or (Key = VK_UP)) then StringGrid1.SetFocus;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  //Wstaw nowy rekord: Wyczyść pole edycyjne.
  Edit2.Text:= '';
  MaskEdit1.Text:= '';
  Edit3.Text:= '';
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
      SQLQuery1.SQL.Text:= 'INSERT INTO "sklep" (id2, artykul, datawaz, cena)'
                          +' VALUES(:id2, :artykul, :datawaz, :cena)';
      SQLQuery1.Params.ParamByName('id2').AsString:= DataCzasID;
      SQLQuery1.Params.ParamByName('artykul').AsString:= Trim(Edit2.Text);
      SQLQuery1.Params.ParamByName('datawaz').AsString:= Trim(MaskEdit1.Text);
      SQLQuery1.Params.ParamByName('cena').AsCurrency:= StrToFloatDef(Trim(Edit3.Text), 0);
      SQLQuery1.ExecSQL;
      SQLTransaction1.Commit;
    finally
    end;
    Button2Click(Sender);
    Edit2.SetFocus;
    FormShow(Sender);
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
var Licznik:Integer;
begin
    //Wczytanie danych do komponentu "StringGrid1".
      if(FileExists(tSciezka[1]) = TRUE) then begin
        try
          DataSource1.DataSet:= SQLQuery1;
          SQLite3Connection1.Close;
          SQLite3Connection1.DatabaseName:= tSciezka[1];
          SQLite3Connection1.KeepConnection:= TRUE;
          SQLite3Connection1.Connected:= TRUE;
          SQLQuery1.SQL.Clear;
          SQLQuery1.SQL.Text:= 'SELECT * FROM "sklep" ORDER BY "artykul" ASC';
          SQLQuery1.Open;
          Licznik:= 0;
          SQLQuery1.First;
          while not (SQLQuery1.EOF) do begin
            Licznik:= Licznik+1;
            with StringGrid1 do begin
              Cells[0, Licznik]:= #32+Trim(IntToStr(Licznik))+#32;
              Cells[1, Licznik]:= #32+Trim(SQLQuery1.FieldByName('id2').AsString)+#32;
              Cells[2, Licznik]:= #32+Trim(SQLQuery1.FieldByName('artykul').AsString)+#32;
              Cells[3, Licznik]:= #32+Trim(SQLQuery1.FieldByName('datawaz').AsString)+#32;
              Cells[4, Licznik]:= #32+Trim(SQLQuery1.FieldByName('cena').AsString)+#32;
              //Czy ostatni wiersz jest zajęty?
                if((Trim(Cells[0, RowCount-1])<>'')
                and (Trim(Cells[1, RowCount-1])<>'')) then RowCount:= RowCount+1;
            end;
            SQLQuery1.Next;
          end;
        finally
        end;
        Label2.Caption:= 'Rekordów jest: '+IntToStr(SQLQuery1.RecordCount);
      end;
end;

procedure TForm1.StringGrid1KeyPress(Sender: TObject; var Key: char);
begin
  Edit1.SetFocus;
end;

procedure TForm1.StringGrid1PrepareCanvas(sender: TObject; aCol, aRow: Integer;
  aState: TGridDrawState);
var TS :TTextStyle;
begin
  //Wyśrodkowanie tekstu w wierszu 1 (tj. w wierszu nagłówkowym).
    if(aRow = 0) then begin
      TS:= TStringGrid(Sender).Canvas.TextStyle;
      TS.Alignment:= taCenter;
      TStringGrid(Sender).Canvas.TextStyle:= TS;
      with StringGrid1.Canvas.Font do begin
        Color:= clBlack; Style:= [fsBold];
      end;
    end;
  //KKolumny zawierające dane liczbowe przesuń do prawej krawędzi.
    if(((aRow > 0) and (aCol = 0))
    or ((aRow > 0) and (aCol = 3))
    or ((aRow > 0) and (aCol = 4))) then begin
      TS:= TStringGrid(Sender).Canvas.TextStyle;
      TS.Alignment := taRightJustify;
      TStringGrid(Sender).Canvas.TextStyle:= TS;
    end;
end;

end.
