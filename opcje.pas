unit unit1;
{--== Opcje programu ==--
  Copyright (c)by Jan T. Biernat
  =
  Obsługa listy wewnętrznej StringList
  i komponentów: Edit, CheckBox, ListBox
  oraz ComboBox.
 }
{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type { TForm1 }
  TForm1 = class(TForm)
    CheckBox1: TCheckBox;
    ComboBox1: TComboBox;
    Edit1: TEdit;
    ListBox1: TListBox;
    Panel1: TPanel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    //Private declaration
  public
    procedure OpcjeEdit(EditN:TEdit; OpcjaNazwa, Dane:String);
    procedure OpcjeCheckBox(CheckBoxN:TCheckBox; OpcjaNazwa, Dane:String);
    procedure OpcjePanelKolor(PanelN:TPanel; OpcjaNazwa, Dane:String);
    procedure OpcjeListBox(ListBoxNazwa :TListBox; OpcjaNazwa, Dane:String);
    procedure OpcjeComboBoxE(ComboBoxNazwa :TComboBox; OpcjaNazwa, Dane:String);
    procedure OpcjeComboBox(ComboBoxNazwa :TComboBox; OpcjaNazwa, Dane:String);
    procedure OpcjeOdczyt(Str:String);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.OpcjeEdit(EditN:TEdit; OpcjaNazwa, Dane:String);
begin //OpcjeEdit - Umieść dane w komponencie Edit.
  OpcjaNazwa:= AnsiLowerCase(Trim(OpcjaNazwa));
  Dane:= Trim(Dane);
  if(OpcjaNazwa <> '') then begin
    if(OpcjaNazwa = AnsiLowerCase(Copy(Dane, 1, Length(OpcjaNazwa)))) then begin
      EditN.Text:= Trim(Copy(Dane, Length(OpcjaNazwa)+1, Length(Dane)));
    end;
  end;
end;

procedure TForm1.OpcjeCheckBox(CheckBoxN:TCheckBox; OpcjaNazwa, Dane:String);
begin //OpcjeCheckBox - Ustawienie komponentu CheckBox.
  OpcjaNazwa:= AnsiLowerCase(Trim(OpcjaNazwa));
  Dane:= Trim(Dane);
  if(OpcjaNazwa <> '') then begin
    if(OpcjaNazwa = AnsiLowerCase(Copy(Dane, 1, Length(OpcjaNazwa)))) then begin
      if(AnsiLowerCase(Dane[Length(OpcjaNazwa)+1]) = 't') then CheckBoxN.Checked:= TRUE
      else CheckBoxN.Checked:= FALSE;
    end;
  end;
end;

procedure TForm1.OpcjePanelKolor(PanelN:TPanel; OpcjaNazwa, Dane:String);
begin //OpcjePanelKolor - Ustawienie koloru dla komponentu Panel.
  OpcjaNazwa:= AnsiLowerCase(Trim(OpcjaNazwa));
  Dane:= Trim(Dane);
  if(OpcjaNazwa <> '') then begin
    if(OpcjaNazwa = AnsiLowerCase(Copy(Dane, 1, Length(OpcjaNazwa)))) then begin
      PanelN.Color:= StrToIntDef(Trim(Copy(Dane, Length(OpcjaNazwa)+1, Length(Dane))), 0);
    end;
  end;
end;

procedure TForm1.OpcjeListBox(ListBoxNazwa:TListBox; OpcjaNazwa, Dane:String);
var I   :Integer;
    T   :String;
    Jest:Boolean;
begin //OpcjeListBox - Umieść dane bez powtórzeń na liście komponentu ListBox.
  OpcjaNazwa:= AnsiLowerCase(Trim(OpcjaNazwa));
  Dane:= Trim(Dane);
  T:= '';
  if(OpcjaNazwa <> '') then begin
    if(OpcjaNazwa = AnsiLowerCase(Copy(Dane, 1, Length(OpcjaNazwa)))) then begin
      T:= Trim(Copy(Dane, Length(OpcjaNazwa)+1, Length(Dane)));
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

procedure TForm1.OpcjeComboBoxE(ComboBoxNazwa:TComboBox; OpcjaNazwa, Dane:String);
begin //OpcjeComboBoxE - Umieść dane bez powtórzeń na liście komponentu ComboBox.
  OpcjaNazwa:= AnsiLowerCase(Trim(OpcjaNazwa));
  Dane:= Trim(Dane);
  if(OpcjaNazwa <> '') then begin
    if(OpcjaNazwa = AnsiLowerCase(Copy(Dane, 1, Length(OpcjaNazwa)))) then begin
      ComboBoxNazwa.Text:= Trim(Copy(Dane, Length(OpcjaNazwa)+1, Length(Dane)));
    end;
  end;
end;

procedure TForm1.OpcjeComboBox(ComboBoxNazwa:TComboBox; OpcjaNazwa, Dane:String);
var I   :Integer;
    T   :String;
    Jest:Boolean;
begin //OpcjeComboBox - Umieść dane bez powtórzeń na liście komponentu ComboBox.
  OpcjaNazwa:= AnsiLowerCase(Trim(OpcjaNazwa));
  Dane:= Trim(Dane);
  T:= '';
  if(OpcjaNazwa <> '') then begin
    if(OpcjaNazwa = AnsiLowerCase(Copy(Dane, 1, Length(OpcjaNazwa)))) then begin
      T:= Trim(Copy(Dane, Length(OpcjaNazwa)+1, Length(Dane)));
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

procedure TForm1.OpcjeOdczyt(Str:String);
var Dane:TStringList;
    I   :Integer;
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

procedure TForm1.FormCreate(Sender: TObject);
begin //FormCreate.
  FormShow(Sender);
end;

procedure TForm1.FormShow(Sender: TObject);
begin //FormShow.
   OpcjeOdczyt('opcje.ini');
end;

end.