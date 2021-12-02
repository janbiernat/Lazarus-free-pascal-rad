unit unit3; 
(*--== Opcje programu ==-- 
  Copyright (c)by Jan T. Biernat 
  = 
  Obsługa listy wewnętrznej StringList 
  i komponentów: Edit, CheckBox, ListBox 
  oraz ComboBox. 
 *) 
{$mode objfpc}{$H+} 
 
interface 
uses 
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls; 
type 
  { TformOpcje } 
  TformOpcje = class(TForm) 
    CheckBox1: TCheckBox; 
    ComboBox1: TComboBox; 
    Edit1: TEdit; 
    Label1: TLabel; 
    ListBox1: TListBox; 
    Panel1: TPanel; 
    procedure FormCreate(Sender: TObject); 
    procedure FormShow(Sender: TObject); 
  private 
    procedure OpcjeEdit(EditN :TEdit; OpcjaNazwa, Szukaj :String); 
    procedure OpcjeCheckBox(CheckBoxN :TCheckBox; OpcjaNazwa, Szukaj :String); 
    procedure OpcjePanelKolor(PanelN :TPanel; OpcjaNazwa, Szukaj :String); 
    procedure OpcjeListBox(ListBoxNazwa :TListBox; OpcjaNazwa, Szukaj :String); 
    procedure OpcjeComboBoxE(ComboBoxNazwa :TComboBox; OpcjaNazwa, Szukaj :String); 
    procedure OpcjeComboBox(ComboBoxNazwa :TComboBox; OpcjaNazwa, Szukaj :String); 
  public 
    procedure OpcjeOdczyt(Str: String); 
  end; 
 
var formOpcje: TformOpcje; 
implementation 
uses unit1; 
 
{$R *.lfm} 
 
{ TformOpcje } 
 
procedure TformOpcje.OpcjeEdit(EditN :TEdit; OpcjaNazwa, Szukaj :String); 
begin //OpcjeEdit - Umieść dane w komponencie Edit. 
  OpcjaNazwa:= AnsiLowerCase(Trim(OpcjaNazwa)); 
  Szukaj:= Trim(Szukaj); 
  if(OpcjaNazwa <> '') then begin 
    if(OpcjaNazwa = AnsiLowerCase(Copy(Szukaj, 1, Length(OpcjaNazwa)))) then begin 
      EditN.Text:= Trim(Copy(Szukaj, Length(OpcjaNazwa)+1, Length(Szukaj))); 
    end; 
  end; 
end; 
 
procedure TformOpcje.OpcjeCheckBox(CheckBoxN :TCheckBox; OpcjaNazwa, Szukaj :String); 
begin //OpcjeCheckBox - Ustawienie komponentu CheckBox. 
  OpcjaNazwa:= AnsiLowerCase(Trim(OpcjaNazwa)); 
  Szukaj:= Trim(Szukaj); 
  if(OpcjaNazwa <> '') then begin 
    if(OpcjaNazwa = AnsiLowerCase(Copy(Szukaj, 1, Length(OpcjaNazwa)))) then begin 
      if(AnsiLowerCase(Szukaj[Length(OpcjaNazwa)+1]) = 't') then CheckBoxN.Checked:= TRUE 
      else CheckBoxN.Checked:= FALSE; 
    end; 
  end; 
end; 
 
procedure TformOpcje.OpcjePanelKolor(PanelN :TPanel; OpcjaNazwa, Szukaj :String); 
begin //OpcjePanelKolor - Ustawienie koloru dla komponentu Panel. 
  OpcjaNazwa:= AnsiLowerCase(Trim(OpcjaNazwa)); 
  Szukaj:= Trim(Szukaj); 
  if(OpcjaNazwa <> '') then begin 
    if(OpcjaNazwa = AnsiLowerCase(Copy(Szukaj, 1, Length(OpcjaNazwa)))) then begin 
      PanelN.Color:= StrToIntDef(Trim(Copy(Szukaj, Length(OpcjaNazwa)+1, Length(Szukaj))), 0); 
    end; 
  end; 
end; 
 
procedure TformOpcje.OpcjeListBox(ListBoxNazwa :TListBox; OpcjaNazwa, Szukaj :String); 
var I    :Integer; 
    T    :String; 
    Jest :Boolean; 
begin //OpcjeListBox - Umieść dane bez powtórzeń na liście komponentu ListBox. 
  OpcjaNazwa:= AnsiLowerCase(Trim(OpcjaNazwa)); 
  Szukaj:= Trim(Szukaj); 
  T:= ''; 
  if(OpcjaNazwa <> '') then begin 
    if(OpcjaNazwa = AnsiLowerCase(Copy(Szukaj, 1, Length(OpcjaNazwa)))) then begin 
      T:= Trim(Copy(Szukaj, Length(OpcjaNazwa)+1, Length(Szukaj))); 
      Jest:= FALSE; 
      for I:= 0 to ListBoxNazwa.Items.Count-1 do begin 
        if(AnsiLowerCase(T) = AnsiLowerCase(ListBoxNazwa.Items[I])) then begin 
          Jest:= TRUE; Break; 
        end; 
      end; 
      if(Jest = FALSE) then ListBoxNazwa.Items.Add(T); 
    end; 
  end; 
end; 
 
procedure TformOpcje.OpcjeComboBoxE(ComboBoxNazwa :TComboBox; OpcjaNazwa, Szukaj :String); 
begin //OpcjeComboBoxE - Umieść dane bez powtórzeń na liście komponentu ComboBox. 
  OpcjaNazwa:= AnsiLowerCase(Trim(OpcjaNazwa)); 
  Szukaj:= Trim(Szukaj); 
  if(OpcjaNazwa <> '') then begin 
    if(OpcjaNazwa = AnsiLowerCase(Copy(Szukaj, 1, Length(OpcjaNazwa)))) then begin 
      ComboBoxNazwa.Text:= Trim(Copy(Szukaj, Length(OpcjaNazwa)+1, Length(Szukaj))); 
    end; 
  end; 
end; 
 
procedure TformOpcje.OpcjeComboBox(ComboBoxNazwa :TComboBox; OpcjaNazwa, Szukaj :String); 
var I    :Integer; 
    T    :String; 
    Jest :Boolean; 
begin //OpcjeComboBox - Umieść dane bez powtórzeń na liście komponentu ComboBox. 
  OpcjaNazwa:= AnsiLowerCase(Trim(OpcjaNazwa)); 
  Szukaj:= Trim(Szukaj); 
  T:= ''; 
  if(OpcjaNazwa <> '') then begin 
    if(OpcjaNazwa = AnsiLowerCase(Copy(Szukaj, 1, Length(OpcjaNazwa)))) then begin 
      T:= Trim(Copy(Szukaj, Length(OpcjaNazwa)+1, Length(Szukaj))); 
      Jest:= FALSE; 
      for I:= 0 to ComboBoxNazwa.Items.Count-1 do begin 
        if(AnsiLowerCase(T) = AnsiLowerCase(ComboBoxNazwa.Items[I])) then begin 
          Jest:= TRUE; Break; 
        end; 
      end; 
      if(Jest = FALSE) then ComboBoxNazwa.Items.Add(T); 
    end; 
  end; 
end; 
 
procedure TformOpcje.OpcjeOdczyt(Str :String); 
var Dane :TStringList; 
    I    :Integer; 
begin //OpcjeOdczyt - Odczyt ustawień z pliku tekstowego. 
  Str:= AnsiLowerCase(Trim(Str)); 
  //Ustawienia domyślne. 
    CheckBox1.Checked:= TRUE; 
    Edit1.Text:= 'Tekst domyślny (Edit).'; 
    ListBox1.Items.Clear; 
    ComboBox1.Items.Clear; ComboBox1.Text:= 'Tekst domyślny (ComboBox).'; 
    Panel1.Color:= clRed; 
  //Odczytanie ustawień z pliku. 
    if(FileExists(Str) = TRUE) then begin 
      Dane:= TStringList.Create; 
        Dane.Clear; 
        Dane.LoadFromFile(Str); 
        for I:= 0 to Dane.Count-1 do begin 
          OpcjeEdit(Edit1, 'Tytul=', Dane.Strings[I]); 
          OpcjeListBox(ListBox1, 'Problem=', Dane.Strings[I]); 
          OpcjeComboBoxE(ComboBox1, 'ImieDef=', Dane.Strings[I]); 
          OpcjeComboBox(ComboBox1, 'Imie=', Dane.Strings[I]); 
          OpcjeCheckBox(CheckBox1, 'WyrWielLit=', Dane.Strings[I]); 
          OpcjePanelKolor(Panel1, 'kolor=', Dane.Strings[I]); 
        end; 
        Dane.Destroy; 
    end; 
    ListBox1.Sorted:= TRUE; 
    ComboBox1.Sorted:= TRUE; 
end; 
 
procedure TformOpcje.FormCreate(Sender: TObject); 
begin 
  Caption:= 'Opcje programu (c)by Jan T. Biernat'; 
end; 
 
procedure TformOpcje.FormShow(Sender: TObject); 
begin 
  OpcjeOdczyt(Form1.ZG_Katalog[2]); 
end; 
 
end. 