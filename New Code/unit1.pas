unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  ExtCtrls, ComCtrls, Windows, Math, Unit2;

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
    ProgressBar: TProgressBar;
    SaveDialog: TSaveDialog;
    Separator1: TMenuItem;
    procedure ImagemOriginalMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MenuItemAbrirClick(Sender: TObject);
    procedure MenuItemBinarizacaoClick(Sender: TObject);
    procedure MenuItemCinzaClick(Sender: TObject);
    procedure MenuItemCompressaoClick(Sender: TObject);
    procedure MenuItemConversoresClick(Sender: TObject);
    procedure MenuItemEqualizacaoClick(Sender: TObject);
    procedure MenuItemFecharClick(Sender: TObject);
    procedure MenuItemLaplacianoClick(Sender: TObject);
    procedure MenuItemMediaClick(Sender: TObject);
    procedure MenuItemMedianaClick(Sender: TObject);
    procedure MenuItemNegativoClick(Sender: TObject);
    procedure MenuItemRGBparaHSVClick(Sender: TObject);
    procedure MenuItemRuidosClick(Sender: TObject);
    procedure MenuItemSalvarClick(Sender: TObject);
    procedure MenuItemSobelClick(Sender: TObject);
  private


  public
    procedure ReceberCores(var r,g,b : Integer; x,y : Integer);
    procedure Atualizar(y : Integer);
    procedure AjustandoBarra();
    procedure ResetarBarra();

  end;

  procedure OrdenarArray(var arr : array of Integer);
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

procedure TForm1.MenuItemBinarizacaoClick(Sender: TObject);
var
  input : String;
  x, y, limiar : Integer;
  cor : TColor;
  vermelho, verde, azul, cinza : Integer;
begin
     vermelho := 0;
     verde := 0;
     azul := 0;

     input := InputBox('Binarização', 'Valor do limiar:', '');

     if input <> '' then
        limiar := Floor(strToInt(input))
     else
         limiar := Floor(255/2);

     for y := 0 to (ImagemOriginal.height - 1) do
      for x:= 0 to (ImagemOriginal.width - 1) do
      begin
          ReceberCores(vermelho, verde, azul, x, y);

          cinza := round(0.299 * vermelho + 0.587 * verde + 0.114 * azul);

          if cinza < limiar then
             cinza := 0
          else
             cinza := 255;

          cor := RGB(cinza, cinza, cinza);

          ImagemResultado.Canvas.Pixels[x, y] := cor;
          Atualizar(y);
      end;
  ResetarBarra();

end;

procedure TForm1.MenuItemCinzaClick(Sender: TObject);
var
  x, y : Integer;
  cor : TColor;
  vermelho, verde, azul, cinza : Integer;
begin
  AjustandoBarra();
  vermelho := 0;
  verde := 0;
  azul := 0;
  for y := 0 to (ImagemOriginal.height - 1) do
      for x:= 0 to (ImagemOriginal.width - 1) do
      begin
          ReceberCores(vermelho, verde, azul, x, y);

          cinza := round(0.299 * vermelho + 0.587 * verde + 0.114 * azul);

          cor := RGB(cinza, cinza, cinza);

          ImagemResultado.Canvas.Pixels[x, y] := cor;
          Atualizar(y);
      end;
  ResetarBarra();
end;

procedure TForm1.MenuItemCompressaoClick(Sender: TObject);
var
  x, y : Integer;
  vermelho, verde, azul, cinza : Integer;
  gama, c, s : Double;
  s1, s2 : String;
begin
  AjustandoBarra();

  vermelho := 0;
  verde := 0;
  azul := 0;
  cinza := 0;

  if InputQuery('Compressão S = c*r^(gama)', 'Valor de gama:', s1) then
    if InputQuery('Compressão S = c*r^(gama)', 'Valor de c:',  s2) then
      begin
           if s1 <> '' then
              gama := StrToFloat(StringReplace(s1, '.', ',', [rfReplaceAll]))
           else
               gama := 1.0;

           if s2 <> '' then
              c := StrToFloat(StringReplace(s2, '.', ',', [rfReplaceAll]))
           else
               c := 1.0;
      end;

  for y := 0 to ImagemOriginal.Height - 1 do
      for x := 0 to ImagemOriginal.Width - 1 do
      begin
          ReceberCores(vermelho, verde, azul, x, y);
          cinza := Round(0.299 * vermelho + 0.587 * verde + 0.114 * azul);

          s := c * Power(cinza / 255, gama);
          s := Round(s * 255);

          if s > 255 then
        s := 255
      else if s < 0 then
        s := 0;

          ImagemResultado.Canvas.Pixels[x, y] := RGB(Round(s), Round(s), Round(s));
          Atualizar(y);
      end;
  ResetarBarra();
end;

procedure TForm1.MenuItemConversoresClick(Sender: TObject);
begin
  Form2.Show();
end;

procedure TForm1.MenuItemEqualizacaoClick(Sender: TObject);
var
  x, y : Integer;
  vermelho, verde, azul : Integer;
  pixels, soma, i : Integer;
  cinzas : array of array of Integer;
  histOriginal, histResultado, tabela : array[0..255] of Integer;
begin
  AjustandoBarra();

  SetLength(cinzas, ImagemOriginal.Width);

  for i := 0 to ImagemOriginal.Width - 1 do
      SetLength(cinzas[i], ImagemOriginal.Height);

  for y := 0 to ImagemOriginal.Height - 1 do
      for x := 0 to ImagemOriginal.Width - 1 do
          cinzas[x,y] := 0;

  for i := 0 to 255 do
  begin
       histOriginal[i] := 0;
       histResultado[i] := 0;
  end;

  soma := 0;
  pixels := ImagemOriginal.Height * ImagemOriginal.Width;

  vermelho := 0;
  verde := 0;
  azul := 0;

  for y := 0 to ImagemOriginal.Height - 1 do
    for x := 0 to ImagemOriginal.Width - 1 do
    begin
      ReceberCores(vermelho, verde, azul, x, y);
      cinzas[x,y] := Round(0.299 * vermelho + 0.587 * verde + 0.114 * azul);
      histOriginal[cinzas[x,y]] += 1;
      Atualizar(y);
    end;

  for i := 0 to 255 do
  begin
    soma += histOriginal[i];
    histResultado[i] := soma;
    tabela[i] := Round(255 * histResultado[i] / pixels);
  end;

  for y := 0 to ImagemOriginal.Height - 1 do
    for x := 0 to ImagemOriginal.Width - 1 do
    begin
      cinzas[x,y] := tabela[cinzas[x,y]];
      ImagemResultado.Canvas.Pixels[x, y] := RGB(cinzas[x,y], cinzas[x,y], cinzas[x,y]);
      Atualizar(y);
    end;
  ResetarBarra();
end;

procedure TForm1.MenuItemFecharClick(Sender: TObject);
begin
  Close();
end;

procedure TForm1.MenuItemLaplacianoClick(Sender: TObject);
var
  x, y, i: Integer;
  cor : TColor;
  vermelho, verde, azul, cinza : Integer;
  cinzas : array of array of Integer;
begin
     SetLength(cinzas, ImagemOriginal.Width);

  for i := 0 to ImagemOriginal.Width - 1 do
      SetLength(cinzas[i], ImagemOriginal.Height);

     AjustandoBarra();

     vermelho := 0;
     verde := 0;
     azul := 0;

     for y := 1 to (ImagemOriginal.height - 2) do
         for x:= 1 to (ImagemOriginal.width - 2) do
         begin
              ReceberCores(vermelho, verde, azul, x, y);
              cinzas[x,y] := round(0.299 * vermelho + 0.587 * verde + 0.114 * azul);
              Atualizar(y);
         end;

     for y := 1 to (ImagemOriginal.height - 2) do
         for x:= 1 to (ImagemOriginal.width - 2) do
         begin

              cinza := (4 * cinzas[x,y])
              - cinzas[x+1,y] - cinzas[x-1,y]
              - cinzas[x,y+1] - cinzas[x,y-1];

              if cinza < 0 then
                   cinza := 0
              else if cinza > 255 then
                   cinza := 255;

              cor := RGB(cinza, cinza, cinza);
              ImagemResultado.Canvas.Pixels[x, y] := cor;

              Atualizar(y);
         end;

   ResetarBarra();
end;

procedure TForm1.MenuItemMediaClick(Sender: TObject);
var
  x, y, i, j, n : Integer;
  cor : TColor;
  vermelho, verde, azul : Integer;
  somaVermelho, somaVerde, somaAzul : Integer;
begin
  AjustandoBarra();
  vermelho := 0;
  verde := 0;
  azul := 0;

  for y := 1 to (ImagemOriginal.height - 2) do
      for x:= 1 to (ImagemOriginal.width - 2) do
      begin
          somaVermelho := 0;
          somaVerde := 0;
          somaAzul := 0;
          n := 0;

          for j := -1 to 1 do
              for i := -1 to 1 do
              begin
                   ReceberCores(vermelho, verde, azul, x + i, y + j);
                   somaVermelho += vermelho;
                   somaVerde += verde;
                   somaAzul += azul;
                   Inc(n);
              end;

          vermelho := round(somaVermelho / n);
          verde := round(somaVerde / n);
          azul := round(somaAzul / n);

          cor := RGB(vermelho, verde, azul);

          ImagemResultado.Canvas.Pixels[x, y] := cor;
          Atualizar(y);
      end;
  ResetarBarra();
end;

procedure TForm1.MenuItemMedianaClick(Sender: TObject);
var
  x, y, i, j, n : Integer;
  cor : TColor;
  vermelho, verde, azul : Integer;
  vermelhos, verdes, azuis : array[0..8] of Integer;
begin
  AjustandoBarra();

  vermelho := 0;
  verde := 0;
  azul := 0;

  for y := 1 to (ImagemOriginal.height - 2) do
      for x:= 1 to (ImagemOriginal.width - 2) do
      begin
          n := 0;
          for j := -1 to 1 do
              for i := -1 to 1 do
              begin
                   ReceberCores(vermelho, verde, azul, x + i, y + j);

                   vermelhos[n] := vermelho;
                   verdes[n] := verde;
                   azuis[n] := azul;
                   Inc(n);
              end;

          OrdenarArray(vermelhos);
          OrdenarArray(verdes);
          OrdenarArray(azuis);

          n := trunc(n/2);

          vermelho := vermelhos[n];
          verde := verdes[n];
          azul := azuis[n];

          cor := RGB(vermelho, verde, azul);

          ImagemResultado.Canvas.Pixels[x, y] := cor;
          Atualizar(y);
      end;
  ResetarBarra();
end;

procedure TForm1.MenuItemNegativoClick(Sender: TObject);
var
  x, y : Integer;
  cor : TColor;
  vermelho, verde, azul : Integer;
begin
  AjustandoBarra();
  vermelho := 0;
  verde := 0;
  azul := 0;
  for y := 0 to (ImagemOriginal.height - 1) do
      for x:= 0 to (ImagemOriginal.width - 1) do
      begin
          ReceberCores(vermelho, verde, azul, x, y);

          vermelho := 255 - vermelho;
          verde := 255 - verde;
          azul := 255 - azul;

          cor := RGB(vermelho, verde, azul);

          ImagemResultado.Canvas.Pixels[x, y] := cor;
          Atualizar(y);
      end;
  ResetarBarra();
end;

procedure TForm1.MenuItemRGBparaHSVClick(Sender: TObject);
begin
  Form2.Show();
end;

procedure TForm1.MenuItemRuidosClick(Sender: TObject);
var
  x, y : Integer;
  vermelho, verde, azul : Integer;
  r, intensidade : Double;
  branco : Boolean;
  input : String;
begin
  AjustandoBarra();

  vermelho := 0;
  verde := 0;
  azul := 0;

  input := InputBox('Adicionar Ruídos', 'Intensidade dos ruídos:', '');

     if input <> '' then
        intensidade := strToFloat(StringReplace(input, '.', ',', [rfReplaceAll])) / 100
     else
         intensidade := 10/100;

  for y := 0 to (ImagemOriginal.height - 1) do
      for x:= 0 to (ImagemOriginal.width - 1) do
      begin
           r := Random;
           if r < intensidade then
           begin
                branco := (Random < 0.5);

                if branco then
                   ImagemResultado.Canvas.Pixels[x, y] := RGB(255,255,255)
                else
                    ImagemResultado.Canvas.Pixels[x, y] := RGB(0,0,0);
           end
          else
          begin
              ReceberCores(vermelho, verde, azul, x, y);
              ImagemResultado.Canvas.Pixels[x, y] := RGB(vermelho, verde, azul);
          end;

          Atualizar(y);
      end;
  ResetarBarra();
end;

procedure TForm1.MenuItemSalvarClick(Sender: TObject);
var
  fileName : String;
begin
  fileName := InputBox('Salvar Imagem', 'Nome da Imagem:', 'Imagem.png');
  try
    ImagemResultado.Picture.SaveToFile(fileName);
  finally
    ImagemResultado.Free;
  end;
end;

procedure TForm1.MenuItemSobelClick(Sender: TObject);
var
  x, y, i : Integer;
  Gx, Gy, gradiente : Double;
  vermelho, verde, azul : Integer;
  cinzas : array of array of Integer;

begin
  AjustandoBarra;

  vermelho := 0;
  verde := 0;
  azul := 0;

  SetLength(cinzas, ImagemOriginal.Width);

  for i := 0 to ImagemOriginal.Width - 1 do
      SetLength(cinzas[i], ImagemOriginal.Height);

  for y := 0 to (ImagemOriginal.height - 1) do
      for x:= 0 to (ImagemOriginal.width - 1) do
      begin
           ReceberCores(vermelho, verde, azul, x, y);
           cinzas[x,y] := round(0.299 * vermelho + 0.587 * verde + 0.114 * azul);
           Atualizar(y);
      end;

  for y := 1 to (ImagemOriginal.height - 2) do
      for x:= 1 to (ImagemOriginal.width - 2) do
      begin
          Gx := 0;
          Gy := 0;

          Gx := - cinzas[x-1,y-1] + cinzas[x+1,y-1]
                - 2*cinzas[x-1,y] + 2*cinzas[x+1,y]
                - cinzas[x-1,y+1] + cinzas[x+1,y+1];

          Gy := - cinzas[x-1,y-1] + cinzas[x-1,y+1]
                - 2*cinzas[x,y-1] + 2*cinzas[x,y+1]
                - cinzas[x+1,y-1] + cinzas[x+1,y+1];

          gradiente := sqrt((Gx * Gx) + (Gy * Gy));

          gradiente := Max(0, Min(gradiente, 255));

          ImagemResultado.Canvas.Pixels[x, y] := RGB(Round(gradiente), Round(gradiente), Round(gradiente));
          Atualizar(y);
      end;

  ResetarBarra;
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
     menor := Min(Min(vermelhoTemp, verdeTemp), azulTemp);
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

procedure TForm1.ReceberCores(var r,g,b : Integer; x,y : Integer);
var
   cor : TColor;
begin
    cor := ImagemOriginal.Canvas.Pixels[x, y];
    r := GetRValue(cor);
    g := GetGValue(cor);
    b := GetBValue(cor);
end;

procedure OrdenarArray(var arr : array of Integer);
var
   i, j, temp : Integer;
begin
     for i := Low(arr) to High(arr) - 1 do
         for j := i + 1 to High(arr) do
         if arr[i] < arr[j] then
         begin
              temp := arr[i];
              arr[i] := arr[j];
              arr[j] := temp;
         end;
end;
procedure TForm1.AjustandoBarra();
begin
  ProgressBar.Min := 0;
  ProgressBar.Max := ImagemOriginal.height;
end;

procedure TForm1.Atualizar(y : Integer);
begin
     ProgressBar.Position := y;
     Application.ProcessMessages;
end;
procedure TForm1.ResetarBarra();
begin
     ProgressBar.Position := 0;
     Application.ProcessMessages;
end;

end.

