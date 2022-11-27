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
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    ListBox1: TListBox;
    ListBox2: TListBox;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    //Private declaration
  public
    function ListBoxDodaj(ListBoxN:TListBox; T:String):String;
    function ListBoxZnajdz(ListBoxN:TListBox; T:String):String;
    function ListBoxUsun(ListBoxN:TListBox):String;
    function ListBoxToLB(ListBoxS, ListBoxT:TListBox):Integer;
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
  I:= 0; L:= FALSE; T:= Trim(T);
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
  S:= ''; T:= Trim(T);
  with ListBoxN do begin
    if(Count > 0) then begin
      Selected[0]:= TRUE;
      if(T <> '') then begin
        for I:= 0 to Items.Count-1 do begin;
          if(Copy(AnsiLowerCase(Trim(Items[I])), 1, Length(T)) = AnsiLowerCase(T)) then begin
            Selected[I]:= TRUE; S:= Trim(Items[I]); Break;
          end;
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

function TForm1.ListBoxToLB(ListBoxS, ListBoxT:TListBox):Integer;
var I, Spr:Integer;
    T     :String;
    Jest  :Boolean;
begin //ListBoxToLB - Kopiowanie listy z jednego komponentu "ListBox" do drugiego komponentu "ListBox".
  with ListBoxS do begin
    for I:= 0 to Count-1 do begin
      T:= ''; T:= Trim(Items[I]);
      if(T<>'') then begin
        Jest:= FALSE;
        for Spr:= 0 to ListBoxT.Count-1 do begin
          if(AnsiLowerCase(Trim(ListBoxT.Items[Spr])) = AnsiLowerCase(T)) then begin
            Jest:= TRUE; Break;
          end;
        end;
        if(Jest = FALSE) then begin ListBoxT.Items.Add(T); end;
      end;
    end;
  end;
  Result:= ListBoxT.Count;
end;

procedure TForm1.FormCreate(Sender: TObject);
var I:Integer;
begin //FormCreate.
  Button1.Caption:= 'Dodaj';
  Button2.Caption:= 'Usuń';
  Button3.Caption:= 'LB1 do LB2';
  Button4.Caption:= 'LB1 Clear';
  Button5.Caption:= 'LB2 Clear';
  with ListBox1 do begin
    Clear;
    for I:= 0 to 2 do begin
      Items.Add('Poniedziałek');
      Items.Add('Wtorek');
      Items.Add('Środa');
      Items.Add('Czwartek');
      Items.Add('Piątek');
      Items.Add('Sobota');
      Items.Add('Niedziela');
      Items.Add('Styczeń');
      Items.Add('Luty');
      Items.Add('Marzec');
      Items.Add('Kwiecień');
      Items.Add('Maj');
      Items.Add('Czerwiec');
      Items.Add('Lipiec');
      Items.Add('Sierpień');
      Items.Add('Wrzesień');
      Items.Add('Październik');
      Items.Add('Listopad');
      Items.Add('Grudzień');
    end;
    Form1.Caption:= IntToStr(Count);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var T:String;
begin //Button1Click - Dodaj nowy element do listy.
  T:= ''; T:= ListBoxDodaj(ListBox1, Edit1.Text);
  if(T <> '') then Caption:= '['+T+'] Dodano nowy elementy do listy'
  else Caption:= '['+T+'] Niestety! Ale nie!';
end;

procedure TForm1.Button2Click(Sender: TObject);
begin //Button2Click - Usuń wybrany element z listy.
  Caption:= '['+ListBoxUsun(ListBox1)+']';
end;

procedure TForm1.Button3Click(Sender: TObject);
begin //Button3Click - Przekopiuj dane bez powtórzeń z jednej listy do drugiej.
  Caption:= IntToStr(ListBoxToLB(ListBox1, ListBox2));
end;

procedure TForm1.Button4Click(Sender: TObject);
begin //Button4Click - Wyczyść komponent ListBox1.
  ListBox1.Clear;;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin //Button5Click - Wyczyść komponent ListBox2.
  ListBox2.Clear;
end;

procedure TForm1.Edit1Change(Sender: TObject);
var T:String;
begin //Edit1Change - Zanjdź element na liście.
  T:= ''; T:= ListBoxZnajdz(ListBox2, Edit1.Text);
  if(T <> '') then Caption:= '['+T+'] = Znalazlem'
  else Caption:= '['+T+'] Niestety! Nie znalazlem!';
end;

end.