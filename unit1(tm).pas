unit Unit1;
(*--== Tabliczka mnożenia ==--
  Copyright (c)by Jan T. Biernat
 *)
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Buttons, StdCtrls,
  Grids;

const KomentarzIlosc = 5;
      KomentarzP :array[0..KomentarzIlosc-1] of string = ('Bardzo dobrze',
                                                          'Wspaniale',
                                                          'Rewelacyjnie',
                                                          'Dobrze',
                                                          'Świetnie');
      KomentarzN :array[0..KomentarzIlosc-1] of string = ('Bardzo źle',
                                                          'Źle',
                                                          'Błędna odpowiedź',
                                                          'Fatalnie',
                                                          'Beznadziejna odpowiedź');

type

  { TForm1 }

  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    WynikT          :String;
    A, B, ZnakiLicz :Shortint;
    OdpP, OdpN      :Integer;
    OdpZleLicz      :Integer; //Po ilu próbach błędnej odpowiedzi, wyświetlić podpowiedź.
    procedure OcenaWystaw(Sender: TObject);
  public

  end;

var
  Form1: TForm1;

implementation

uses Unit2; //Dla Form2.

{$R *.lfm}

{ TForm1 }

procedure TForm1.OcenaWystaw(Sender: TObject);
var OdpIlosc  :Integer;
    OdpP_Proc :Shortint;
begin //OcenaWystaw.
  OdpIlosc:= 0; OdpP_Proc:= 0;
  with StringGrid1 do begin
    OdpIlosc:= OdpP+OdpN; //Suma odpowiedzi poprawnych i negatywnych.
    if(OdpIlosc > 0) then OdpP_Proc:= Round(OdpP*100/OdpIlosc); //Obliczenie procentu dla odpowiedzi poprawnych.
    Cells[2, 0]:= #32+IntToStr(OdpP)+#32+'('+IntToStr(OdpP_Proc)+'%)';
    Cells[2, 1]:= #32+IntToStr(OdpN)+#32+'('+IntToStr(100-OdpP_Proc)+'%)';
    //Wystaw ocenę.
      if(OdpP_Proc > 0) then begin
        if(OdpP_Proc > 95) then Cells[2, 2]:= 'Bardzo dobry (5.0)'
        else if(OdpP_Proc > 80) then Cells[2, 2]:= 'Dobry (4.0)'
             else if(OdpP_Proc > 70) then Cells[2, 2]:= 'Dostateczny (3.0)'
                  else if(OdpP_Proc > 50) then Cells[2, 2]:= 'Mierny (2.0)'
                       else if(OdpP_Proc <= 50) then Cells[2, 2]:= 'Jedynka (1.0)';
      end else Cells[2, 2]:= '?';
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption:= 'Tabliczka mnożenia (c)by Jan T. Biernat';
  Application.Title:= Caption;
  FormResize(Sender);
  //=
    OdpP:= 0; OdpN:= 0;
    with StringGrid1 do begin
      FixedCols:= 0; FixedRows:= 0; Color:= clForm;
      ColCount:= 3; RowCount:= 3;
      Enabled:= false; Font.Size:= 10;
      Cells[0, 0]:= #32+'Odp. dobrych'; ColWidths[0]:= 137;
      Cells[1, 0]:= ':'; ColWidths[1]:= 10;
      Cells[2, 0]:= #32+'0'; ColWidths[2]:= 224;
      Cells[0, 1]:= #32+'Odp. złych';
      Cells[1, 1]:= ':';
      Cells[2, 1]:= #32+'0';
      Cells[0, 2]:= #32+'Ocena'; Cells[1, 2]:= ':'; Cells[2, 2]:= '?';
    end;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: char);
begin //FormKeyPress - Obsługa klawiszy.
  if((Key > #47) and (Key < #58)) then begin
    if(ZnakiLicz < 3) then begin
      WynikT:= WynikT+Key; ZnakiLicz:= ZnakiLicz+1;
    end;
  end else if(Key = #8) then begin
             WynikT:= ''; ZnakiLicz:= 0;
           end else if(Key = #13) then begin
                      //Sprawdź odpowiedzi użytkownika.
                        Randomize;
                        if(StrToIntDef(WynikT, -1) = (A*B)) then begin
                          //Odpowiedź prawidłowa.
                            with Label2 do begin
                              Caption:= KomentarzP[Random(KomentarzIlosc)]+'!';
                              Refresh;
                            end;
                            OdpP:= OdpP+1;//Zliczanie poprawnych odpowiedzi.
                            Sleep(777);
                            FormShow(Sender);
                        end else begin
                                   //Odpowiedź błędna.
                                     with Label2 do begin
                                       Caption:= KomentarzN[Random(KomentarzIlosc)]+'!';
                                       Refresh;
                                     end;
                                     OdpZleLicz:= OdpZleLicz+1;
                                     if(OdpZleLicz > 3) then begin
                                       with Label3 do begin
                                         Caption:= 'Prawidłowa odpowiedź to'
                                              +#32+IntToStr(A*B)+'.';
                                         Refresh;
                                       end;
                                     end;
                                     OdpN:= OdpN+1;//Zliczanie negatywnych odpowiedzi.
                                     WynikT:= ''; ZnakiLicz:= 0;
                                     Sleep(777);
                                     Label2.Caption:= ''; Label3.Caption:= '';
                                 end;
                    end;
  Label1.Caption:= IntToStr(A)+#32+'x'+#32+IntToStr(B)+#32+'='+#32+WynikT;
  OcenaWystaw(Sender);
end;

procedure TForm1.FormResize(Sender: TObject);
begin //FormResize.
  Width:= 1224; Height:= 520;
end;

procedure TForm1.FormShow(Sender: TObject);
begin //FormShow.
  Font.Size:= 13;
  //=
    SpeedButton1.Visible:= false;
    if(AnsiLowerCase(Trim(ParamStr(1))) = '-tm') then SpeedButton1.Visible:= true;
  //Początkowe ustawienia programu.
    WynikT:= ''; ZnakiLicz:= 0; OdpZleLicz:= 0;
    Label2.Caption:= ''; Label3.Caption:= '';
  //Losowanie liczb.
    Randomize;
    A:= 0; A:= Random(11);
    B:= 0; B:= Random(11);
    Label1.Caption:= IntToStr(A)+#32+'x'+#32+IntToStr(B)+#32+'='+#32+WynikT;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin //SpeedButton1Click - Wyświetl tabliczkę mnożenia.
  Form2.ShowModal;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin //SpeedButton2Click - Zamknij aplikację.
  Application.Terminate;
end;

end.
