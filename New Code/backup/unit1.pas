unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  ExtCtrls, Windows, Math;

type

  { TForm1 }

  TForm1 = class(TForm)
    EditX: TEdit;
    EditR: TEdit;
    EditG: TEdit;
    EditB: TEdit;
    EditY: TEdit;
    EditH: TEdit;
    EditS: TEdit;
    EditV: TEdit;
    ImagemOriginal: TImage;
    ImagemResultado: TImage;
    CanalVermelho: TImage;
    CanalVerde: TImage;
    CanalAzul: TImage;
    LabelX: TLabel;
    LabelY: TLabel;
    LabelR: TLabel;
    LabelG: TLabel;
    LabelB: TLabel;
    LabelH: TLabel;
    LabelS: TLabel;
    LabelV: TLabel;
    MenuItemEqualizacao: TMenuItem;
    MenuItemBinarizacao: TMenuItem;
    MenuItemCompressao: TMenuItem;
    MenuItemLaplaciano: TMenuItem;
    MenuItemSobel: TMenuItem;
    MenuItemMediana: TMenuItem;
    MenuItemMedia: TMenuItem;
    MenuItemRuidos: TMenuItem;
    MenuItemHSVparaRGB: TMenuItem;
    MenuItemRGBparaHSV: TMenuItem;
    MenuItemRestaurar: TMenuItem;
    MenuItemSeparar: TMenuItem;
    MenuItemNegativo: TMenuItem;
    MenuItemCinza: TMenuItem;
    MenuItemOperacao: TMenuItem;
    MenuItemFiltros: TMenuItem;
    MenuItemCanais: TMenuItem;
    MenuItemConversores: TMenuItem;
    MoverImagem: TButton;
    MainMenu: TMainMenu;
    MenuItemImagem: TMenuItem;
    MenuItemAbrir: TMenuItem;
    MenuItemSalvar: TMenuItem;
    MenuItemFechar: TMenuItem;
    OpenDialog: TOpenDialog;
    SaveDialog: TSaveDialog;
    Separator1: TMenuItem;
    procedure ImagemOriginalMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MenuItemAbrirClick(Sender: TObject);
    procedure MenuItemFecharClick(Sender: TObject);
  private


  public

  end;

  procedure ConverterRGBparaHSV(r, g, b : Integer; var h, s, v : Double);
  procedure ConverterHSVparaRGB(h, s, v : Double; var r,g,b : Integer);


var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ImagemOriginalMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  cor : TColor;
  vermelho, verde, azul : Integer;
  matriz, saturacao, valor : Double;
begin
  cor := ImagemOriginal.Canvas.Pixels[X,Y];
  vermelho := GetRValue(cor);
  verde := GetGValue(cor);
  azul := GetBValue(cor);
  matriz := 0.0;
  saturacao := 0.0;
  valor := 0.0;

  ConverterRGBparaHSV(vermelho, verde, azul, matriz, saturacao, valor);

  EditX.Text := IntToStr(X);
  EditY.Text := IntToStr(Y);

  EditR.Text := IntToStr(vermelho);
  EditG.Text := IntToStr(verde);
  EditB.Text := IntToStr(azul);

  EditH.Text := FloatToStr(matriz);
  EditS.Text := FloatToStr(saturacao);
  EditV.Text := FloatToStr(valor);

end;

procedure TForm1.MenuItemAbrirClick(Sender: TObject);
begin
  if(OpenDialog.Execute) then
                         ImagemOriginal.Picture.LoadFromFile(OpenDialog.FileName);
end;

procedure TForm1.MenuItemFecharClick(Sender: TObject);
begin
  Close();
end;

procedure ConverterRGBparaHSV(r, g, b : Integer; var h, s, v : Double);
var
  vermelhoTemp, verdeTemp, azulTemp : Double;
  delta, menor, maior : Double;
begin
     vermelhoTemp := r/255;
     verdeTemp := g/255;
     azulTemp := b/255;

     maior := Max(Max(vermelhoTemp, verdeTemp), azulTemp);

     if (vermelhoTemp > verdeTemp) then
        maior := vermelhoTemp
     else
         maior := verdeTemp;

     if (maior < azulTemp) then
        maior := azulTemp;

     if (vermelhoTemp < verdeTemp) then
        menor := vermelhoTemp
     else
         menor := verdeTemp;
     if (menor > azulTemp) then
        menor := azulTemp;

     delta := maior - menor;

     v := maior;

     if (maior = 0) then
        s := 0
     else
         s := delta/maior;

     if (delta = 0) then
        h := 0
     else if (maior = vermelhoTemp) then
     begin
          h := ((verdeTemp - azulTemp) / delta) mod 6;
     end
     else if (maior = verdeTemp) then
     begin
          h := ((azulTemp - vermelhoTemp) / delta) + 2;
     end
     else if (maior = azulTemp) then
     begin
          h := ((vermelhoTemp - verdeTemp) / delta) + 4;
     end;

         h := round(h * 60);
         s := round(s * 100);
         v := round(v * 100);

         h := h mod 360;
         if h < 0 then
            h := h + 360;
end;

procedure ConverterHSVparaRGB(h,s,v : Double; var r,g,b : Integer);
var
   croma, secundario, ajuste : Double;
   vermelhoTemp, verdeTemp, azulTemp : Double;
   setor : Integer;
begin

   h := (h mod 360);
   if (h < 0) then h := h + 360;
   if (s > 1) then s := s / 100;
   if (v > 1) then v := v / 100;

   setor := floor(h / 60);
   croma := v * s;
   secundario := croma * (1 - Abs((h / 60) mod 2 - 1));
   ajuste := v - croma;

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

   r := round(vermelhoTemp + ajuste) * 255;
   g := round(verdeTemp + ajuste) * 255;
   b := round(azulTemp + ajuste) * 255;
end;

end.

