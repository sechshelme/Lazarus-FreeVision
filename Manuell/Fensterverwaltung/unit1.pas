unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TView }

  TView = class(TObject)
  private
    Canvas: TCanvas;
    A, B: TPoint;
    FCaption: string;
    FColor: TColor;
    procedure SetCaption(AValue: string);
    procedure SetColor(AValue: TColor);
  public
    property Caption: string read FCaption write SetCaption;
    property Color: TColor read FColor write SetColor;
    constructor Create(c: TCanvas);
    procedure Assign(AX, AY, BX, BY: integer);
    procedure Move(x, y: integer);
    procedure Draw;
    function iSClick(x, y: integer): boolean;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Buttonup: TButton;
    Buttonminus: TButton;
    Buttonleft: TButton;
    Buttonright: TButton;
    Buttonplus: TButton;
    Buttondown: TButton;
    Panel1: TPanel;
    procedure ButtonminusClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
  private
    Views: array of TView;
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TView }

procedure TView.SetCaption(AValue: string);
begin
  if FCaption = AValue then begin
    Exit;
  end;
  FCaption := AValue;
end;

procedure TView.SetColor(AValue: TColor);
begin
  if FColor = AValue then begin
    Exit;
  end;
  FColor := AValue;
end;

constructor TView.Create(c: TCanvas);
begin
  Canvas := c;
end;

procedure TView.Assign(AX, AY, BX, BY: integer);

  procedure swap(var a: integer; var b: integer);
  var
    c: integer;
  begin
    if a > b then begin
      c := a;
      a := b;
      b := c;
    end;
  end;

begin
  swap(AX, BX);
  swap(AY, BY);
  A.X := AX;
  A.Y := AY;
  B.X := BX;
  B.Y := BY;
end;

procedure TView.Move(x, y: integer);
begin
  Inc(A.X, x);
  Inc(A.Y, y);
  Inc(B.X, x);
  Inc(B.Y, y);
end;

procedure TView.Draw;
begin
  Canvas.Brush.Color := FColor;
  Canvas.Rectangle(A.X, A.Y, B.X, B.Y);
  Canvas.TextOut(A.X, A.Y, Caption);
end;

function TView.iSClick(x, y: integer): boolean;
begin
  Result := (x >= A.X) and (y >= A.Y) and (x <= B.X) and (y <= B.Y);
end;

{ TForm1 }

procedure TForm1.ButtonminusClick(Sender: TObject);
var
  v: TView;
begin
  if Length(Views) > 0 then begin
    case TButton(Sender).Name of
      'Buttonminus': begin
        Views[0].Free;
        Delete(Views, 0, 1);
      end;
      'Buttonplus': begin
        v := TView.Create(Panel1.Canvas);
        v.Assign(Random(Width), Random(Height), Random(Width), Random(Height));
        v.Color := Random($FFFFFF);
        v.Caption := IntToStr(Length(Views));
        Insert(v, Views, 0);
      end;
      'Buttonleft': begin
        Views[0].Move(-8, 0);
      end;
      'Buttonright': begin
        Views[0].Move(8, 0);
      end;
      'Buttonup': begin
        Views[0].Move(0, -8);
      end;
      'Buttondown': begin
        Views[0].Move(0, 8);
      end;
    end;
    Repaint;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: integer;
begin
  Randomize;
  SetLength(Views, 10);
  for i := 0 to Length(Views) - 1 do begin
    Views[i] := TView.Create(Panel1.Canvas);
    with Panel1 do begin
      Views[i].Assign(Random(Width), Random(Height), Random(Width), Random(Height));
    end;
    Views[i].Color := Random($FFFFFF);
    Views[i].Caption := IntToStr(i);
  end;
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to Length(Views) - 1 do begin
    Views[i].Free;
  end;
end;

procedure TForm1.FormPaint(Sender: TObject);
var
  i: integer;
begin
  for i := Length(Views) - 1 downto 0 do begin
    Views[i].Draw;
  end;
end;

procedure TForm1.Panel1Click(Sender: TObject);
var
  i, x, y: integer;
  m: TPoint;
  v: TView;
begin

  m := Panel1.ScreenToClient(Mouse.CursorPos);
  x := m.X;
  y := m.Y;

  i := 0;
  while i < Length(Views) do begin
    if Views[i].iSClick(x, y) then begin
      Caption := Length(Views).ToString();
      v := Views[i];
      Delete(Views, i, 1);
      Insert(v, Views, 0);
      Repaint;
      Exit;
    end else begin
      Caption := x.ToString + '  ' + y.ToString + '  ' + i.ToString + ' False';
    end;
    Inc(i);
  end;
end;

end.
