unit unit1;
//--== Tylko liczba rzeczywistsza ==--
//Copyright (c)by Jan T. Biernat
{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;
type {TForm1}
  TForm1 = class(TForm)
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    //Deklaracja zmiennych prywatnych.
  public
    //Deklaracja zmiennych globalnych.
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

function TylkoLiczbaR(Str:String; Dl:Integer; IlePoKropce:Shortint):String;
var T, Tylko            :String;
    Start, KropkaLicz, I:Integer;
    Kropka              :Boolean;
begin
  //TylkoLiczbaR - Funkcja wyciąga z podanego ciągu znaków tylko cyfry, znak minus i kropkę.
  T:= ''; Tylko:= '';
  Start:= 0; KropkaLicz:= 0; I:= 0;
  Kropka:= false;
  if(Dl < 3) then Dl:= 3;
  T:= Trim(Copy(Str, 1, Dl));
  if(IlePoKropce < 2) then IlePoKropce:= 2;
  if(T <> '') then begin
    if(T[1] = '-') then begin
      Tylko:= Tylko+T[1];
      Start:= 1;
    end;
    for I:= Start to Length(T) do begin
      if((T[I] >= '0') and (T[I] <= '9') and (KropkaLicz < IlePoKropce)) then begin
        Tylko:= Tylko+T[I];
        if(Kropka = true) then KropkaLicz:= KropkaLicz+1;
      end else if((T[I] = '.') and (Kropka = false)) then begin
                 Tylko:= Tylko+T[I];
                 Kropka:= true;
               end;
    end;
  end else Tylko:= '';
  TylkoLiczbaR:= Tylko;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  Caption:= 'Tylko liczba rzeczywistsza (c)by Jan T. Biernat';
  Application.Title:= Caption;
end;

procedure TForm1.FormShow(Sender: TObject);
const Tekst:array[0..20] of String = ('0123456789',
                                      '? ',
                                      '',
                                      ' ',
                                      '012.3456789',
                                      '--01-2f.g3.456789',
                                      ' a0123456789 ab ',
                                      ' a0123456789 ab a0123456789 ab ',
                                      ' -a012345678.9 ab ',
                                      '--a01234-56789 ab ',
                                      '-0123456789 ab ',
                                      '-01234567.89 ab ',
                                      '-01234567.89 ab -01234567.89 ab ',
                                      '-01234567..89 ab ',
                                      '-0123..4f567..89 ab ',
                                      '-01234567..89 ab -01234567..89 ab ',
                                      '-012345-6789 ab ',
                                      '-012345-6.7.89 ab ',
                                      ' a0123.4d.fsd....56789 ab. ',
                                      ' a0  d - 1 . f 2   g3f4g5j6j7i89 ab ',
                                      '   !@#$&*() a0  d - 1 . f 2   g3f4g5j6j7i89 ab  0123456789 {}[]/<>,.+-=');
var I:Shortint;
begin
  with Memo1.Lines do begin
    Clear;
    for I:= 0 to 20 do
      Add(Tekst[I]+' = ['+TylkoLiczbaR(Tekst[I], 15, 3)+']');
  end;
end;

end.