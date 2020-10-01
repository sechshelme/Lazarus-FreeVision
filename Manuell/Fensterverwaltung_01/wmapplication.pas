unit WMApplication;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics,
  WMView, WMDesktop, WMButton;

type

  { TToolBar }

  TToolBar = class(TView)
    constructor Create; override;
    procedure AddButton(const ACaption:String;ACommand:Integer);
  end;

{ TApplication }

type
  TApplication = class(TView)
  private
  public
    Desktop: TDesktop;
    ToolBar: TToolBar;

    constructor Create; override;
    procedure EventHandle(Event: TEvent); override;
  end;

implementation

uses
  Unit1;  //????????????????????????????????????????????'''''

const
  rand = 40;

{ TToolBar }

constructor TToolBar.Create;
begin
  inherited Create;
  Color := clGray;
  Top := 0;
  Height := rand;
  Anchors := [akLeft, akRight, akTop];
  Caption := 'ToolBar';
end;

procedure TToolBar.AddButton(const ACaption: String; ACommand: Integer);
var
  btn:TButton;
begin
  btn:=TButton.Create;
  btn.Top:=BorderSize;
  btn.Left:=Length(View)*80+BorderSize;
  btn.Caption:=ACaption;
  btn.Command:=ACommand;
  Insert(btn);
end;


{ TApplication }

constructor TApplication.Create;
begin
  inherited Create;
  Color := clMaroon;

  Desktop := TDesktop.Create;
  Desktop.Top := rand;
  Desktop.Height := Height - 2 * rand;
  Desktop.Anchors := [akLeft, akRight, akTop, akBottom];
  Desktop.Color := clGreen;
  Desktop.Caption := 'Desktop';
  Insert(Desktop);

  ToolBar := TToolBar.Create;
  Insert(ToolBar);
end;

procedure TApplication.EventHandle(Event: TEvent);
var
  ev: TEvent;
begin
  case Event.What of
    whcmCommand: begin
      case Event.Value0 of
        cmQuit: begin
          Form1.Close;
        end;
        cmClose: begin
          Desktop.Delete(nil);
          ev.What := whRepaint;
          EventHandle(ev);
        end;
      end;
    end;
    whRepaint: begin
      Draw;
      DrawBitmap(Form1.Canvas);
    end;
    else begin
    end;
  end;
  inherited EventHandle(Event);
end;

end.




