unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  ExtDlgs, Menus, Windows, math;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit7: TEdit;
    Edit8: TEdit;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem12: TMenuItem;
    MenuItem13: TMenuItem;
    MenuItem14: TMenuItem;
    MenuItem15: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    Separator1: TMenuItem;
    OpenDialog1: TOpenDialog;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Label7Click(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure MenuItem10Click(Sender: TObject);
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem13Click(Sender: TObject);
    procedure MenuItem14Click(Sender: TObject);
    procedure MenuItem15Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.MenuItem15Click(Sender: TObject);
var
   vermelho, verde, azul : Double;
   matiz, saturacao, valor : Double;
   croma, secundario, ajuste : Double;
   vermelhoTemp, verdeTemp, azulTemp : Double;
   setor : Integer;
begin
   matiz := StrToFloat(Edit4.Text);
   saturacao := StrToFloat(Edit5.Text);
   valor := StrToFloat(Edit6.Text);

   matiz := matiz mod 360;
   if (matiz < 0) then matiz := matiz + 360;
   if (saturacao > 1) then saturacao := saturacao / 100;
   if (valor > 1) then valor := valor / 100;

   setor := floor(matiz / 60);
   croma := valor * saturacao;
   secundario := croma * (1 - Abs((matiz / 60) mod 2 - 1));
   ajuste := valor - croma;

   case setor of
        0: begin vermelhoTemp := croma; verdeTemp := secundario; azulTemp := 0; end;
        1: begin vermelhoTemp := secundario; verdeTemp := croma; azulTemp := 0; end;
        2: begin vermelhoTemp := 0; verdeTemp := croma; azulTemp := secundario; end;
        3: begin vermelhoTemp := 0; verdeTemp := secundario; azulTemp := croma; end;
        4: begin vermelhoTemp := secundario; verdeTemp := 0; azulTemp := croma; end;
        5: begin vermelhoTemp := croma; verdeTemp := 0; azulTemp := secundario; end;
   else
     begin vermelhoTemp := 0; verdeTemp := 0; azulTemp := 0; end;
   end;

   vermelho := (vermelhoTemp + ajuste) * 255;
   verde := (verdeTemp + ajuste) * 255;
   azul := (azulTemp + ajuste) * 255;

   Edit1.Text := IntToStr(round(vermelho));
   Edit2.Text := IntToStr(round(verde));
   Edit3.Text := IntToStr(round(azul));
end;


procedure TForm1.MenuItem9Click(Sender: TObject);
var
   vermelho, verde, azul :Double;
   hue, saturation, value : Double;
   smallest, biggest, delta : Double;
begin
   vermelho := StrToFloat(Edit1.Text) / 255;
   verde := StrToFloat(Edit2.Text) / 255;
   azul := StrToFloat(Edit3.Text) / 255;

   smallest := Min(Min(vermelho, verde), azul);
   biggest := Max(Max(vermelho, verde), azul);
   delta := biggest - smallest;

   value := biggest;

   if (biggest = 0) then
      saturation := 0
   else
       saturation := delta/biggest;

   if (delta = 0) then
      hue := 0
   else if (biggest = vermelho) then
   begin
        hue := (verde - azul) / delta mod 6;
   end
   else if (biggest = verde) then
   begin
        hue := (azul - vermelho) / delta + 2;
   end
   else if (biggest = azul) then
   begin
        hue := (vermelho - verde) / delta + 4;
   end;

   Edit4.Text := FormatFloat('0.00', hue * 60);
   Edit5.Text := FloatToStr(round(saturation * 100));
   Edit6.Text := FloatToStr(round(value * 100));
end;

{
procedure TForm1.MenuItem12Click(Sender: TObject);
var
   gx,gy : Double;
   min, max : Double;
   h, w : Integer;
begin
  for h := 1 to (Image1.Height - 2) do
      for w := 1 to (Image1.Width - 2) do
      begin
           gx := -1 * ImE[w - 1, h - 1] + 1 * ImE[w + 1, h - 1]
                 -2 * ImE[w - 1, h]     + 2 * ImE[w + 1, h]
                 -1 * ImE[w - 1, h + 1] + 1 * ImE[w + 1, h + 1];

           gy := -1 * ImE[w - 1, h - 1] - 2 * ImE[w, h - 1] - 1 * Ime[w + 1, h - 1]
                 +1 * ImE[w - 1, h + 1] +2 * Ime[w, h + 1] +1 * Ime[w + 1, h + 1];

           mag[w, h] := sqrt(gx * gx + gy * gy);
      end;

      min := High(Double);
      max := Low(Double);

      for h := 1 to (Image1.Height - 2) do
          for w := 1 to (Image1.Width - 2) do
          begin
               if (min > mag[w,h]) then min := mag[w,h];
               if (max < mag[w,h]) then max := mag[w,h];
          end;

      for h := 1 to (Image1.Height - 2) do
          for w := 1 to (Image1.Width - 2) do
          begin
               ImS[w, h] := round((mag[w,h] - min) / (max - min)*255);
               Image2.Canvas.Pixels[w,h] := RGB(ImS[w,h], ImS[w,h], ImS[w,h])
          end;
end;
}

procedure TForm1.Button1Click(Sender: TObject);
begin
  Image1.Picture := Image2.Picture;
  Image2.Picture.Clear;
end;

procedure TForm1.Edit6Change(Sender: TObject);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
   cor : TColor;
   vermelho, verde, azul : Integer;
   h, s, v : Double;

begin
     cor := Image1.Canvas.Pixels[x, y];
     vermelho := GetRValue(cor);
     verde := GetGValue(cor);
     azul := GetBValue(cor);

     Edit1.Text := IntToStr(vermelho);
     Edit2.Text := IntToStr(verde);
     Edit3.Text := IntToStr(azul);
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
     if (OpenDialog1.Execute) then
        Image1.Picture.LoadFromFile(OpenDialog1.FileName);
end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  Close();
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
var
   h, w : Integer;
   cor : TColor;
   vermelho, verde, azul, cinza : Integer;
begin

  for h := 0 to (Image1.Height - 1) do
      for w := 0 to (Image1.Width - 1) do
          begin
          cor := Image1.Canvas.Pixels[w, h];
          vermelho := GetRValue(cor);
          verde := GetGValue(cor);
          azul := GetBValue(cor);

          cinza := round(0.299 * vermelho + 0.587 * verde + 0.114 * azul);

          cor := RGB(cinza, cinza, cinza);

          Image2.Canvas.Pixels[w, h] := cor;
          end;
end;

procedure TForm1.MenuItem7Click(Sender: TObject);
var
   h, w : Integer;
   cor : TColor;
   vermelho, verde, azul : Integer;
begin
  for h := 0 to (Image1.Height- 1)  do
      for w := 0 to (Image1.Width- 1)  do
          begin
          cor := Image1.Canvas.Pixels[w, h];
          vermelho := GetRValue(cor);
          verde := GetGValue(cor);
          azul := GetBValue(cor);

          vermelho := 255 - vermelho;
          verde := 255 - verde;
          azul := 255 - azul;

          cor := RGB(vermelho, verde, azul);

          Image2.Canvas.Pixels[w, h] := cor;
          end;
end;

procedure TForm1.MenuItem13Click(Sender: TObject);
var
   h, w : Integer;
   cor : TColor;
   vermelho, verde, azul : Integer;
begin
  for h := 0 to (Image1.Height - 1) do
      for w := 0 to (Image1.Width - 1) do
          begin
          cor := Image1.Canvas.Pixels[w, h];
          vermelho := GetRValue(cor);
          verde := GetGValue(cor);
          azul := GetBValue(cor);

          Image3.Canvas.Pixels[w, h] := RGB(vermelho, 0, 0);
          Image4.Canvas.Pixels[w, h] := RGB(0, verde, 0);
          Image5.Canvas.Pixels[w, h] := RGB(0, 0, azul);
          end;
end;

procedure TForm1.MenuItem14Click(Sender: TObject);
var
   h, w : Integer;
   cor : TColor;
   vermelho, verde, azul : Integer;
begin
  for h := 0 to (Image1.Height - 1) do
      for w := 0 to (Image1.Width - 1) do
          begin
          cor := Image3.Canvas.Pixels[w, h];
          vermelho := GetRValue(cor);
          cor := Image4.Canvas.Pixels[w, h];
          verde := GetGValue(cor);
          cor := Image5.Canvas.Pixels[w, h];
          azul := GetBValue(cor);

          cor := RGB(vermelho, verde, azul);

          Image2.Canvas.Pixels[w, h] := cor;
          end;
end;

procedure RGBtoHSV(R, G, B: Double; out H, S, V: Double);
var
   minVal, maxVal, delta : Double;
begin
     R := R/255;
     G := G/255;
     B := B/255;

     minVal := Min(Min(R, G), B);
     maxVal := Max(Max(R, G), B);
     delta := maxVal - minVal;

     V := maxVal;

     if (maxVal = 0) then
        S := 0
     else
       S := delta/maxVal;

     if (delta = 0) then
        H := 0
     else if (maxVal = R) then
     begin
          H := (G - B) / delta mod 6;
     end
     else if (maxVal = G) then
     begin
          H := (B - R) / delta + 2;
        end
     else if (maxVal = B) then
     begin
          H := (R - G) / delta + 4;
     end;

     H := H*60;
     S := S*100;
     V := V*100;
end;

end.

