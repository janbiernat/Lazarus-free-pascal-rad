  TForm1 = class(TForm)
    Edit1: TEdit;
    Label1: TLabel;
    SpeedButton1: TSpeedButton;
    StringGrid1: TStringGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    //Private declaration.
  public
    function StringGridSzukaj(Nazwa :TStringGrid; Kol :Integer; Str :String):String;
  end;
//-
function TForm1.StringGridSzukaj(Nazwa :TStringGrid; Kol :Integer; Str :String):String;
var I :Integer;
    T :String;
begin //StringGridSzukaj - Wyszukaj dane w wybranej komórce.
  Str:= AnsiLowerCase(Trim(Str));
  with Nazwa do begin
    Col:= Kol; Row:= 1; CellRect(Col, Row);
    if(Str <> '') then begin
      for I:= 0 to RowCount-2 do begin
        T:= ''; T:= AnsiLowerCase(Trim(Cells[Col, 1+I]));
        if(Copy(T, 1, Length(Str)) = Str) then begin
          Row:= 1+I; CellRect(Col, Row); Result:= Cells[Col, 1+I]; Break;
        end;
      end;
    end else Result:= '?';
  end;
end;