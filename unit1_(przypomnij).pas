unit unit1;
{$mode objfpc}{$H+}
//--== Przypomnij ==--
//Copyright (c)by Jan T. Biernat
interface
uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls;
type {TForm1}
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    ListBox1: TListBox;
    Shape1: TShape;
    Shape2: TShape;
    SpeedButton1: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
  private
    //Private declarations.
  public
    //Public declarations.
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{TForm1}

function ZeroPrzed(Str:String):String;
begin
  ZeroPrzed:= Str;
  if(Length(Str) = 1) then ZeroPrzed:= '0'+Str;
end;

function DzisiajJest:String;
var Rok, Miesiac, Dzien:Word;
begin
  Rok:= 0; Miesiac:= 0; Dzien:= 0;
  DecodeDate(Now, Rok, Miesiac, Dzien);
  DzisiajJest:= IntToStr(Rok)+'-'+
                ZeroPrzed(IntToStr(Miesiac))+'-'+
                ZeroPrzed(IntToStr(Dzien));
end;

function RokPrzestepny:Boolean;
var Rok           :Integer;
    _RokPrzestepny:Boolean;
begin
  _RokPrzestepny:= FALSE;
  Rok:= 0; Rok:= StrToInt(Copy(DzisiajJest, 1, 4));
  if(((Rok mod 4 = 0) and (Rok mod 100 <> 0))
  or (Rok mod 400 = 0)) then _RokPrzestepny:= TRUE;
  RokPrzestepny:= _RokPrzestepny;
end;

function IleDniMaMiesiac:Shortint;
var Miesiac, MiesiacMaDni:Shortint;
begin
  Miesiac:= 0; Miesiac:= StrToInt(Copy(DzisiajJest, 6, 2));
  MiesiacMaDni:= 0;
  if(Miesiac in [1, 3, 5, 7, 8, 10, 12]) then MiesiacMaDni:= 31
  else if(Miesiac in [4, 6, 9, 11]) then MiesiacMaDni:= 30
       else if(Miesiac = 2) then begin
              MiesiacMaDni:= 28;
              if(RokPrzestepny = TRUE) then MiesiacMaDni:= 29;
            end;
  IleDniMaMiesiac:= MiesiacMaDni;
end;

function Przypomnij(MiesiacDzien:String):Boolean;
var _Przypomnij              :Boolean;
    Miesiac, Dzien, NazwaDnia:String;
    DMiesiac, DDzien         :String;
begin
  _Przypomnij:= FALSE;
  Miesiac:= ''; Miesiac:= Copy(DzisiajJest, 6, 2);
  Dzien:= ''; Dzien:= Copy(DzisiajJest, 9, 2);
  NazwaDnia:= ''; NazwaDnia:= AnsiLowerCase(Copy(LongDayNames[DayOfWeek(Now)] , 1, 2));
  if(Length(MiesiacDzien) = 5) then begin
    DMiesiac:= ''; DMiesiac:= ZeroPrzed(Copy(Trim(MiesiacDzien), 1, 2));
    DDzien:= ''; DDzien:= AnsiLowerCase(ZeroPrzed(Copy(Trim(MiesiacDzien), 4, 2)));
    if(DDzien = 'od') then DDzien:= IntToStr(IleDniMaMiesiac);
    if((DMiesiac+'-'+DDzien = Miesiac+'-'+Dzien)
    or (DMiesiac+'-'+DDzien = Miesiac+'---')
    or (DMiesiac+'-'+DDzien = '---'+Dzien)
    or (DMiesiac+'-'+DDzien = Miesiac+'-'+NazwaDnia)
    or (DMiesiac+'-'+DDzien = '---'+NazwaDnia)
    or (DMiesiac+'-'+DDzien = '-----')) then _Przypomnij:= TRUE;
  end;
  Przypomnij:= _Przypomnij;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FormResize(Sender);
  BorderStyle:= bsNone;
  FormStyle:= fsStayOnTop;
  Caption:= 'Przypomnij (c)by Jan T. Biernat';
  Application.Title:= Caption;
  FormShow(Sender);
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: char);
begin
  if(Key = #27) then Application.Minimize
  else if((Key = #90) or (Key = #122)) then SpeedButton1Click(Sender);
end;

procedure TForm1.FormResize(Sender: TObject);
begin
  Left:= 0; Top:= Screen.Width div 4;
  Width:= Screen.Width; Height:= 300;
  with Shape1 do begin
    Top:= 0; Left:= 0;
    Width:= Form1.ClientWidth;
    Height:= 2;
    Pen.Color:= clRed;
    Brush.Color:= Pen.Color;
  end;
  with Shape2 do begin
    Top:= Form1.ClientHeight-Shape1.Height; Left:= 0;
    Width:= Shape1.Width;
    Height:= Shape1.Height;
    Pen.Color:= Shape1.Pen.Color;
    Brush.Color:= Pen.Color;
  end;
  with SpeedButton1 do begin
    Caption:= '&Zamknij';
    Left:= Form1.ClientWidth-(Width+50);
  end;
  Label1.Top:= 20;
  SpeedButton1.Top:= Label1.Top+15;
  with ListBox1 do begin
    Width:= Form1.ClientWidth-90;
    IntegralHeight:= TRUE;
    Height:= 127;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
const PlikNazwa = 'przypomnij.txt';
var Dane:TStringList;
    I   :Integer;
begin
  Form1.Font.Size:= 13;
  //=
    I:= 0;
    with Label1 do begin
      Caption:= DzisiajJest;
      Font.Size:= 27;
    end;
    with Label2 do begin
      Font.Size:= 13;
      AutoSize:= FALSE;
      Caption:= LongMonthNames[StrToInt(Copy(DzisiajJest, 6, 2))]
               +', '+LongDayNames[DayOfWeek(Now)];
    end;
    //Wczytaj dane z pliku tekstowego.
      ListBox1.Items.Clear;
      Dane:= TStringList.Create;
        Dane.Clear;
        if(FileExists(PlikNazwa) = TRUE) then begin
          Dane.LoadFromFile(PlikNazwa);
          for I:= 0 to Dane.Count-1 do begin
            if(Przypomnij(Copy(Dane.strings[I], 1, 5)) = TRUE) then begin
              ListBox1.Items.Add(Copy(Dane.strings[I], 7, Length(Dane.strings[I])));
            end;
          end;
        end;
      Dane.Destroy;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  Application.Terminate;
end;

end.

