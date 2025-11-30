unit unit1;
(*--== Kalendarz miesięczny ==--
  Copyright (c)by Jan T. Biernat
  =
  Legenda:
  * Now - Zwraca aktualną datę i godzinę.
  * FormatDateTime('YYYY-MM-dd', ZW_Data)
    Funkcja zwraca datę systemową w formacie Rok-Miesiąc-Dzień.
  * YearOf(Now) - Funkcja zwraca bieżący rok.
  * MonthOf(Now); - Funkcja zwraca nr bieżącego miesiąca.
  * DayOf(Now); - Funkcja zwraca nr bieżącego dnia.
  * DaysInMonth(Now) - Funkcja zwraca ilość dni bieżącego miesiąca.
  * StartOfTheMonth(Now); - FUnkcja zwraca 1 dzień bieżącego miesiąca.
  * DayOfWeek() - Zwraca nr dnia w tygodniu dla bieżącego miesiąca.
                  Zwracany nr dnia to: 1 - niedziela
                                       2 - poniedziałek
                                       3 - wtorek
                                       4 - środa
                                       5 - czwartek
                                       6 - piątek
                                       7 - sobota
  * FormatDateTime('dddd', Now) - Funkcja zwraca pełną nazwę dnia.
*)
{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls, Grids, DateUtils;

type {TForm1}
  TForm1 = class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    StringGrid1k: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure StringGrid1kPrepareCanvas(Sender: TObject; aCol, aRow: Integer;
      aState: TGridDrawState);
  private
    //Prywatne deklaracje
    ZW_Data:TDateTime;
    procedure StringGridKalendarzMiesieczny(StrGridN:TStringGrid; Data:TDateTime);
  public
    //Publiczne deklaracje
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{TForm1}

function DataPelna(Str:String):String;
const NazwyMiesiecyP:array[1..12] of string = ('stycznia', 'lutego', 'marca'
                                             , 'kwietnia', 'maja', 'czerwca'
                                             , 'lipca', 'sierpnia', 'września'
                                             , 'października', 'listopada', 'grudnia');
var M:Shortint;
begin //DataPelna: Wyświetl pełną datę (tj. 12 października 2025r.).
  M:= 0; M:= StrToIntDef(Copy(Str, 6, 2), 1);
  //Pokaż datę dzisiejszą i bieżący czas.
    Result:= Copy(Str, 9, 2)
            +' '+NazwyMiesiecyP[M]
            +' '+Copy(Str, 1, 4)+'r.';
end;

procedure TForm1.StringGridKalendarzMiesieczny(StrGridN:TStringGrid; Data:TDateTime);
var Rok, Miesiac, NrDnia :Word;
    IloscDni, NrDniaWmies:Word;
    LiczDni, Kol, Wier   :Integer;
begin
  Rok:= 0; Miesiac:= 0; NrDnia:= 0;
  IloscDni:= 0; NrDniaWmies:= 0;
  Kol:= 0; Wier:= 0; LiczDni:= 0;
  //
  //Wyświetl datę w komponencie "Label1".
    Label1.Caption:= DataPelna(FormatDateTime('YYYY-MM-dd', ZW_Data));
  //
  //Przypisanie wartości do zmiennych.
    Rok:= YearOf(Data);
    Miesiac:= MonthOf(Data);
    NrDnia:= DayOf(Data);
    IloscDni:= DaysInMonth(Data);
  //
  //Wyczyść komponent "StringGrid".
    for Wier := StrGridN.RowCount-1 downto 1 do
      for Kol := 0 to StrGridN.ColCount-1 do StrGridN.Cells[Kol, Wier]:= '';
  //
  //Ustalenie 1 dnia miesiąca.
    NrDniaWmies:= DayOfWeek(StartOfTheMonth(Data))-1;
    if(NrDniaWmies = 0) then NrDniaWmies:= 7;
  //
  //Wypełnienie kalendarza.
    Wier:= 0; Wier:= 1;
    Kol:= 0; Kol:= NrDniaWmies-1;
    LiczDni:= 1;
    while (LiczDni <= IloscDni) do begin
      StrGridN.Cells[Kol, Wier] := IntToStr(LiczDni)+#32;
      LiczDni:= LiczDni+1;
      Kol:= Kol+1;
      if(Kol > 6) then begin
        Kol:= 0; Wier:= Wier+1;
      end;
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var I:Integer;
begin
  Caption:= 'Kalendarz miesięczny';
  //=
    I:= 0;
    Font.Size:= 13;
    with StringGrid1k do begin
      ColCount:= 7; RowCount:= 7;
      //Szerokość kolumn
        for I:= 0 to ColCount-1 do ColWidths[I]:= 50;
      //Nagłówki dni tygodnia
        Cells[0, 0]:= Copy('Poniedziałek', 1, 2);
        Cells[1, 0]:= Copy('Wtorek', 1, 2);
        Cells[2, 0]:= Copy('Środa', 1, 3);
        Cells[3, 0]:= Copy('Czwartek', 1, 2);
        Cells[4, 0]:= Copy('Piątek', 1, 2);
        Cells[5, 0]:= Copy('Sobota', 1, 2);
        Cells[6, 0]:= Copy('Niedziela', 1, 2);
    end;
    ZW_Data:= Now;
    StringGridKalendarzMiesieczny(StringGrid1k, ZW_Data);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin //SpeedButton1: Rok poprzedni.
  ZW_Data:= IncYear(ZW_Data, -1);
  StringGridKalendarzMiesieczny(StringGrid1k, ZW_Data);
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin //SpeedButton2: Rok następny.
  ZW_Data:= IncYear(ZW_Data, 1);
  StringGridKalendarzMiesieczny(StringGrid1k, ZW_Data);
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin //SpeedButton3: Miesiąc poprzedni.
  ZW_Data:= IncMonth(ZW_Data, -1);
  StringGridKalendarzMiesieczny(StringGrid1k, ZW_Data);
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin //SpeedButton4: Miesiąc następny.
  ZW_Data:= IncMonth(ZW_Data, 1);
  StringGridKalendarzMiesieczny(StringGrid1k, ZW_Data);
end;

procedure TForm1.StringGrid1kPrepareCanvas(Sender: TObject; aCol, aRow: Integer;
  aState: TGridDrawState);
var TS:TTextStyle;
begin
  with StringGrid1k do begin
    //Nagłówek kolumnowy
      if((Trim(Cells[0, aRow]) <> '') and (aRow = 0)) then begin
        TS.Alignment := taCenter;
        TStringGrid(Sender).Canvas.TextStyle:= TS;
        Canvas.Font.Color:= clBlack;
        Canvas.Font.Style:= [fsBold];
        if(aCol = 6) then Canvas.Font.Color:= clRed;   //Ustaw kolor czerwony dla niedzieli.
        if(aCol = 5) then Canvas.Font.Color:= clGreen; //Ustaw kolor zielony dla soboty.
      end;
    //Kolumna "LP".
      if(aRow > 0) then begin
        TS:= TStringGrid(Sender).Canvas.TextStyle;
        TS.Alignment := taRightJustify;
        TStringGrid(Sender).Canvas.TextStyle:= TS;
        Canvas.Font.Color:= clBlack;
      end;
  end;
end;

end.

