unit WMApplication;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics,
  WMView, WMDesktop, WMButton, WMMenu;

type

  { TToolBar }

  TToolBar = class(TView)
    constructor Create; override;
    procedure AddButton(const ACaption: string; ACommand: integer);
  end;

{ TApplication }

type
  TApplication = class(TView)
  private
  public
    Desktop: TDesktop;
    ToolBar: TToolBar;
    MenuBar: TMenuBar;
    MenuBox: array of TMenuBox;
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
  Top := rand;
  Height := rand;
  Anchors := [akLeft, akRight, akTop];
  Caption := 'ToolBar';
end;

procedure TToolBar.AddButton(const ACaption: string; ACommand: integer);
var
  btn: TButton;
begin
  btn := TButton.Create;
  btn.Top := BorderSize;
  btn.Left := Length(View) * 80 + BorderSize;
  btn.Caption := ACaption;
  btn.Command := ACommand;
  Insert(btn);
end;


{ TApplication }

constructor TApplication.Create;
begin
  inherited Create;
  Color := clMaroon;

  Desktop := TDesktop.Create;
  Desktop.Top := rand * 2;
  Desktop.Height := Height - 2 * rand;
  Desktop.Anchors := [akLeft, akRight, akTop, akBottom];
  Desktop.Color := clGreen;
  Desktop.Caption := 'Desktop';
  Insert(Desktop);

  ToolBar := TToolBar.Create;
  Insert(ToolBar);

  MenuBar := TMenuBar.Create;
  MenuBar.Left := 50;
  MenuBar.Top := 5;
  Insert(MenuBar);
end;

//function FindSubMenu(m: TMenuItems; index: integer): Integer;
//var
//  i: integer;
//begin
//  Result:=-1;
//  for i := 0 to Length(m.Items) - 1 do begin
//    if m.Items[i].Index = index then begin
//      Result := i;
//    end;
//  end;
//end;

procedure TApplication.EventHandle(Event: TEvent);
var
  ev: TEvent;
  mItem: TMenuItems;
  index, l: integer;
  menu: TMenu;
begin
  case Event.What of
    whcmCommand: begin
      case Event.Command of
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
    whMenuCommand: begin
      if Event.Index>=0 then begin
      menu := TMenu(Event.Sender);
      mItem := menu.MenuItem.Items[Event.Index];
      if Length(mItem.Items) > 0 then begin
        l := Length(MenuBox);
        SetLength(MenuBox, l + 1);
        MenuBox[l] := TMenuBox.Create;
        MenuBox[l].MenuItem := mItem;
        MenuBox[l].Left := Event.Left;
        MenuBox[l].Top := Event.Top;
        Insert(MenuBox[l]);
      end else begin
        ev.What := whcmCommand;
        ev.Command := mItem.Command;
        EventHandle(ev);
      end;


      WriteLn(mItem.Caption);
      WriteLn('index: ', Event.Index);

      ev.What := whRepaint;
      EventHandle(ev);
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
