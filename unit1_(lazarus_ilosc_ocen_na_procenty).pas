unit unit1;
{--== Ilość ocen na procenty ==--
 Copyright (c)by Jan T. Biernat
 =
 Napisz program, który obliczy jaki
 procent stanowi ilości danej oceny
 względem całkowitej sumy ocen.
 Na przykład:
 Ocen bardzo dobrych jest 8 względem
 całkowitej sumy ocen, która wynosi 24.
 Liczba 8 stanowi 33,33% całkowitej
 sumy ocen, która wynosi 24.
}
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Grids, StdCtrls,
  Buttons;

type {TForm1}
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    StringGrid1: TStringGrid;
    procedure Edit1Enter(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure StringGrid1EditingDone(Sender: TObject);
    procedure StringGrid1PrepareCanvas(Sender: TObject; aCol, aRow: Integer;
      aState: TGridDrawState);
  private
    //Prywatne deklaracje.
  public
    //Publiczne deklaracje.
  end;

var
  Form1: TForm1;

implementation
{$R *.lfm}

{TForm1}

procedure TForm1.FormCreate(Sender: TObject);
begin //FormCreate: Ustawienia startowe aplikacji.
  Caption:= 'Ilość ocen na procenty';
  Application.Title:= Caption;
  //=
    Font.Size:= 14;
    with StringGrid1 do begin
      Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goDrawFocusSelected,goEditing,goSmoothScroll];
      ColCount:= 3; RowCount:= 7;
      ColWidths[0]:= 90; Cells[0, 0]:= 'Ocena';
      ColWidths[1]:= 90; Cells[1, 0]:= 'Ilość';
      ColWidths[2]:= 90; Cells[2, 0]:= '%';
      //
      Cells[0, 1]:= '1.0';
      Cells[0, 2]:= '2.0';
      Cells[0, 3]:= '3.0';
      Cells[0, 4]:= '4.0';
      Cells[0, 5]:= '5.0';
      Cells[0, 6]:= '6.0';
    end;
    Edit1.Text:= '';
    Edit2.Text:= Edit1.Text;
end;

procedure TForm1.Edit1Enter(Sender: TObject);
begin //Edit1Enter: Przenieść aktywność do komponentu "StringGrid1".
  StringGrid1.SetFocus;
end;

procedure TForm1.FormResize(Sender: TObject);
begin //FormResize: Zablokowanie rozmiaru formatyki.
    Width:= 352; Height:= 395;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin //SpeedButton1Click: Zamknij aplikację.
  Application.Terminate;
end;

procedure TForm1.StringGrid1EditingDone(Sender: TObject);
const ERROR = '?';
var I, Licznik :Shortint;
    Ilosc, Suma:Integer;
    TKomorka   :String;
begin //StringGrid1EditingDone: Wykonaj obliczenia.
  I:= 0; Licznik:= 0; Ilosc:= 0; Suma:= 0; TKomorka:= '';
  with StringGrid1 do begin
    for I:= 1 to 6 do begin
      TKomorka:= ''; TKomorka:= Trim(Copy(Cells[1, I], 1, 3));
      if(TKomorka <> '') then begin
        Ilosc:= 0; Ilosc:= StrToIntDef(TKomorka, -1);
        if(Ilosc > -1) then begin
          Suma:= Suma+Ilosc;
          Licznik:= Licznik+1;
        end else Cells[1, I]:= ERROR;
      end else Cells[1, I]:= ERROR;
    end;
    Edit1.Text:= IntToStr(Suma);
    if(Licznik > 0) then Edit2.Text:= FormatFloat('#,##0.00', (Suma/Licznik))
    else Edit2.Text:= ERROR;
    //
    //Oblicz procent dla każdej oceny.
      I:= 0;
      for I:= 1 to 6 do begin
        Ilosc:= 0; Ilosc:= StrToIntDef(Trim(Copy(Cells[1, I], 1, 3)), 0);
        if(Suma > 0) then Cells[2, I]:= FormatFloat('#,##0.00', (Ilosc*100)/Suma);
      end;
  end;
end;

procedure TForm1.StringGrid1PrepareCanvas(Sender: TObject; aCol, aRow: Integer;
  aState: TGridDrawState);
var TS:TTextStyle;
begin //StringGrid1PrepareCanvas: Ustawienia dla komponentu.
  with StringGrid1 do begin
    //Tytuł.
      if((Trim(Cells[0, aRow]) <> '') and (aRow = 0)) then begin
        TS.Alignment := taCenter;
        TStringGrid(Sender).Canvas.TextStyle:= TS;
        Canvas.Font.Color:= clBlack;
        Canvas.Font.Style:= [fsBold];
      end;
    //Kolumna "LP".
      if((aCol = 0) and (aRow > 0)) then begin
        TS:= TStringGrid(Sender).Canvas.TextStyle;
        TS.Alignment:= taCenter;
        TStringGrid(Sender).Canvas.TextStyle:= TS;
        Canvas.Font.Color:= clBlack;
      end;
    //Kolumna "Ilość" i "%".
      if(((aCol = 1) and (aRow > 0))
      or ((aCol = 2) and (aRow > 0))) then begin
        TS:= TStringGrid(Sender).Canvas.TextStyle;
        TS.Alignment:= taRightJustify;
        TStringGrid(Sender).Canvas.TextStyle:= TS;
        Canvas.Font.Color:= clBlack;
      end;
  end;
end;

end.

