program miniPOSTerminal;

uses
  Vcl.Forms,
  formPOSTerminal in 'formPOSTerminal.pas' {formProds},
  csvProductLoader in 'csvProductLoader.pas',
  jsonPrinter in 'jsonPrinter.pas',
  cartService in 'cartService.pas',
  imageCellDrawer in 'imageCellDrawer.pas',
  formReceiptProcess in 'formReceiptProcess.pas' {frmProcessing},
  formOpenFileDialogOnFileError in 'formOpenFileDialogOnFileError.pas' {frmOpenDialog},
  formInactivityDialog in 'formInactivityDialog.pas' {frmInactivityDialog},
  printer in 'printer.pas',
  logger in 'logger.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TformProds, formProds);
  Application.CreateForm(TfrmProcessing, frmProcessing);
  Application.CreateForm(TfrmOpenDialog, frmOpenDialog);
  Application.CreateForm(TfrmInactivityDialog, frmInactivityDialog);
  Application.Run;
end.
