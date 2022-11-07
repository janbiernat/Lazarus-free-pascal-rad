unit unit1;
{--== ListBox ==--
 Copyright (c)by Jan T. Biernat
}
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type { TForm1 }
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    ListBox1: TListBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Edit2Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    //Private declaration
  public
    function ListBoxDodaj(ListBoxN:TListBox; T:String):String;
    function ListBoxZnajdz(ListBoxN:TListBox; T:String):String;
    function ListBoxUsun(ListBoxN:TListBox):String;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

function TForm1.ListBoxDodaj(ListBoxN:TListBox; T:String):String;
var I:Integer;
    L:Boolean;
begin //ListBoxDodaj - Dodaj nowy element do listy bez powtórzeń.
  L:= FALSE; T:= Trim(T);
  with ListBoxN do begin
    if(T <> '') then begin
      for I:= Items.Count-1 downto 0 do begin
        if(AnsiLowerCase(Trim(Items[I])) = AnsiLowerCase(T)) then begin
          L:= TRUE; T:= ''; Break;
        end;
      end;
      //Dodaj element do listy, gdy go brak.
        if(L = FALSE) then begin
          Items.Add(T);
        end;
    end;
  end;
  Result:= T;
end;

function TForm1.ListBoxZnajdz(ListBoxN:TListBox; T:String):String;
var I:Integer;
    S:String;
begin //ListBoxZnajdz - Znajdź element, jeżeli jest na liście.
  S:= '';
  T:= Trim(T);
  with ListBoxN do begin
    Selected[0]:= TRUE;
    if(T <> '') then begin
      for I:= 0 to Items.Count-1 do begin;
        if(Copy(AnsiLowerCase(Trim(Items[I])), 1, Length(T)) = AnsiLowerCase(T)) then begin
          Selected[I]:= TRUE; S:= Trim(Items[I]); Break;
        end;
      end;
    end;
  end;
  Result:= S;
end;

function TForm1.ListBoxUsun(ListBoxN:TListBox):String;
var S:String;
begin //ListBoxUsun - Usuń wybrany element z listy.
  S:= '';
  with ListBoxN do begin
    if(ItemIndex > -1) then begin
      S:= Trim(Items[ItemIndex]);
      Items.Delete(ItemIndex);
    end;
  end;
  Result:= S;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin //FormCreate.
end;

procedure TForm1.Button1Click(Sender: TObject);
var T:String;
begin
  T:= ''; T:= ListBoxDodaj(ListBox1, Edit1.Text);
  if(T <> '') then Caption:= '['+T+'] Dodano nowy elementy do listy'
  else Caption:= '['+T+'] Niestety! Ale nie!';
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Caption:= '['+ListBoxUsun(ListBox1)+']';
end;

procedure TForm1.Edit2Change(Sender: TObject);
var T:String;
begin
  T:= ''; T:= ListBoxZnajdz(ListBox1, Edit2.Text);
  if(T <> '') then Caption:= '['+T+'] = Znalazlem'
  else Caption:= '['+T+'] Niestety! Nie znalazlem!';
end;

end.