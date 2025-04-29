unit unit1;
(*--== Kolorowanie wybranych wierszy w komponencie StringGrid ==--
  Copyright (c)by Jan T. Biernat*)
{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls, Types;

type {TForm1}
  TForm1 = class(TForm)
    StringGrid1: TStringGrid;
    procedure StringGridDaneDodaj(StrGridN:TStringGrid; Nr:Integer;
                                  T, O1, O2:String; Tak:Boolean);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1PrepareCanvas(Sender: TObject; aCol, aRow: Integer;
      aState: TGridDrawState);
  private
    //Deklaracja zmiennych prywatnych.
  public
    //Deklaracja zmiennych publicznych.
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.StringGridDaneDodaj(StrGridN:TStringGrid; Nr:Integer;
                                     T, O1, O2:String; Tak:Boolean);
var Wiersz, I:Integer;
begin //StringGridDaneDodaj - Dodaj nowe dane do listy.
  Wiersz:= 0;
  T:= Trim(T);
  O1:= Trim(O1);
  O2:= Trim(O2);
  with StrGridN do begin
    //Znajdź pusty wiersz na podstawie danych z kolumny nr 2.
      for I:= 0 to RowCount-1 do begin
        if(Trim(Cells[2, I]) = '') then begin
          Wiersz:= I; Break;
        end;
      end;
    //Wprowadź nowe dane na końcu listy.
      RowCount:= RowCount+4;
      Cells[0, Wiersz]:= IntToStr(Nr)+'.';
      Cells[1, Wiersz]:= T;
      Cells[1, Wiersz+1]:= O1;
      Cells[1, Wiersz+2]:= O2;
      if(Tak = true) then Cells[2, Wiersz]:= 't'
      else Cells[2, Wiersz]:= 'n';
      Cells[2, Wiersz+1]:= Cells[2, Wiersz];
      Cells[2, Wiersz+2]:= Cells[2, Wiersz];
      Cells[2, Wiersz+3]:= '-';
    //Dodaj pusty ostatni wiersz.
      if(Trim(Cells[2, Wiersz+3]) <> '') then RowCount:= RowCount+1;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var Wiersz:Integer;
begin //FormCreate.
  Caption:= 'Kolorowanie wybranych wierszy w komponencie StringGrid';
  //=
    with StringGrid1 do begin
      FixedCols:= 0; FixedRows:= 0;
      ColCount:= 3; RowCount:= 1;
      Options:= [];
      ColWidths[0]:= 25;
      ColWidths[1]:= 450;
      ColWidths[2]:= 0;
      //Dane
        StringGridDaneDodaj(StringGrid1, 1, 'ZX Spectrum',
                            '48 KB, dane nagrywane były na taśmę magnetofonową.',
                            'Komputer domowy służący głównie do grania.', true);
        StringGridDaneDodaj(StringGrid1, 2, 'Atari 65XE/130XE',
                            '64 KB/128KB, dane nagrywane były na taśmę magnetofonową.',
                            'Komputer domowy służący głównie do grania.', false);
        StringGridDaneDodaj(StringGrid1, 3, 'Commodore C64',
                            '64 KB, dane nagrywane były na taśmę magnetofonową.',
                            'Komputer domowy służący głównie do grania.', true);
        StringGridDaneDodaj(StringGrid1, 4, 'Test1', 'Opis 1(1)', 'Opis 2(1)', false);
        StringGridDaneDodaj(StringGrid1, 5, 'Test2', 'Opis 1(2)', 'Opis 2(2)', true);
    end;
end;

procedure TForm1.StringGrid1PrepareCanvas(Sender: TObject; aCol, aRow: Integer;
  aState: TGridDrawState);
var TS :TTextStyle;
begin
  //Kolumna "LP".
    if(aCol = 0) then begin
      TS:= TStringGrid(Sender).Canvas.TextStyle;
      TS.Alignment := taRightJustify;
      TStringGrid(Sender).Canvas.TextStyle:= TS;
      with StringGrid1.Canvas.Font do begin
        Color:= clBlack; Style:= [fsBold];
      end;
    end;
  //Tytuł.
    if(Trim(StringGrid1.Cells[0, aRow]) <> '') then begin
      with StringGrid1.Canvas.Font do begin
        Color:= clBlack; Style:= [fsBold];
      end;
    end;
  //Zaznacz wybrane wiersze.
    if(Trim(StringGrid1.Cells[2, aRow]) = 't') then begin
      with StringGrid1.Canvas do begin
        Font.Color:= clBlack;
        Font.Size:= 11;
        Brush.Color:= clAqua;
      end;
    end;
end;

end.

