unit Unit2;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, Grids;

type

  { TForm2 }

  TForm2 = class(TForm)
    SpeedButton1: TSpeedButton;
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure StringGrid1PrepareCanvas(sender: TObject; aCol, aRow: Integer;
      aState: TGridDrawState);
  private

  public

  end;

var
  Form2: TForm2;

implementation

uses Unit1; //Dla Form1.

{$R *.lfm}

{ TForm2 }

procedure TForm2.FormCreate(Sender: TObject);
begin
  Caption:= 'Tabliczka mnożenia';
end;

procedure TForm2.FormShow(Sender: TObject);
var A, B :Shortint;
begin //FormShow.
  Font.Size:= 13;
  //=
    with StringGrid1 do begin
      FixedCols:= 1; FixedRows:= 1;
      ColCount:= 11; RowCount:= 11;
      DefaultColWidth:= 55; DefaultRowHeight:= 45;
      for A:= 0 to 9 do begin
        Cells[A+1, 0]:= #32+IntToStr(1+A)+#32;
        Cells[0, A+1]:= #32+IntToStr(1+A)+#32;
        for B:= 0 to 9 do begin
           Cells[A+1, B+1]:= #32+IntToStr((1+A)*(1+B))+#32;
        end;
      end;
    end;
    //Określenie pozycji na ekranie dla formatki nr 2 względem formatki nr 1.
      Form2.Top:= Form1.Top+99;
      Form2.Left:= Form1.Left+99;
end;

procedure TForm2.SpeedButton1Click(Sender: TObject);
begin //SpeedButton1Click - Zamknij okno.
  Close;
end;

procedure TForm2.StringGrid1PrepareCanvas(sender: TObject; aCol, aRow: Integer;
  aState: TGridDrawState);
var TS :TTextStyle;
begin //StringGrid1PrepareCanvas - Ustawienie justowania dla tekstu do prawej strony.
  TS:= TStringGrid(Sender).Canvas.TextStyle;
  TS.Alignment := taRightJustify;
  TStringGrid(Sender).Canvas.TextStyle:= TS;
end;

end.
