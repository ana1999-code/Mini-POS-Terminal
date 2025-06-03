unit formInactivityDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls;

type
  // This form is shown after a period of user inactivity
  // It displays a countdown of 10 seconds warning the user that the shopping cart will be cleared
  // Clicking Cancel stops the countdown and closes the form without clearing the cart
  TfrmInactivityDialog = class(TForm)
    lblCountdown: TLabel;
    countdownTimer: TTimer;
    btnCancel: TButton;
    procedure CountdownTimerTimer(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    FSecondsLeft: Integer;
  public
    Cancelled: Boolean;
    procedure StartCountdown;
  end;

var
  frmInactivityDialog: TfrmInactivityDialog;

implementation

{$R *.dfm}

procedure TfrmInactivityDialog.StartCountdown;
begin
  FSecondsLeft := 10;
  lblCountdown.Caption := 'Clearing cart in ' + IntToStr(FSecondsLeft) +
    ' seconds...';
  countdownTimer.Interval := 1000;
  countdownTimer.Enabled := True;
end;

procedure TfrmInactivityDialog.btnCancelClick(Sender: TObject);
begin
  Cancelled := True;
  countdownTimer.Enabled := False;
  Close;
end;

procedure TfrmInactivityDialog.CountdownTimerTimer(Sender: TObject);
begin
  Dec(FSecondsLeft);
  if FSecondsLeft > 0 then
    lblCountdown.Caption := 'Clearing data in ' + IntToStr(FSecondsLeft) +
      ' seconds...'
  else
  begin
    countdownTimer.Enabled := False;
    Close;
  end;
end;

end.
