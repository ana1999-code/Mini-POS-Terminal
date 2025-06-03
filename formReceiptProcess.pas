unit formReceiptProcess;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.WinXCtrls,
  Vcl.ExtCtrls, Vcl.Imaging.pngimage;

type
  // This form displays a processing indicator (spinner) while a receipt is being printed
  // It shows a spinner animation during the operation and then switches to a success message/image
  // The user can close the form after the process is complete by clicking the Close button
  TfrmProcessing = class(TForm)
    lbProcess: TLabel;
    spnProcessing: TActivityIndicator;
    imgCheck: TImage;
    btnClose: TButton;
    pnlProcess: TPanel;
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmProcessing: TfrmProcessing;

implementation

{$R *.dfm}

procedure TfrmProcessing.btnCloseClick(Sender: TObject);
begin
  Close;
end;

end.
