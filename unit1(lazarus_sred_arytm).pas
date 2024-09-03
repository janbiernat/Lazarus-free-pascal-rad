unit unit1;
//--== Średnia arytmetyczna ==--
//Copyright (c)by Jan T. Biernat
{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  Buttons, Grids;
type {TForm1}
  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure StringGrid1KeyPress(Sender: TObject; var Key: char);
    procedure StringGrid1PrepareCanvas(sender: TObject; aCol, aRow: Integer;
      aState: TGridDrawState);
  private
    //Deklaracja zmiennych prywatnych.
  public
    //Deklaracja zmiennych globalnych.
    ZG_tKatalog:String;
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
      end else if((T[I] = ',') and (Kropka = false)) then begin
                 Tylko:= Tylko+T[I];
                 Kropka:= true;
               end;
    end;
  end else Tylko:= '';
  TylkoLiczbaR:= Tylko;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FormResize(Sender);
  FormShow(Sender);
  Caption:= 'Średnia arytmetyczna (c)by Jan T. Biernat';
  Application.Title:= Caption;
  //=
    ZG_tKatalog:= '';
    ZG_tKatalog:= AnsiLowerCase(ExtractFilePath(Application.ExeName))+'dane.txt';
end;

procedure TForm1.FormResize(Sender: TObject);
const iWidth = 580;
      iHeight = 480;
begin
  if(Width < iWidth) then Width:= iWidth;
  if(Height < iHeight) then Height:= iHeight;
  with StringGrid1 do begin
    ColWidths[1]:= Width-344;
  end;
end;

procedure TForm1.FormShow(Sender: TObject);
var DaneOdczyt:TStringList;
    I, P, W :Integer;
    S, S1, S2:String;
    L        :Boolean;
begin //FormShow.
  Font.Size:= 13;
  //=
    Edit1.Text:= '';
    Edit2.Text:= Edit1.Text;
    Edit3.Text:= Edit1.Text;
    with StringGrid1 do begin
      FixedCols:= 0; FixedRows:= 1; ColCount:= 3; RowCount:= 2;
      Cells[0, 0]:= #32+'LP'; ColWidths[0]:= 69;
      Cells[1, 0]:= #32+'Opis'; //ColWidths[1]:= 124;
      Cells[2, 0]:= #32+'Wartość/Liczba'; ColWidths[2]:= 199;;
    end;
    //Odczyt danych z pliku tekstowego.
    DaneOdczyt:= TStringList.Create;
    DaneOdczyt.Clear;
    if(FileExists(ZG_tKatalog) = TRUE) then begin
      DaneOdczyt.LoadFromFile(ZG_tKatalog);
      for I:= 0 to DaneOdczyt.Count-1 do begin
        S:= ''; S:= Trim(DaneOdczyt.Strings[I]);
        P:= 0; P:= Pos(';', S);
        S1:= ''; S1:= Trim(Copy(S, 1, P-1));
        S2:= ''; S2:= Trim(Copy(S, P+1, Length(S)));
        L:= FALSE;
        with StringGrid1 do begin
          for W:= 0 to RowCount-2 do begin
            if((AnsiLowerCase(Trim(Cells[1, W+1])) = AnsiLowerCase(S1))
            and (AnsiLowerCase(Trim(Cells[2, W+1])) = S2)) then begin
              L:= TRUE; Break;
            end;
          end;
          if(L = FALSE) then begin
            Cells[1, RowCount-1]:= Trim(S1);
            Cells[2, RowCount-1]:= Trim(S2);
          end;
          if((Trim(Cells[2, RowCount-1])<>'')
          and (Trim(Cells[1, RowCount-1])<>'')) then RowCount:= RowCount+1;
        end;
      end;
    end;
    DaneOdczyt.Destroy;
    SpeedButton2Click(Sender);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  Application.Terminate;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
var I, Numeruj:Integer;
    Suma      :Currency;
    DaneZapisz:TStringList;
begin
  //Oblicz i zapisz dane.
    Numeruj:= 0; Suma:= 0;
    DaneZapisz:= TStringList.Create;
    DaneZapisz.Clear;
    with StringGrid1 do begin
      for I:= 0 to RowCount-2 do begin
        if(Trim(Cells[2, RowCount-1])<>'') then RowCount:= RowCount+1;
        if(Trim(Cells[2, I+1])<>'') then begin
          Cells[2, I+1]:= TylkoLiczbaR(Trim(Cells[2, I+1]), 15,2)+#32;
          Numeruj:= Numeruj+1;
          Suma:= Suma+StrToFloatDef(Trim(Cells[2,I+1]), 0);
          Cells[0, I+1]:= IntToStr(Numeruj)+#32;
          DaneZapisz.Add(Trim(Cells[1, I+1])+';'+Trim(Cells[2, I+1]));
        end;
      end;
    end;
    try FileSetAttr(ZG_tKatalog, faArchive);
        DeleteFile(ZG_tKatalog);
        DaneZapisz.SaveToFile(ZG_tKatalog);
    except
    end;
    DaneZapisz.Destroy;
    Edit1.Text:= FloatToStr(Suma);
    Edit2.Text:= IntToStr(Numeruj);
    if(Numeruj > 0) then Edit3.Text:= FloatToStr(Suma/Numeruj)
    else Edit3.Text:= '?';
end;

procedure TForm1.StringGrid1KeyPress(Sender: TObject; var Key: char);
begin
  if(Key = #13) then SpeedButton2Click(Sender);
end;

procedure TForm1.StringGrid1PrepareCanvas(sender: TObject; aCol, aRow: Integer;
  aState: TGridDrawState);
var TS :TTextStyle;
begin //StringGrid1PrepareCanvas - Ustawienie justowania dla tekstu do prawej strony.
  //Ustawienie wyśrodkowanie zawartości komórek dla wiersza 1.
    if(aRow = 0) then begin
      TS:= TStringGrid(Sender).Canvas.TextStyle;
      TS.Alignment:= taCenter;
      TStringGrid(Sender).Canvas.TextStyle:= TS;
      with StringGrid1.Canvas.Font do begin
        Color:= clBlack; Style:= [fsBold];
      end;
    end;
    //Kolumna "LP" i "Wartość/Liczba".
      if(((aCol = 0) and (aRow > 0))
      or ((aCol = 2) and (aRow > 0))) then begin
        TS:= TStringGrid(Sender).Canvas.TextStyle;
        TS.Alignment := taRightJustify;
        TStringGrid(Sender).Canvas.TextStyle:= TS;
      end;
end;

end.

