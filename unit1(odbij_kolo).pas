unit unit1;
{--== Odbij koło ==--
 Copyright (c)by Jan T. Biernat}
{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;
type {TForm1}
  TForm1 = class(TForm)
    Label1: TLabel;
    Shape1: TShape;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    X, Y, RuchX, RuchY:Integer; //Deklaracja zmiennych liczbowych całkowitych.
    procedure ShapeLabel(L, T:Integer);
  public
    //Public declarations
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ShapeLabel(L, T:Integer);
begin //ShapeLabel - Określenie pozycji XY komponentu Shape i Label.
  with Shape1 do begin
    Left:= L; Top:= T;
    Width:= 120; Height:= 120;
    Shape:= stEllipse;
    with Label1 do begin
      Font.Size:= 14;
      Font.Color:= clBlack;
      Left:= Shape1.Left+22;
      Top:= Shape1.Top+45;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin //FormCreate - Inicjowanie ustawień początkowych aplikacji, przed wyświetleniem formatki.
  FormResize(Sender);
  FormShow(Sender);
  Caption:= 'Odbij koło (c)by Jan T. Biernat';
  Application.Title:= Caption;
  Timer1Timer(Sender);
end;

procedure TForm1.FormResize(Sender: TObject);
const iWidth  = 340;
      iHeight = 200;
begin //FormResize - Kontrolowanie rozmiaru formatki oraz ułożenie i rozmiar komponentów.
  if(iWidth > Width) then Width:= iWidth;
  if(iHeight > Height) then Height:= iHeight;
end;

procedure TForm1.FormShow(Sender: TObject);
begin //FormShow - Inicjowanie ustawień początkowych aplikacji, w momencie wyświetlenia formatki.
  Font.Size:= 13;
  //=
    X:= 0; Y:= 0; RuchX:= 0; RuchY:= 0;
    Width:= 340; Height:= 200;
    X:= 1; Y:= 1; RuchX:= (Width div 2); RuchY:= (Height div 3);
    ShapeLabel(RuchX, RuchY);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin //Timer1Timer - Generuje zdarzenie co jakiś określony czas.
  with Timer1 do begin
    Interval:= 20; Enabled:= TRUE;
  end;
  Label1.Caption:= FormatDateTime('hh:nn.ss', Now); //Czas.
  //Obliczanie pozycji koła.
    RuchX:= RuchX+X;
    RuchY:= RuchY+Y;
  //Kontrola kolizji.
    with Form1 do begin
      if (RuchX <= 1) then X:= 1;
      if (RuchX >= (ClientWidth-Shape1.Width)) then X:= -1;
      if (RuchY <= 1) then Y:= 1;
      if (RuchY >= (ClientHeight-Shape1.Height)) then Y:= -1;
    end;
  ShapeLabel(RuchX, RuchY);
end;

end.