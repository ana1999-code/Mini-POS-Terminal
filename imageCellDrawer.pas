unit imageCellDrawer;

interface

uses
  Winapi.Windows, System.SysUtils, FireDAC.Comp.Client, Vcl.Grids, Vcl.Graphics,
  Data.DB, System.Classes;

type
  // Class responsible for drawing images inside specific cells of the ProdsGrid
  TProdImageCellDrawer = class
  private
    FProdsGrid: TStringGrid;
    FProdsMemTable: TFDMemTable;
    FImagesFolder: string;
    function LoadImageCell(ACol, ARow: LongInt; APicture: TPicture;
      out AImgWidth, AImgHeight: Integer): Boolean;
    procedure LoadImageFromFile(APicture: TPicture; AName: string;
      out AImgWidth, AImgHeight: Integer);

    function AssignImageFromTable(APicture: TPicture;
      out AImgWidth, AImgHeight: Integer; ARow: Integer): Boolean;
    function CenterImageRect(CellRect: TRect;
      AImgWidth, AImgHeight: Integer): TRect;

  public
    constructor Create(const AProdsGrid: TStringGrid;
      const AProdsMemTable: TFDMemTable; const AImagesFolder: string);
    procedure DrawCell(ACol, ARow: Integer; Rect: TRect);
  end;

implementation

constructor TProdImageCellDrawer.Create(const AProdsGrid: TStringGrid;
  const AProdsMemTable: TFDMemTable; const AImagesFolder: string);
begin
  FProdsGrid := AProdsGrid;
  FProdsMemTable := AProdsMemTable;
  FImagesFolder := AImagesFolder;
end;

// Draws a cell based on column and row
procedure TProdImageCellDrawer.DrawCell(ACol, ARow: Integer; Rect: TRect);
var
  picture: TPicture;
  ImgRect: TRect;
  ImgWidth, ImgHeight: Integer;
begin
  picture := TPicture.Create;
  try
    // Load appropriate image for this cell
    if not LoadImageCell(ACol, ARow, picture, ImgWidth, ImgHeight) then
      Exit;

    // Calculate rectangle to center the image inside the cell
    ImgRect := CenterImageRect(Rect, ImgWidth, ImgHeight);
    // Draw the image into the grid cell
    FProdsGrid.Canvas.StretchDraw(ImgRect, picture.Graphic);
  finally
    picture.Free;
  end;
end;

// Determines which image to load based on column index
function TProdImageCellDrawer.LoadImageCell(ACol, ARow: LongInt;
  APicture: TPicture; out AImgWidth, AImgHeight: Integer): Boolean;
begin
  Result := True;

  case ACol of
    0: // First column shows product image from memTable
      Result := AssignImageFromTable(APicture, AImgWidth, AImgHeight, ARow);
    3: // Fourth column shows 'add' icon
      LoadImageFromFile(APicture, 'add.png', AImgWidth, AImgHeight);
    4: // Fifth column shows 'minus' icon
      LoadImageFromFile(APicture, 'minus.png', AImgWidth, AImgHeight);
  else
    Result := False;
  end;
end;

// Assigns image from the dataset's blob field based on the product name
function TProdImageCellDrawer.AssignImageFromTable(APicture: TPicture;
  out AImgWidth, AImgHeight: Integer; ARow: Integer): Boolean;
var
  productName: string;
  stream: TStream;
begin
  Result := True;
  // Retrieve product name from grid cell in column 1
  productName := FProdsGrid.Cells[1, ARow];

  // Find the corresponding record in the memTable
  if FProdsMemTable.Locate('name', productName, []) then
  begin
    // Create a stream to read the image blob
    stream := FProdsMemTable.CreateBlobStream
      (FProdsMemTable.FieldByName('image'), bmRead);
    try
       // Load the image from stream
      APicture.LoadFromStream(stream);
      AImgWidth := 80;
      AImgHeight := 80;
    finally
      stream.Free;
    end;
  end
  else
    Result := False;
end;

// Loads image from a file
procedure TProdImageCellDrawer.LoadImageFromFile(APicture: TPicture;
  AName: string; out AImgWidth, AImgHeight: Integer);
begin
  APicture.LoadFromFile(FImagesFolder + '\' + AName);
  AImgWidth := 50;
  AImgHeight := 50;
end;

// Centers the image in the given cell rectangle
function TProdImageCellDrawer.CenterImageRect(CellRect: TRect;
  AImgWidth, AImgHeight: Integer): TRect;
begin
  Result.Left := CellRect.Left + (CellRect.Width - AImgWidth) div 2;
  Result.Top := CellRect.Top + (CellRect.Height - AImgHeight) div 2;
  Result.Right := Result.Left + AImgWidth;
  Result.Bottom := Result.Top + AImgHeight;
end;

end.
