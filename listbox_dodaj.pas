unit unit1;
(*--== ListBoxDodaj ==--
  Copyright (c)by Jan T. Biernat
 *)
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;
type
  { TForm1 }
  TForm1 = class(TForm)
    ListBox1: TListBox;
    procedure FormCreate(Sender: TObject);
  private
  //private declaration
  public
    procedure ListBoxDodaj(ListBoxN:TListBox; T:String);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ListBoxDodaj(ListBoxN:TListBox; T:String);
var I:Integer;
    L:Boolean;
begin //ListBoxDodaj - Dodaj nowy element do listy bez powtórzeń.
  T:= Trim(T);
  with ListBoxN do begin
    if(T <> '') then begin
      L:= FALSE;
      for I:= Items.Count-1 downto 0 do begin
        if(AnsiLowerCase(Trim(Items[I])) = AnsiLowerCase(T)) then begin
          L:= TRUE; Break;
        end;
      end;
      //Dodaj element do listy, gdy go brak.
        if(L = FALSE) then begin
          Items.Add(T);
        end;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin //FormCreate.

end;

end.