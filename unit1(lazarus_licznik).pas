unit unit1;
(*--== Licznik ==--
  Copyright (c)by Jan T. Biernat
 *)
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Buttons,
  ExtCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    Timer1: TTimer;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

function ZeroPrzed(Str :String):String;
begin
  if(Length(Str) = 1) then ZeroPrzed:= '0'+Str
  else ZeroPrzed:= Str;
end;

function Licznik(Str :String):String;
var G, M, S:Shortint;
begin //Licznik: Licz czas do przodu.
  Str:= Trim(Str);
  if(Str <> '') then begin
    G:= 0; G:= StrToIntDef(Copy(Str, 1, 2), 0);
    M:= 0; M:= StrToIntDef(Copy(Str, 4, 2), 0);
    S:= 0; S:= StrToIntDef(Copy(Str, 7, 2), 0);
    if(S = 59) then begin
      S:= 0;
      if(M = 59) then begin
        M:= 0;
        if(G = 23) then begin
          G:= 0;
        end else G:= G+1;
      end else M:= M+1;
    end else S:= S+1;
    Licznik:= ZeroPrzed(IntToStr(G))+':'+
                   ZeroPrzed(IntToStr(M))+':'+
                   ZeroPrzed(IntToStr(S));
  end else Licznik:= '?';
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption:= 'Licznik (c)by Jan T. Biernat';
  Application.Title:= Caption;
  FormResize(Sender);
end;

procedure TForm1.FormResize(Sender: TObject);
begin //FormResize.
  Width:= 755; Height:= 342;
end;

procedure TForm1.FormShow(Sender: TObject);
begin //FormShow.
  Font.Size:= 13;
  //=
    with Label1 do begin
      Caption:= '00:00:00';
      Font.Size:= 95; Font.Style:= [fsBold];
    end;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin //SpeedButton2Click - Zamknij aplikację.
  Application.Terminate;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin //Timer1Timer.
  Label1.Caption:= Licznik(Label1.Caption);
end;

end.
