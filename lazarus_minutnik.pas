unit Unit1;
(*--== Minutnik (Timer) ==--
Copyright (c)by Jan T. Biernat*)
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  MaskEdit, Buttons, Grids;
const SG_iOdleglosc = 100;
type {TForm1}
  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    MaskEdit1: TMaskEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    SpeedButton2: TSpeedButton;
    StringGrid1: TStringGrid;
    Timer1: TTimer;
    procedure Edit1Change(Sender: TObject);
    procedure Edit1Exit(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyPress(Sender: TObject; var Key: char);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure MaskEdit1Change(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure SpeedButton4Click(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure StringGrid1PrepareCanvas(sender: TObject; aCol, aRow: Integer;
      aState: TGridDrawState);
    procedure Timer1Timer(Sender: TObject);
  private
    //Deklaracja zmiennych prywatnych.
  public
    //Deklaracja zmiennych globalnych.
    function StringGridNumeruj(StringGridN:TStringGrid):Integer;
    function StringGridWierszUsun(StringGridN:TStringGrid):Integer;
    function StringGridWierszSprOstatni(StringGridN:TStringGrid):Integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

function WyrazWielkaLitera(T:String):String;
var I:Integer;
    S:String;
begin //WyrazWielkaLitera- Każdy wyraz zaczyna się Wielką Literą.
  I:= 0; S:= '';
  T:= AnsiLowerCase(Trim(T));
  if(T <> '') then begin
    for I:= 1 to Length(T) do begin
      if(((T[I-1] = ' ') and (T[I] <> ' '))
      or ((T[I-1] = '-') and (T[I] <> ' '))) then begin
        S:= S+AnsiUpperCase(T[I]);
      end else S:= S+T[I];
    end;
    Result:= AnsiUpperCase(T[1])+Copy(S, 2, Length(S));
  end else Result:= S;
end;

function ZeroPrzed(Str :String):String;
begin
  if(Length(Str) = 1) then ZeroPrzed:= '0'+Str
  else ZeroPrzed:= Str;
end;
function Minutnik(Str:String):String;
var G, M, S:Shortint;
begin //Minutnik - Odliczaj czas w tył.
  Str:= Trim(Str);
  if(Str <> '') then begin
    G:= 0; G:= StrToIntDef(Copy(Str, 1, 2), 0);
    M:= 0; M:= StrToIntDef(Copy(Str, 4, 2), 0);
    S:= 0; S:= StrToIntDef(Copy(Str, 7, 2), 0);
    if(S = 0) then begin
      S:= 59;
      if(M = 0) then begin
        M:= 59;
        if(G = 0) then begin
          G:= 23;
        end else G:= G-1;
      end else M:= M-1;
    end else S:= S-1;
    Minutnik:= ZeroPrzed(IntToStr(G))+':'+
               ZeroPrzed(IntToStr(M))+':'+
               ZeroPrzed(IntToStr(S));
  end else Minutnik:= '?';
end;

function CzasSpr(Czas:String):String;
var G, M, S:Shortint;
begin //CzasSpr - Sprawdź, czy czas został prawidłowo napisany.
  Czas:= Trim(Czas);
  if((Czas <> '') and (Length(Czas) = 8)) then begin
    G:= 0; G:= StrToIntDef(Copy(Czas, 1, 2), 0);
    M:= 0; M:= StrToIntDef(Copy(Czas, 4, 2), 0);
    S:= 0; S:= StrToIntDef(Copy(Czas, 7, 2), 0);
    if((G < 0) or (G > 23)) then G:= -1;
    if((M < 0) or (M > 59)) then M:= -1;
    if((S < 0) or (S > 59)) then S:= -1;
    if((G > -1) and (M > -1) and (S > -1)) then Result:= Czas
    else Result:= '';
  end else Result:= '';
end;

function TForm1.StringGridNumeruj(StringGridN:TStringGrid):Integer;
var I, L:Integer;
begin //StringGridNumeruj - Numerowanie wierszy.
  L:= 0;
  with StringGridN do begin
    for I:= 0 to RowCount-2 do begin
      if(Trim(Cells[1, I+1])<>'') then begin
        L:= L+1; Cells[0, I+1]:= char(32)+IntToStr(L)+char(32);
      end;
    end;
  end;
  Result:= L;
end;

function TForm1.StringGridWierszUsun(StringGridN:TStringGrid):Integer;
var A, B, C:Integer;
begin //StringGridWierszUsun - Usuwa wybrany wiersz.
  A:= 0; B:= 0; C:= 0;
  with StringGridN do begin
    if(Row > -1) then begin
      for C:= 0 to ColCount-1 do Cells[C, Row]:= '';
      for A:= Row to RowCount-2 do begin
        for B:= 0 to ColCount-1 do begin
          Cells[B, A]:= #32+Trim(Cells[B, 1+A]);
        end;
      end;
      RowCount:= RowCount-1;
    end;
    Result:= RowCount;
  end;
end;

function TForm1.StringGridWierszSprOstatni(StringGridN:TStringGrid):Integer;
var I:Integer;
begin //StringGridWierszSprOstatni - Sprawdź, czy ostatni wiersz jest pusty.
  I:= 0;
  with StringGridN do begin
    for I:= ColCount-1 downto 0 do begin
      if(Cells[I, RowCount-1] <> '') then begin
        RowCount:= RowCount+1; Break;
      end;
    end;
    Result:= RowCount;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin //FormCreate - Zdarzenie wykonywane w momencie uruchomienia aplikacji (umieszcza się tutaj najczęściej inicjujące wartości początkowe).
  FormResize(Sender);
  Caption:= 'Minutnik (c)by Jan T. Biernat';
  Application.Title:= Caption;
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin //Edit1Change - Zdarzenie wykonywane jest w momencie, gdy zmienia się zawartość komponentu "Edit1".
  if((Trim(Edit1.Text)<>'') and (Length(MaskEdit1.Text) = 8)) then
    SpeedButton1.Enabled:= TRUE
  else SpeedButton1.Enabled:= FALSE;
  with MaskEdit1 do begin
    if(CzasSpr(Text)<>'') then Color:= clWhite else Color:= clRed;
  end;
end;

procedure TForm1.Edit1Exit(Sender: TObject);
begin //Edit1Exit - Zdarzenie wykonywane jest w momencie, gdy aktywność przechodzi na inny komponent (czyli w momencie wychodzenia z komponentu "Edit1").
  Edit1.Text:= WyrazWielkaLitera(Edit1.Text);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin //FormDestroy - Zdarzenie wykonywane jest w momencie zamykania aplikacji.
  Timer1.Enabled:= FALSE;
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: char);
begin //FormKeyPress - Zdarzenie wykonywane jest w momencie naciśnięcia dowolnego klawisza na klawiaturze.
  if(Key = #13) then SpeedButton1Click(Sender);
end;

procedure TForm1.FormResize(Sender: TObject);
const iWidth = 1024; iHeight = 400;
begin //FormResize - Zdarzenie wykonywane jest w momencie zmiany rozmiaru głównego okna aplikacji.
  if(iWidth > Width) then Width:= iWidth;
  if(iHeight > Height) then Height:= iHeight;
  //=
    with StringGrid1 do begin
      ColWidths[1]:= Form1.ClientWidth-(ColWidths[0]+ColWidths[2]+SG_iOdleglosc);
    end;
    with SpeedButton4 do begin
      Left:= Panel2.Width-(Width+99);
    end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin //FormShow - Zdarzenie wykonywane jest w momencie wyświetlania okna głównego aplikacji (umieszcza się tutaj najczęściej inicjujące wartości początkowe).
  Font.Size:= 13;
  //=
    Edit1.Text:= '';
    MaskEdit1.Text:= '';
    with StringGrid1 do begin
      Font.Size:= 26; FixedCols:= 0; FixedRows:= 1;
      ColCount:= 3; RowCount:= 3;
      ColWidths[0]:= 99; Cells[0, 0]:= char(32)+'LP';
      ColWidths[1]:= 400; Cells[1, 0]:= char(32)+'Nazwisko i imię';
      ColWidths[2]:= 300; Cells[2, 0]:= char(32)+'Odliczanie';
      Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goRowSelect,goSmoothScroll];
      StringGrid1.ColWidths[1]:= Form1.ClientWidth-(ColWidths[0]+ColWidths[2]+SG_iOdleglosc);
    end;
    SpeedButton2Click(Sender);
    StringGridWierszSprOstatni(StringGrid1);
    StringGridNumeruj(StringGrid1);
    StringGrid1Click(Sender);
    Timer1.Enabled:= FALSE;
    Edit1Change(Sender);
    try Edit1.SetFocus;
    finally
    end;
end;

procedure TForm1.MaskEdit1Change(Sender: TObject);
begin //MaskEdit1Change - Zdarzenie wykonywane jest w momencie, gdy zmienia się zawartość komponentu "MaskEdit1".
  Edit1Change(Sender);
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin //SpeedButton1Click - Dodaj nowy element do listy.
      //                    Zdarzenie zostanie wykonane w momencie kliknięcia
      //                    lewym klawiszem myszy na komponencie "SpeedButton1".
  if((Trim(Edit1.Text)<>'') and (Length(MaskEdit1.Text) = 8)
  and (CzasSpr(MaskEdit1.Text)<>'')) then begin
    with StringGrid1 do begin
      Cells[1, RowCount-1]:= #32+Trim(Edit1.Text);
      Cells[2, RowCount-1]:= #32+Trim(MaskEdit1.Text);
    end;
    Edit1.Text:= ''; MaskEdit1.Text:= '';
    Edit1.SetFocus;
  end;
  Edit1Change(Sender);
  StringGridWierszSprOstatni(StringGrid1);
  StringGridNumeruj(StringGrid1);
  StringGrid1Click(Sender);
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
const Ile = 2;
      NiI:array[0..Ile] of string = ('Kowalski Jan', 'Kanapka Krzysztof', 'Masło Katarzyna');
      Czas:array[0..Ile] of string = ('01:00:00', '00:00:10', '00:01:00');
var I:Integer;
begin //SpeedButton2Click - Wprowadź przykładowe dane.
  Timer1.Enabled:= FALSE;
  with StringGrid1 do begin
    RowCount:= 3;
    for I:= 0 to Ile do begin
      Cells[0, 1+I]:= char(32)+IntToStr(1+I)+char(32);
      Cells[1, 1+I]:= char(32)+NiI[I];
      Cells[2, 1+I]:= Czas[I];
      StringGridWierszSprOstatni(StringGrid1);
      StringGridNumeruj(StringGrid1);
    end;
  end;
  StringGridWierszSprOstatni(StringGrid1);
  StringGridNumeruj(StringGrid1);
end;

procedure TForm1.SpeedButton3Click(Sender: TObject);
begin //SpeedButton3Click - Włącz minutnik.
  Timer1Timer(Sender);
end;

procedure TForm1.SpeedButton4Click(Sender: TObject);
begin //SpeedButton4Click - Wykonaj zdarzenie w momencie kliknięcia na komponent.
  with StringGrid1 do begin
    if((Trim(Cells[0, Row])<>'')
    and (Trim(Cells[1, Row])<>'')
    and (Trim(Cells[2, Row])<>'')) then begin
      StringGridWierszUsun(StringGrid1);
      RowCount:= RowCount-1;
    end;
  end;
  StringGridWierszSprOstatni(StringGrid1);
  StringGridNumeruj(StringGrid1);
  StringGrid1Click(Sender);
end;

procedure TForm1.StringGrid1Click(Sender: TObject);
begin //StringGrid1Click - Wykonaj zdarzenie w momencie kliknięcia na komponent.
  with StringGrid1 do begin
    if((Trim(Cells[0, Row])<>'')
    and (Trim(Cells[1, Row])<>'')
    and (Trim(Cells[2, Row])<>'')) then begin
      SpeedButton4.Enabled:= TRUE;
    end else begin
               SpeedButton4.Enabled:= FALSE;
             end;
  end;
end;

procedure TForm1.StringGrid1PrepareCanvas(sender: TObject; aCol, aRow: Integer;
  aState: TGridDrawState);
var TS:TTextStyle;
begin //StringGrid1PrepareCanvas - Formatowanie zawartości komórek.
  //Ustawienie wyśrodkowanie zawartości komórek dla wiersza 1.
    if(aRow = 0) then begin
      TS:= TStringGrid(Sender).Canvas.TextStyle;
      TS.Alignment:= taCenter;
      TStringGrid(Sender).Canvas.TextStyle:= TS;
      with StringGrid1.Canvas.Font do begin
        Color:= clBlack; Style:= [fsBold];
      end;
    end;
  //Kolumna "LP".
    if((aCol = 0) and (aRow > 0)) then begin
      TS:= TStringGrid(Sender).Canvas.TextStyle;
      TS.Alignment:= taRightJustify;
      TStringGrid(Sender).Canvas.TextStyle:= TS;
    end;
  //Kolumna "Odliczanie".
    if((aCol = 2) and (aRow > 0)) then begin
      TS:= TStringGrid(Sender).Canvas.TextStyle;
      TS.Alignment:= taCenter;
      TStringGrid(Sender).Canvas.TextStyle:= TS;
    end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var I:Integer;
begin //Timer1Timer - Wywołuj poniższe instrukcje, co jakiś czas (z góry określony).
  with Timer1 do begin
    Interval:= 1000; Enabled:= TRUE;
  end;
  //=
    with StringGrid1 do begin
      for I:= 0 to RowCount-3 do begin
        if((Trim(Cells[0, (I+1)])<>'')
        and (Trim(Cells[1, (I+1)])<>'')
        and (Trim(Cells[2, (I+1)])<>'00:00:00')) then Cells[2, (I+1)]:= Minutnik(Cells[2, (I+1)]);
      end;
    end;
end;

end.