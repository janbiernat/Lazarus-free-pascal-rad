unit unit1;
(*--== Zegarek 2 ==--
  Copyright (c)by Jan T. Biernat
  ==
  Na formatce (tj. Form1) należy umieścić
  następujące komponenty:
    > Timer1.
    > SpeedButton1.
    > Label1.
  Wykorzystując okno Inspektora Obiektów,
  wygeneruj następujące zdarzenia:
    - Dla formatki (tj. Form1):
        > OnCreate (tj. FormCreate).
        > OnDestroy (tj. FormDestroy).
        > OnKeyPress (tj. FormKeyPress).
        > OnResize (tj. FormResize).
        > OnShow (tj. FormShow).
    - Dla komponentu SpeedButton1:
       > OnClick (tj. SpeedButton1Click).
    - Dla komponentu Timer1:
       > OneTimer (tj. Timer1Timer).
*)

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls;

type { TForm1 }
  TForm1 = class(TForm)
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declaration }
  public
    { Public declaration }
    ZG_FormSzer :Integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin //FormCreate.
  FormResize(Sender);
  Caption:= 'Zegarek 2 [Prosty] (c)by Jan T. Biernat';
  Application.Title:= Caption;
  //=
    ZG_FormSzer:= 0; ZG_FormSzer:= Form1.ClientWidth;
    Label1.Font.Size:= 72;
    Timer1.Enabled:= TRUE; Timer1Timer(Sender);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin //FormDestroy.
  Timer1.Enabled:= FALSE;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: char);
begin //FormKeyPress.
  if(Key = #27) then Application.Minimize
  else if((Key = #90) or (Key = #122)) then Application.Terminate;
end;

procedure TForm1.FormResize(Sender: TObject);
const iWidth = 320;
begin //FormResize.
  with Form1 do begin
    if(ClientWidth < iWidth) then ClientWidth:= iWidth;
    ClientHeight:= Label1.Top+Label1.Height+65;
  end;
  with SpeedButton1 do begin
    Caption:= '&Zamknij';
    Font.Size:= 13;
    Font.Style:= [];
    Top:= 8; Height:= 48;
    Left:= Form1.ClientWidth-(Width+70);
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin //FormShow.
  Form1.Font.Size:= 13;
  //=
    with Label1 do begin
      Top:= 64; Left:= 40;
      Font.Style:= [fsBold];
      AutoSize:= TRUE;
      Color:= clBtnFace;
      Caption:= FormatDateTime('hh:nn.ss', Now);
    end;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin //SpeedButton1Click.
  Application.Terminate;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin //Timer1Timer.
  Timer1.Interval:= 10;
  //=
    if(ZG_FormSzer <> Form1.ClientWidth) then begin
      if(ZG_FormSzer < Form1.ClientWidth) then begin
        //WWykonaj poniższe instrukcje, gdy formatka jest powiększona.
          if(Label1.Width < (Form1.ClientWidth-124)) then
            Label1.Font.Size:= Label1.Font.Size+1
          else begin
                 ZG_FormSzer:= 0; ZG_FormSzer:= Form1.ClientWidth;
               end;
      end else begin
                 //WWykonaj poniższe instrukcje, gdy formatka jest pomniejszona.
                   if(Label1.Width > (Form1.ClientWidth-124)) then
                     Label1.Font.Size:= Label1.Font.Size-1
                   else begin
                          ZG_FormSzer:= 0; ZG_FormSzer:= Form1.ClientWidth;
                        end;
               end;
    end;
    FormResize(Sender); FormShow(Sender);
end;

end.