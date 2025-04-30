unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  ExtCtrls, ComCtrls, Windows, Math;

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
    ProgressBar: TProgressBar;
    SaveDialog: TSaveDialog;
    Separator1: TMenuItem;
    procedure ImagemOriginalMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MenuItemAbrirClick(Sender: TObject);
    procedure MenuItemBinarizacaoClick(Sender: TObject);
    procedure MenuItemCinzaClick(Sender: TObject);
    procedure MenuItemFecharClick(Sender: TObject);
    procedure MenuItemLaplacianoClick(Sender: TObject);
    procedure MenuItemMediaClick(Sender: TObject);
    procedure MenuItemMedianaClick(Sender: TObject);
    procedure MenuItemNegativoClick(Sender: TObject);
    procedure MenuItemRGBparaHSVClick(Sender: TObject);
    procedure AjustarLayout;
  private


  public
    procedure ReceberCores(var r,g,b : Integer; x,y : Integer);
    procedure Atualizar(y : Integer);
    procedure AjustandoBarra(        );
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

procedure TForm1.AjustarLayout;
var
  Margem, TopBase, EspacoEntreCanal: Integer;
begin
  Margem := 20;
  EspacoEntreCanal := 10; // espaço entre os canais R, G, B

  // Ajustar ImagemResultado ao lado da ImagemOriginal
  ImagemResultado.Left := ImagemOriginal.Left + ImagemOriginal.Width + LabelX.Width * 2 + EditX.Width * 2 + 40 + Margem;
  ImagemResultado.Top := ImagemOriginal.Top;
  ImagemResultado.Width := ImagemOriginal.Width;
  ImagemResultado.Height := ImagemOriginal.Height;

  // Posição inicial para os canais de cor
  TopBase := ImagemOriginal.Top + ImagemOriginal.Height + Margem;

  // Canal Vermelho
  CanalVermelho.Left := ImagemOriginal.Left;
  CanalVermelho.Top := TopBase;
  CanalVermelho.Width := ImagemOriginal.Width;
  CanalVermelho.Height := ImagemOriginal.Height; // quadrado

  // Canal Verde
  CanalVerde.Left := CanalVermelho.Left + CanalVermelho.Width + EspacoEntreCanal;
  CanalVerde.Top := TopBase;
  CanalVerde.Width := CanalVermelho.Width;
  CanalVerde.Height := CanalVermelho.Height;

  // Canal Azul
  CanalAzul.Left := CanalVerde.Left + CanalVerde.Width + EspacoEntreCanal;
  CanalAzul.Top := TopBase;
  CanalAzul.Width := CanalVermelho.Width;
  CanalAzul.Height := CanalVermelho.Height;

  // Botões e Barra de Progresso
  ProgressBar.Left := ImagemOriginal.Left + ImagemOriginal.Width + 10 + round((LabelX.Width + EditX.Width)/2);
  ProgressBar.Top := Margem;
  MoverImagem.Left := ProgressBar.Left + 10;
  MoverImagem.Top := ProgressBar.Top + ProgressBar.Height + 10;

  // Labels e Caixas de Texto - organizados abaixo dos canais
  // Posições dos labels (X, Y, R, G, B, H, S, V)
  LabelX.Left := ImagemOriginal.Left + ImagemOriginal.Width + 10;
  LabelX.Top := Margem + MoverImagem.Top + MoverImagem.Height;
  EditX.Left := LabelX.Left + LabelX.Width + 5;  // Espaço entre o label e a caixa de texto
  EditX.Top := LabelX.Top;

  LabelY.Left := LabelX.Left + LabelX.Width + EditX.Width + 30;
  LabelY.Top := LabelX.Top;
  EditY.Left := LabelY.Left + LabelY.Width + 10;
  EditY.Top := LabelY.Top;

  LabelR.Left := LabelX.Left;
  LabelR.Top := LabelX.Top + LabelX.Height + 30;
  EditR.Left := EditX.Left;
  EditR.Top := LabelR.Top;

  LabelG.Left := LabelX.Left;
  LabelG.Top := LabelR.Top + LabelR.Height + 15;
  EditG.Left := EditX.Left;
  EditG.Top := LabelG.Top;

  LabelB.Left := LabelX.Left;
  LabelB.Top := LabelG.Top + LabelG.Height + 15;
  EditB.Left := EditX.Left;
  EditB.Top := LabelB.Top;

  LabelH.Left := LabelY.Left;
  LabelH.Top := LabelY.Top + LabelY.Height + 30;
  EditH.Left := EditY.Left;
  EditH.Top := LabelH.Top;

  LabelS.Left := LabelY.Left;
  LabelS.Top := LabelH.Top + LabelH.Height + 15;
  EditS.Left := EditY.Left;
  EditS.Top := LabelS.Top;

  LabelV.Left := LabelY.Left;
  LabelV.Top := LabelS.Top + LabelS.Height + 15;
  EditV.Left := EditY.Left;
  EditV.Top := LabelV.Top;

  // Ajuste final do tamanho do formulário
  Self.ClientWidth := ImagemResultado.Left + ImagemResultado.Width + Margem * 2;
  Self.ClientHeight := CanalVermelho.Top + CanalVermelho.Height + Margem * 2;
end;


procedure TForm1.MenuItemAbrirClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    ImagemOriginal.Picture.LoadFromFile(OpenDialog.FileName);

    ImagemOriginal.Width := ImagemOriginal.Picture.Width;
    ImagemOriginal.Height := ImagemOriginal.Picture.Height;

    // Agora chama o método para reorganizar tudo:
    AjustarLayout;
  end;
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

procedure TForm1.MenuItemFecharClick(Sender: TObject);
begin
  Close();
end;

procedure TForm1.MenuItemLaplacianoClick(Sender: TObject);
var
  x, y: Integer;
  cor : TColor;
  vermelho, verde, azul, cinza : Integer;
  cinzas : array of array of Integer;
begin
     SetLength(cinzas, ImagemOriginal.Width, ImagemOriginal.Height);

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

