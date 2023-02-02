unit unit1;
{--== Pytanie o zarobki ==--
 Copyright (c)by Jan T. Biernat}
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons;
type {TForm1}
  TForm1 = class(TForm)
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    //Deklaracje prywatne.
  public
    //Deklaracje publiczne.
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{TForm1}

procedure TForm1.FormCreate(Sender: TObject);
begin //FormCreate - Określenie wartości początkowych dla aplikacji.
  FormResize(Sender);
  Caption:= 'Pytanie o zarobki';
  Application.Title:= Caption;
end;

procedure TForm1.FormResize(Sender: TObject);
begin //FormResize - Ustawienie stałego rozmiaru formatki.
  Width:= 902;
  Height:= 246;
end;

procedure TForm1.FormShow(Sender: TObject);
begin //FormShow - Ustawienie rozmiaru czcionki dla formatki i komponentów.
  Font.Size:= 13;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin //SpeedButton1Click - Odpowiedź na pytanie, które znajduje się na przycisku.
  ShowMessage('Nisko cenisz swój czas i pracę!');
end;

procedure TForm1.SpeedButton2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin //SpeedButton2MouseMove - Losowanie pozycji dla przycisku "SpeedButton2".
  Randomize;
  with SpeedButton2 do begin
    Left:= Random(Form1.ClientWidth-Width);
    Top:= Random(Form1.ClientHeight-Height);
  end;
end;

end.