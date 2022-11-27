unit unit1;
{--== StringGrid ==--
 Copyright (c)by Jan T. Biernat
}
{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Grids;

type { TForm1 }
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    StringGrid1: TStringGrid;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    //Private declaration
  public
    function StringGridSzukaj(StringGridN:TStringGrid; Kol:Integer; Str:String):String;
    function StringGridNumeruj(StringGridN:TStringGrid):Integer;
    function StringGridWierszWstawNowy(StringGridN:TStringGrid):Integer;
    function StringGridWierszUsun(StringGridN:TStringGrid):Integer;
    function StringGridWierszSprOstatni(StringGridN:TStringGrid):Integer;
    procedure StringGridWierszWyczysc(StringGridN:TStringGrid; NrWiersza:Integer);
    function StringGridKolumnaWstawNowy(StringGridN:TStringGrid):Integer;
    function StringGridKolumnaUsun(StringGridN:TStringGrid):Integer;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

function TForm1.StringGridSzukaj(StringGridN:TStringGrid; Kol:Integer; Str:String):String;
var I:Integer;
    T:String;
begin //StringGridSzukaj - Wyszukaj dane w wybranej komórce.
  Str:= AnsiLowerCase(Trim(Str));
  with StringGridN do begin
    Col:= Kol; Row:= 1; CellRect(Col, Row);
    if(Str <> '') then begin
      for I:= 0 to RowCount-2 do begin
        T:= ''; T:= AnsiLowerCase(Trim(Cells[Col, 1+I]));
        if(Copy(T, 1, Length(Str)) = Str) then begin
          Row:= 1+I; CellRect(Col, Row); Result:= Cells[Col, 1+I]; Break;
        end;
      end;
    end else Result:= '';
  end;
end;

function TForm1.StringGridNumeruj(StringGridN:TStringGrid):Integer;
var I, L:Integer;
begin //StringGridNumeruj - Numerowanie wierszy.
  L:= 0;
  with StringGridN do begin
    for I:= 0 to RowCount-2 do begin
      if(Trim(Cells[1, I+1])<>'') then begin
        L:= L+1; Cells[0, I+1]:= IntToStr(L);
      end;
    end;
  end;
  Result:= L;
end;

function TForm1.StringGridWierszWstawNowy(StringGridN:TStringGrid):Integer;
var A, B, C:Integer;
begin //StringGridWierszWstawNowy - Wstawia nowy wiersz.
  A:= 0; B:= 0; C:= 0;
  with StringGridN do begin
    for A:= RowCount-2 downto Row do begin
      for B:= ColCount-1 downto 0 do begin
        Cells[B, 1+A]:= Trim(Cells[B, A]);
      end;
    end;
    for C:= ColCount-1 downto 0 do Cells[C, Row]:= '';
    RowCount:= RowCount+1;
    Result:= RowCount;
  end;
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
          Cells[B, A]:= Trim(Cells[B, 1+A]);
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

procedure TForm1.StringGridWierszWyczysc(StringGridN:TStringGrid; NrWiersza:Integer);
var A, B:Integer;
begin //StringGridWierszWyczysc - Wyczyść cała komponent.
  A:= 0; B:= 0;
  if(NrWiersza < 0) then NrWiersza:= 0;
  with StringGridN do begin
    for B:= RowCount-1 downto NrWiersza do begin
      for A:= 0 to ColCount-1 do Cells[A, B]:= '';
    end;
  end;
end;

function TForm1.StringGridKolumnaWstawNowy(StringGridN:TStringGrid):Integer;
var A, B, C:Integer;
begin //StringGridKolumnaWstawNowy - Wstaw nową kolumnę.
  A:= 0; B:= 0; C:= 0;
  with StringGridN do begin
    for A:= ColCount-2 downto Col do begin
      for B:= 0 to RowCount-1 do begin
        Cells[1+A, B]:= Trim(Cells[A, B]);
      end;
    end;
    for C:= 0 to RowCount-1 do Cells[Col, C]:= '';
    ColCount:= ColCount+1;
    Result:= ColCount;
  end;
end;

function TForm1.StringGridKolumnaUsun(StringGridN:TStringGrid):Integer;
var A, B, C:Integer;
begin //StringGridKolumnaUsun - Usuń kolumnę.
  A:= 0; B:= 0; C:= 0;
  with StringGridN do begin
    for C:= 0 to RowCount-1 do Cells[Col, C]:= '';
    for A:= Col to ColCount-2 do begin
      for B:= 0 to RowCount-1 do begin
        Cells[A, B]:= Trim(Cells[1+A, B]);
      end;
    end;
    ColCount:= ColCount-1;
    Result:= ColCount;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin //FormCreate.
  Edit1.Text:= '';
  Button1.Caption:= 'Wiersz: Wstaw';
  Button2.Caption:= 'Wiersz: Usuń';
  Button3.Caption:= 'Kolumna: Wstaw';
  Button4.Caption:= 'Kolumna: Usuń';
  Button5.Caption:= 'Wyczyść';
  Button6.Caption:= 'Wyczyść 2';
  Button7.Caption:= 'Wiersz ostatni jest pusty?';
  Button8.Caption:= 'LP, Numeruj';
  with StringGrid1 do begin
    FixedRows:= 1; FixedCols:= 0;
    RowCount:= 6; ColCount:= 6;
    Options:= [goFixedVertLine,goFixedHorzLine,goVertLine,goHorzLine,goDrawFocusSelected,goSmoothScroll];
    //Tytuły kolumn.
      Cells[0, 0]:= 'Nazwisko';
      Cells[1, 0]:= 'Imię';
      Cells[2, 0]:= 'Miasto';
      Cells[3, 0]:= 'Adres';
      Cells[4, 0]:= 'Telefon';
    //Dane.
      Cells[0, 1]:= 'Biernat';
      Cells[1, 1]:= 'Jan';
      Cells[2, 1]:= 'Szczecin';
      Cells[3, 1]:= 'Pomorska 44';
      Cells[4, 1]:= '(045)822-54-87';

      Cells[0, 2]:= 'Ogórek';
      Cells[1, 2]:= 'Mirek';
      Cells[2, 2]:= 'Bielsko-Biała';
      Cells[3, 2]:= 'Zachlapana 41';
      Cells[4, 2]:= 'Brak';

      Cells[0, 3]:= 'Kanapka';
      Cells[1, 3]:= 'Irek';
      Cells[2, 3]:= 'Bielsko-Biała';
      Cells[3, 3]:= 'Zakręcona 65';
      Cells[4, 3]:= '0-700-876-876';

      Cells[0, 5]:= 'Sałatka';
      Cells[1, 5]:= 'Tadeusz';
      Cells[2, 5]:= 'Żywiec';
      Cells[3, 5]:= 'Górska 165a';
      Cells[4, 5]:= '0-777-876-876';

    //Wyświetlenie ilości wierszy i kolumn.
      Form1.Caption:= 'Wierszy: '+CHR(32)+IntToStr(RowCount)
                     +', Kolumn: '+CHR(32)+IntToStr(ColCount);
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  Caption:= IntToStr(StringGridWierszWstawNowy(StringGrid1));
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  Caption:= IntToStr(StringGridWierszUsun(StringGrid1));
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  Caption:= IntToStr(StringGridKolumnaWstawNowy(StringGrid1));
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  Caption:= IntToStr(StringGridKolumnaUsun(StringGrid1));
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  StringGridWierszWyczysc(StringGrid1, 0);
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
  StringGridWierszWyczysc(StringGrid1, StrToIntDef(Edit1.Text, 0));
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  Caption:= IntToStr(StringGridWierszSprOstatni(StringGrid1));
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  StringGrid1.Cells[0, 0]:= 'LP';
  Caption:= IntToStr(StringGridNumeruj(StringGrid1));
end;

procedure TForm1.Edit1Change(Sender: TObject);
begin
  Caption:= '['+StringGridSzukaj(StringGrid1, 3, Edit1.Text)+']';
end;

end.