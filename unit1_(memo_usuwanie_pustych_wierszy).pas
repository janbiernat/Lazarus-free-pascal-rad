unit unit1;
//--== Memo: Usuwanie pustych wierszy ==--
//Copyright (c)by Jan T. Biernat
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, Forms, Controls, Graphics, StdCtrls, Buttons;
type {TForm1}
  TForm1 = class(TForm)
    Memo2: TMemo;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    //Deklaracja prywatna.
  public
    //Deklaracja publiczna.
    procedure MEMO_UsunWierszPusty(Nazwa:TMemo);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.MEMO_UsunWierszPusty(Nazwa:TMemo);
var I:Integer;
begin
//MEMO_UsunWierszPusty - Procedura usuwa wiersze puste z komponentu "Memo".
  I:= 0;
  with Nazwa.Lines do begin
    for I:= Count-1 downto 0 do begin
      if(Trim(Strings[I]) = '') then Delete(I);
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  SpeedButton1Click(Sender);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
//Wypełnił komponent "Memo" danymi.
  with Memo2.Lines do begin
    Clear;
    Add('1');
    Add('2');
    Add('3');
    Add('');
    Add('4');
    Add('5');
    Add('');
    Add('');
    Add('6');
    Add('7');
    Add('');
    Add('8');
    Add('');
    Add('');
    Add('9');
    Add('10');
    Add('11');
  end;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  MEMO_UsunWierszPusty(Memo2);
end;

end.

