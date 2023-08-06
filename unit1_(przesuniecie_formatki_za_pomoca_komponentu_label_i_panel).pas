unit unit1;
//--== Przesunięcie formatki za pomocą komponentu LABEL i PANEL ==--
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, Forms, Windows, Controls, Graphics, StdCtrls, ExtCtrls;
type {TForm1}
  TForm1 = class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Label1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Panel1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
  private
    //Prywatne deklaracje zmiennych.
  public
    //Publiczne deklaracje zmiennych.
    procedure FormPrzesun(Button:TMouseButton);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormPrzesun(Button:TMouseButton);
begin
  //FormPrzesun.
  //Umożliwia przesunięcie formatki, przez chwycenie
  //komponentu umieszczonego na formatce.
  if(Button = mbLeft) then begin
    ReleaseCapture;
    SendMessage(Handle, WM_LBUTTONUP, 0, 0);
    SendMessage(Handle, WM_NCLBUTTONDOWN, HTCAPTION, 0);
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FormResize(Sender);
  Caption:= 'Przesunięcie formatki za pomocą komponentu LABEL i PANEL';
  Application.Title:= Caption;
  with Panel1 do begin
    Caption:= 'Obecny czas to:';
    BevelInner:= bvNone;  //Obramowanie wewnętrzne jest wyłączone.
    BevelOuter:= bvNone;  //Obramowanie zewnętrzne jest wyłączone.
    BevelWidth:= 1;       //Określenie grubości obramowania.
    BorderStyle:= bsNone; //Obramowanie pojedyncze na cały komponent jest wyłączone.
  end;
  Timer1.Enabled:= TRUE;  //Uruchomienie komponentu TIMER1.
end;


procedure TForm1.FormResize(Sender: TObject);
begin
  Width:= 640; Height:= 480; //Określenie szerokości i wysokości formatki.
end;

procedure TForm1.Label1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FormPrzesun(Button); //Wywołanie procedury "FormPrzesun",
                       //która umożliwia przesunięcie formatki
                       //za pomocą komponentu LABEL (w tym
                       //przykładzie jest to komponent "Label1").
end;

procedure TForm1.Panel1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  FormPrzesun(Button); //Wywołanie procedury "FormPrzesun",
                       //która umożliwia przesunięcie formatki
                       //za pomocą komponentu PANEL (w tym
                       //przykładzie jest to komponent "Panel1").
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  Timer1.Interval:= 1000; //Zdarzenie będzie uruchamiane co 1 sekundę
                          //(1 sekundzie odpowiada 1000ms tj. milisekund).
  Label1.Caption:= FormatDateTime('hh:nn:ss', Now);
end;

end.

