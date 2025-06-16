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
    MenuItem2: TMenuItem;
    MenuItemEqualizacaoL: TMenuItem;
    MenuItemPseudoCores: TMenuItem;
    MenuItemPontoMedio: TMenuItem;
    MenuItemSobel: TMenuItem;
    MenuItemMinimo: TMenuItem;
    MenuItemMaximo: TMenuItem;
    MenuItemEsqueleto: TMenuItem;
    MenuItemBinarizacaoOTSU: TMenuItem;
    MenuItemLimiarizacaoOTSU: TMenuItem;
    MenuItemSepararColorido: TMenuItem;
    MenuItemEqualizacao: TMenuItem;
    MenuItemBinarizacao: TMenuItem;
    MenuItemCompressao: TMenuItem;
    MenuItemLaplaciano: TMenuItem;
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
    Separator2: TMenuItem;
    Separator3: TMenuItem;
    Separator4: TMenuItem;
    Separator5: TMenuItem;
    procedure ImagemOriginalMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: integer);
    procedure ImagemResultadoClick(Sender: TObject);
    procedure MenuItemEsqueletoClick(Sender: TObject);
    procedure MenuItemLimiarizacaoOTSUClick(Sender: TObject);
    procedure MenuItemSobelClick(Sender: TObject);
    procedure MenuItemBinarizacaoOTSUClick(Sender: TObject);
    procedure MenuItemEqualizacaoLClick(Sender: TObject);
    procedure MenuItemMaximoClick(Sender: TObject);
    procedure MenuItemPontoMedioClick(Sender: TObject);
    procedure MenuItemPseudoCoresClick(Sender: TObject);
    procedure MenuItemSepararColoridoClick(Sender: TObject);
    procedure MenuItemMinimoClick(Sender: TObject);
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
    procedure MenuItemRestaurarClick(Sender: TObject);
    procedure MenuItemRGBparaHSVClick(Sender: TObject);
    procedure MenuItemRuidosClick(Sender: TObject);
    procedure MenuItemSalvarClick(Sender: TObject);
    procedure MenuItemSepararClick(Sender: TObject);
    procedure MoverImagemClick(Sender: TObject);
  private


  public
    procedure ReceberCores(var r, g, b: integer; x, y: integer);
    procedure Atualizar(y: integer);
    procedure AjustandoBarra();
    procedure ResetarBarra();

  end;

procedure OrdenarArray(var arr: array of integer);
procedure ConverterRGBparaHSV(r, g, b: integer; var h, s, v: double);
procedure ConverterRGBparaHSL(r, g, b: integer; var h, s, l: double);
procedure ConverterHSLparaRGB(h, s, l: double; var r, g, b: integer);
procedure ConverterHSVparaRGB(h, s, v: double; var r, g, b: integer);

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.ImagemOriginalMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: integer);
var
  cor: TColor;
  vermelho, verde, azul: integer;
  matriz, saturacao, valor: double;
begin
  cor := ImagemOriginal.Canvas.Pixels[X, Y];
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

procedure TForm1.ImagemResultadoClick(Sender: TObject);
begin

end;

procedure TForm1.MenuItemEsqueletoClick(Sender: TObject);
var
  x, y, n, s: Integer;
  largura, altura : Integer;
  cor: TColor;
  img: array of array of Integer;
  marcador : array of array of Boolean;
  mudanca : Boolean;
  p2, p3, p4, p5, p6, p7, p8, p9 : Integer;
begin
  AjustandoBarra();

  altura := ImagemOriginal.Height;
  largura := ImagemOriginal.Width;

  SetLength(img, largura);
  SetLength(marcador, largura);

  for x := 0 to largura - 1 do
  begin
       SetLength(img[x], altura);
       SetLength(marcador[x], altura);
  end;

  for y := 0 to altura - 1 do
    for x := 0 to largura - 1 do
    begin
      cor := ImagemOriginal.Canvas.Pixels[x, y];
      if GetRValue(cor) = 255 then
        img[x, y] := 1
      else
        img[x, y] := 0;
      Atualizar(y);
    end;

  repeat
        mudanca := False;

        for y := 1 to altura - 2 do
            for x := 1 to largura - 2 do
            begin
                 if (img[x,y] = 1) then
                 begin
                      p2 := img[x,y-1];
                      p3 := img[x+1,y-1];
                      p4 := img[x+1,y];
                      p5 := img[x+1,y+1];
                      p6 := img[x,y+1];
                      p7 := img[x-1,y+1];
                      p8 := img[x-1,y];
                      p9 := img[x-1,y-1];

                      n := p2 + p3 + p4 + p5 + p6 + p7 + p8 + p9;

                      s := 0;
                      if (p2 = 0) and (p3 = 1) then Inc(s);
                      if (p3 = 0) and (p4 = 1) then Inc(s);
                      if (p4 = 0) and (p5 = 1) then Inc(s);
                      if (p5 = 0) and (p6 = 1) then Inc(s);
                      if (p6 = 0) and (p7 = 1) then Inc(s);
                      if (p7 = 0) and (p8 = 1) then Inc(s);
                      if (p8 = 0) and (p9 = 1) then Inc(s);
                      if (p9 = 0) and (p2 = 1) then Inc(s);

                      if ((n >= 2) and (n <= 6)) and (s = 1) and
                         ((p2*p4*p6) = 0) and ((p4*p6*p8) = 0) then
                         marcador[x,y] := True
                      else
                          marcador[x,y] := False;
                 end;
            end;

        for y := 1 to altura - 2 do
            for x := 1 to largura - 2 do
                if marcador[x,y] then
                begin
                     img[x,y] := 0;
                     imagemResultado.Canvas.Pixels[x,y] := RGB(255,255,255);
                     mudanca := True;
                     Atualizar(y);
                end
                else
                begin
                    imagemResultado.Canvas.Pixels[x,y] := RGB(0,0,0);
                    Atualizar(y);
                end;

        for y := 1 to altura - 2 do
            for x := 1 to largura - 2 do
            begin
                 if (img[x,y] = 1) then
                 begin
                      p2 := img[x,y-1];
                      p3 := img[x+1,y-1];
                      p4 := img[x+1,y];
                      p5 := img[x+1,y+1];
                      p6 := img[x,y+1];
                      p7 := img[x-1,y+1];
                      p8 := img[x-1,y];
                      p9 := img[x-1,y-1];

                      n := p2 + p3 + p4 + p5 + p6 + p7 + p8 + p9;

                      s := 0;
                      if (p2 = 0) and (p3 = 1) then Inc(s);
                      if (p3 = 0) and (p4 = 1) then Inc(s);
                      if (p4 = 0) and (p5 = 1) then Inc(s);
                      if (p5 = 0) and (p6 = 1) then Inc(s);
                      if (p6 = 0) and (p7 = 1) then Inc(s);
                      if (p7 = 0) and (p8 = 1) then Inc(s);
                      if (p8 = 0) and (p9 = 1) then Inc(s);
                      if (p9 = 0) and (p2 = 1) then Inc(s);

                      if ((n >= 2) and (n <= 6)) and (s = 1) and
                         ((p2*p4*p8) = 0) and ((p2*p6*p8) = 0) then
                         marcador[x,y] := True
                      else
                          marcador[x,y] := False;
                 end;
            end;
        for y := 1 to altura - 2 do
            for x := 1 to largura - 2 do
                if marcador[x,y] then
                begin
                     img[x,y] := 0;
                     imagemResultado.Canvas.Pixels[x,y] := RGB(255,255,255);
                     mudanca := True;
                     Atualizar(y);
                end
                else
                begin
                    imagemResultado.Canvas.Pixels[x,y] := RGB(0,0,0);
                    Atualizar(y);
                end;

  until not mudanca;

  for y := 0 to altura - 1 do
    for x := 0 to largura - 1 do
    begin
      if img[x, y] = 1 then
        ImagemResultado.Canvas.Pixels[x, y] := RGB(0, 0, 0)
      else
        ImagemResultado.Canvas.Pixels[x, y] := RGB(255, 255, 255);
    end;
  ResetarBarra();
end;


procedure TForm1.MenuItemLimiarizacaoOTSUClick(Sender: TObject);
var
  x, y, i, t: integer;
  largura, altura: integer;
  vermelho, verde, azul, cinza: integer;
  pixelsImagem, limiar: integer;
  cinzas: array of array of integer;
  hist: array[0..255] of integer;
  probabilidade, arg: array[0..255] of double;
  gamaT, gamats, gama0, gama1: double;
  omega0, omega1: double;
  tetaT, tetaB: double;
  big: double;
begin
  AjustandoBarra();

  largura := ImagemOriginal.Width;
  altura := ImagemOriginal.Height;
  SetLength(cinzas, largura, altura);

  pixelsImagem := largura * altura;


  gamaT := 0;
  tetaT := 0;

  for i := 0 to 255 do
  begin
    hist[i] := 0;
    arg[i] := 0.0;
    probabilidade[i] := 0.0;
  end;

  for y := 0 to altura - 1 do
    for x := 0 to largura - 1 do
    begin
      ReceberCores(vermelho, verde, azul, x, y);
      cinza := Round(0.299 * vermelho + 0.587 * verde + 0.114 * azul);
      cinzas[x, y] := cinza;
      Inc(hist[cinza]);
      ImagemResultado.Canvas.Pixels[x, y] := RGB(cinza, cinza, cinza);
      Atualizar(y);
    end;

  for i := 0 to 255 do
  begin
    probabilidade[i] := hist[i] / pixelsImagem;
    gamaT := gamaT + (i * probabilidade[i]);
  end;

  for i := 0 to 255 do
    tetaT := tetaT + (Sqr(i - gamaT) * probabilidade[i]);

  big := -1;
  limiar := 0;

  for t := 0 to 255 do
  begin
    omega0 := 0;
    gamats := 0;
    for i := 0 to t do
    begin
      omega0 := omega0 + probabilidade[i];
      gamats := gamats + (i * probabilidade[i]);
    end;

    if (omega0 = 0) or (omega0 = 1) then
      Continue;

    omega1 := 1 - omega0;
    gama0 := gamats / omega0;
    gama1 := (gamaT - gamats) / omega1;

    tetaB := omega0 * omega1 * Sqr(gama0 - gama1);

    arg[t] := tetaB / tetaT;

    if big < arg[t] then
    begin
      big := arg[t];
      limiar := t;
    end;
  end;

  for y := 0 to altura - 1 do
    for x := 0 to largura - 1 do
    begin
      if cinzas[x, y] >= limiar then
        ImagemResultado.Canvas.Pixels[x, y] := ImagemOriginal.Canvas.Pixels[x, y]
      else
        ImagemResultado.Canvas.Pixels[x, y] := RGB(255, 255, 255);
      Atualizar(y);
    end;
  ResetarBarra();
end;

procedure TForm1.MenuItemSobelClick(Sender: TObject);
var
  x, y, i: integer;
  Gx, Gy, gradiente: double;
  vermelho, verde, azul: integer;
  cinzas: array of array of integer;
begin
  AjustandoBarra;

  vermelho := 0;
  verde := 0;
  azul := 0;

  SetLength(cinzas, ImagemOriginal.Width);

  for i := 0 to ImagemOriginal.Width - 1 do
    SetLength(cinzas[i], ImagemOriginal.Height);

  for y := 0 to (ImagemOriginal.Height - 1) do
    for x := 0 to (ImagemOriginal.Width - 1) do
    begin
      ReceberCores(vermelho, verde, azul, x, y);
      cinzas[x, y] := round(0.299 * vermelho + 0.587 * verde + 0.114 * azul);
      Atualizar(y);
    end;

  for y := 1 to (ImagemOriginal.Height - 2) do
    for x := 1 to (ImagemOriginal.Width - 2) do
    begin
      Gx := 0;
      Gy := 0;

      Gx := -cinzas[x - 1, y - 1] + cinzas[x + 1, y - 1] -
        2 * cinzas[x - 1, y] + 2 * cinzas[x + 1, y] - cinzas[x - 1, y + 1] + cinzas[x + 1, y + 1];

      Gy := -cinzas[x - 1, y - 1] + cinzas[x - 1, y + 1] -
        2 * cinzas[x, y - 1] + 2 * cinzas[x, y + 1] - cinzas[x + 1, y - 1] + cinzas[x + 1, y + 1];

      gradiente := sqrt((Gx * Gx) + (Gy * Gy));

      gradiente := Max(0, Min(gradiente, 255));

      ImagemResultado.Canvas.Pixels[x, y] :=
        RGB(Round(gradiente), Round(gradiente), Round(gradiente));
      Atualizar(y);
    end;

  ResetarBarra();
end;

procedure TForm1.MenuItemBinarizacaoOTSUClick(Sender: TObject);
var
  x, y, i, t: integer;
  largura, altura: integer;
  vermelho, verde, azul, cinza: integer;
  pixelsImagem, limiar: integer;
  cinzas: array of array of integer;
  hist: array[0..255] of integer;
  probabilidade, arg: array[0..255] of double;
  gamaT, gamats, gama0, gama1: double;
  omega0, omega1: double;
  tetaT, tetaB: double;
  big: double;
begin
  AjustandoBarra();

  largura := ImagemOriginal.Width;
  altura := ImagemOriginal.Height;
  SetLength(cinzas, largura, altura);

  pixelsImagem := largura * altura;


  gamaT := 0;
  tetaT := 0;

  for i := 0 to 255 do
  begin
    hist[i] := 0;
    arg[i] := 0.0;
    probabilidade[i] := 0.0;
  end;

  for y := 0 to altura - 1 do
    for x := 0 to largura - 1 do
    begin
      ReceberCores(vermelho, verde, azul, x, y);
      cinza := Round(0.299 * vermelho + 0.587 * verde + 0.114 * azul);
      cinzas[x, y] := cinza;
      Inc(hist[cinza]);
      ImagemResultado.Canvas.Pixels[x, y] := RGB(cinza, cinza, cinza);
      Atualizar(y);
    end;

  for i := 0 to 255 do
  begin
    probabilidade[i] := hist[i] / pixelsImagem;
    gamaT := gamaT + (i * probabilidade[i]);
  end;

  for i := 0 to 255 do
    tetaT := tetaT + (Sqr(i - gamaT) * probabilidade[i]);

  big := -1;
  limiar := 0;

  for t := 0 to 255 do
  begin
    omega0 := 0;
    gamats := 0;
    for i := 0 to t do
    begin
      omega0 := omega0 + probabilidade[i];
      gamats := gamats + (i * probabilidade[i]);
    end;

    if (omega0 = 0) or (omega0 = 1) then
      Continue;

    omega1 := 1 - omega0;
    gama0 := gamats / omega0;
    gama1 := (gamaT - gamats) / omega1;

    tetaB := omega0 * omega1 * Sqr(gama0 - gama1);

    arg[t] := tetaB / tetaT;

    if big < arg[t] then
    begin
      big := arg[t];
      limiar := t;
    end;
  end;

  for y := 0 to altura - 1 do
    for x := 0 to largura - 1 do
    begin
      if cinzas[x, y] >= limiar then
        ImagemResultado.Canvas.Pixels[x, y] := RGB(255, 255, 255)
      else
        ImagemResultado.Canvas.Pixels[x, y] := RGB(0, 0, 0);
      Atualizar(y);
    end;
  ResetarBarra();
end;

procedure TForm1.MenuItemEqualizacaoLClick(Sender: TObject);
var
  x, y, i: integer;
  vermelho, verde, azul: integer;
  h, s, l: double;
  pixels, soma: integer;
  intensidade: array of array of integer;
  matiz, saturacao: array of array of double;
  histOriginal, histResultado, tabela: array[0..255] of integer;
begin
  AjustandoBarra();
  vermelho := 0;
  verde := 0;
  azul := 0;
  h := 0;
  s := 0;
  l := 0;
  soma := 0;
  pixels := ImagemOriginal.Height * ImagemOriginal.Width;

  SetLength(intensidade, ImagemOriginal.Width);
  SetLength(matiz, ImagemOriginal.Width);
  SetLength(saturacao, ImagemOriginal.Width);
  for x := 0 to ImagemOriginal.Width - 1 do
  begin
    SetLength(intensidade[x], ImagemOriginal.Height);
    SetLength(matiz[x], ImagemOriginal.Height);
    SetLength(saturacao[x], ImagemOriginal.Height);
  end;

  for i := 0 to 255 do
  begin
    histOriginal[i] := 0;
    histResultado[i] := 0;
  end;

  for y := 0 to ImagemOriginal.Height - 1 do
    for x := 0 to ImagemOriginal.Width - 1 do
    begin
      ReceberCores(vermelho, verde, azul, x, y);
      ConverterRGBparaHSL(vermelho, verde, azul, h, s, l);
      matiz[x, y] := h;
      saturacao[x, y] := s;
      intensidade[x, y] := Floor(l / 100 * 255);
      Inc(histOriginal[intensidade[x, y]]);
      Atualizar(y);
    end;

  for i := 0 to 255 do
  begin
    soma := soma + histOriginal[i];
    histResultado[i] := soma;
    tabela[i] := Floor(255 * (histResultado[i] / pixels));
  end;

  for y := 0 to ImagemOriginal.Height - 1 do
    for x := 0 to ImagemOriginal.Width - 1 do
    begin

      l := tabela[intensidade[x, y]] / 255 * 100;

      ConverterHSLparaRGB(matiz[x, y], saturacao[x, y], l, vermelho, verde, azul);
      ImagemResultado.Canvas.Pixels[x, y] := RGB(vermelho, verde, azul);
      Atualizar(y);
    end;
  ResetarBarra();
end;

procedure TForm1.MenuItemMaximoClick(Sender: TObject);
var
  x, y, i, j, k: integer;
  vermelho, verde, azul, cinza: integer;
  arr: array[0..8] of integer;
  max: integer;
begin
  vermelho := 0;
  verde := 0;
  azul := 0;

  AjustandoBarra();

  for y := 1 to (ImagemOriginal.Height - 2) do
    for x := 1 to (ImagemOriginal.Width - 2) do
    begin
      k := 0;
      for j := -1 to 1 do
        for i := -1 to 1 do
        begin
          ReceberCores(vermelho, verde, azul, (x + i), (y + j));
          cinza := round(0.299 * vermelho + 0.587 * verde + 0.114 * azul);

          arr[k] := cinza;
          Inc(k);
        end;

      max := arr[0];

      for k := 1 to 8 do
        if arr[k] > max then
          max := arr[k];

      ImagemResultado.Canvas.Pixels[x, y] := RGB(max, max, max);

      Atualizar(y);
    end;

  ResetarBarra();
end;

procedure TForm1.MenuItemPontoMedioClick(Sender: TObject);
var
  x, y, i, j, k: integer;
  vermelho, verde, azul, cinza: integer;
  arr: array[0..8] of integer;
  min, medio, max: integer;
begin
  vermelho := 0;
  verde := 0;
  azul := 0;

  AjustandoBarra();

  for y := 1 to (ImagemOriginal.Height - 2) do
    for x := 1 to (ImagemOriginal.Width - 2) do
    begin
      k := 0;
      for j := -1 to 1 do
        for i := -1 to 1 do
        begin
          ReceberCores(vermelho, verde, azul, (x + i), (y + j));
          cinza := round(0.299 * vermelho + 0.587 * verde + 0.114 * azul);

          arr[k] := cinza;
          Inc(k);
        end;

      min := arr[0];
      max := arr[0];

      for k := 1 to 8 do
        if arr[k] > max then
          max := arr[k];
      if arr[k] < min then
        min := arr[k];
      medio := Floor((min + max) / 2);

      ImagemResultado.Canvas.Pixels[x, y] := RGB(medio, medio, medio);

      Atualizar(y);
    end;

  ResetarBarra();
end;

procedure TForm1.MenuItemPseudoCoresClick(Sender: TObject);
var
  x, y: integer;
  cor: TColor;
  vermelho, verde, azul: integer;
  intensidade, setor: integer;
begin
  vermelho := 0;
  verde := 0;
  azul := 0;

  AjustandoBarra();

  for y := 0 to (ImagemOriginal.Height - 1) do
    for x := 0 to (ImagemOriginal.Width - 1) do
    begin

      cor := ImagemOriginal.Canvas.Pixels[x, y];
      intensidade := GetRValue(cor);

      setor := Floor(intensidade / 64);
      case setor of
        0: begin
          vermelho := 0;
          verde := 0;
          azul := intensidade * 4;
        end;
        1: begin
          vermelho := 0;
          verde := (intensidade - 64) * 4;
          azul := 255;
        end;
        2: begin
          vermelho := 0;
          verde := 255;
          azul := 255 - (intensidade - 128) * 4;
        end;
        3: begin
          vermelho := (intensidade - 192) * 4;
          verde := 255;
          azul := 0;
        end;
      end;
      ImagemResultado.Canvas.Pixels[x, y] := RGB(vermelho, verde, azul);

      Atualizar(y);
    end;

  ResetarBarra();
end;

procedure TForm1.MenuItemSepararColoridoClick(Sender: TObject);
var
  x, y: integer;
  cor: TColor;
  vermelho, verde, azul: integer;
begin
  AjustandoBarra();
  vermelho := 0;
  verde := 0;
  azul := 0;
  for y := 0 to (ImagemOriginal.Height - 1) do
    for x := 0 to (ImagemOriginal.Width - 1) do
    begin
      ReceberCores(vermelho, verde, azul, x, y);

      cor := RGB(vermelho, 0, 0);
      CanalVermelho.Canvas.Pixels[x, y] := cor;

      cor := RGB(0, verde, 0);
      CanalVerde.Canvas.Pixels[x, y] := cor;

      cor := RGB(0, 0, azul);
      CanalAzul.Canvas.Pixels[x, y] := cor;

      Atualizar(y);
    end;
  ResetarBarra();

end;

procedure TForm1.MenuItemMinimoClick(Sender: TObject);
var
  x, y, i, j, k: integer;
  vermelho, verde, azul, cinza: integer;
  arr: array[0..8] of integer;
  min: integer;
begin
  vermelho := 0;
  verde := 0;
  azul := 0;

  ajustandoBarra();

  for y := 1 to (ImagemOriginal.Height - 2) do
    for x := 1 to (ImagemOriginal.Width - 2) do
    begin
      k := 0;
      for j := -1 to 1 do
        for i := -1 to 1 do
        begin
          ReceberCores(vermelho, verde, azul, (x + i), (y + j));

          cinza := round(0.299 * vermelho + 0.587 * verde + 0.114 * azul);

          arr[k] := cinza;
          Inc(k);
        end;

      min := arr[0];

      for k := 1 to 8 do
        if arr[k] < min then
          min := arr[k];

      ImagemResultado.Canvas.Pixels[x, y] := RGB(min, min, min);

      Atualizar(y);
    end;

  ResetarBarra();
end;

procedure TForm1.MenuItemAbrirClick(Sender: TObject);
begin
  if (OpenDialog.Execute) then
  begin
    ImagemOriginal.Picture.LoadFromFile(OpenDialog.FileName);

    ImagemOriginal.Height := ImagemOriginal.Picture.Height;
    ImagemOriginal.Width := ImagemOriginal.Picture.Width;

    ImagemResultado.Height := ImagemOriginal.Height;
    ImagemResultado.Width := ImagemOriginal.Width;
    ImagemResultado.Left := ImagemOriginal.Left + ImagemOriginal.Width + 10;

    CanalVermelho.Height := ImagemOriginal.Height;
    CanalVermelho.Width := ImagemOriginal.Width;
    CanalVermelho.Top := ImagemOriginal.Top + ImagemOriginal.Height + 10;

    CanalVerde.Height := ImagemOriginal.Height;
    CanalVerde.Width := ImagemOriginal.Width;
    CanalVerde.Left := CanalVermelho.Left + CanalVermelho.Width + 10;
    CanalVerde.Top := CanalVermelho.Top;

    CanalAzul.Height := ImagemOriginal.Height;
    CanalAzul.Width := ImagemOriginal.Width;
    CanalAzul.Left := CanalVerde.Left + CanalVerde.Width + 10;
    CanalAzul.Top := CanalVerde.Top;

    ProgressBar.Top := CanalVermelho.Top;

    MoverImagem.Top := ProgressBar.Top + ProgressBar.Height + 10;

    LabelX.Top := MoverImagem.Top + MoverImagem.Height + 10;
    EditX.Top := LabelX.Top - 8;
    LabelY.Top := LabelX.Top;
    EditY.Top := EditX.Top;

    LabelR.Top := LabelX.Top + LabelX.Height + 10;
    EditR.Top := LabelR.Top - 8;
    LabelH.Top := LabelR.Top;
    EditH.Top := EditR.Top;

    LabelG.Top := LabelR.Top + LabelR.Height + 10;
    EditG.Top := LabelG.Top - 8;
    LabelS.Top := LabelG.Top;
    EditS.Top := EditG.Top;

    LabelB.Top := LabelG.Top + LabelG.Height + 10;
    EditB.Top := LabelB.Top - 8;
    LabelV.Top := LabelB.Top;
    EditV.Top := EditB.Top;
  end;

end;

procedure TForm1.MenuItemBinarizacaoClick(Sender: TObject);
var
  input: string;
  x, y, limiar: integer;
  cor: TColor;
  vermelho, verde, azul, cinza: integer;
begin
  vermelho := 0;
  verde := 0;
  azul := 0;

  input := InputBox('Binarização', 'Valor do limiar:', '');

  if input <> '' then
    limiar := Floor(StrToInt(input))
  else
    limiar := Floor(255 / 2);

  for y := 0 to (ImagemOriginal.Height - 1) do
    for x := 0 to (ImagemOriginal.Width - 1) do
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
  x, y: integer;
  cor: TColor;
  vermelho, verde, azul, cinza: integer;
begin
  AjustandoBarra();
  vermelho := 0;
  verde := 0;
  azul := 0;
  for y := 0 to (ImagemOriginal.Height - 1) do
    for x := 0 to (ImagemOriginal.Width - 1) do
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
  x, y: integer;
  vermelho, verde, azul, cinza: integer;
  gama, c, s: double;
  s1, s2: string;
begin
  AjustandoBarra();

  vermelho := 0;
  verde := 0;
  azul := 0;
  cinza := 0;
  s1 := '';
  s2 := '';

  if InputQuery('Compressão S = c*r^(gama)', 'Valor de gama:', s1) then
    if InputQuery('Compressão S = c*r^(gama)', 'Valor de c:', s2) then
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
  x, y: integer;
  vermelho, verde, azul: integer;
  pixels, soma, i: integer;
  cinzas: array of array of integer;
  histOriginal, histResultado, tabela: array[0..255] of integer;
begin
  AjustandoBarra();

  SetLength(cinzas, ImagemOriginal.Width);

  for i := 0 to ImagemOriginal.Width - 1 do
    SetLength(cinzas[i], ImagemOriginal.Height);

  for y := 0 to ImagemOriginal.Height - 1 do
    for x := 0 to ImagemOriginal.Width - 1 do
      cinzas[x, y] := 0;

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
      cinzas[x, y] := Round(0.299 * vermelho + 0.587 * verde + 0.114 * azul);
      histOriginal[cinzas[x, y]] += 1;
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
      cinzas[x, y] := tabela[cinzas[x, y]];
      ImagemResultado.Canvas.Pixels[x, y] := RGB(cinzas[x, y], cinzas[x, y], cinzas[x, y]);
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
  x, y, i: integer;
  cor: TColor;
  vermelho, verde, azul, cinza: integer;
  cinzas: array of array of integer;
begin
  SetLength(cinzas, ImagemOriginal.Width);

  for i := 0 to ImagemOriginal.Width - 1 do
    SetLength(cinzas[i], ImagemOriginal.Height);

  AjustandoBarra();

  vermelho := 0;
  verde := 0;
  azul := 0;

  for y := 1 to (ImagemOriginal.Height - 2) do
    for x := 1 to (ImagemOriginal.Width - 2) do
    begin
      ReceberCores(vermelho, verde, azul, x, y);
      cinzas[x, y] := round(0.299 * vermelho + 0.587 * verde + 0.114 * azul);
      Atualizar(y);
    end;

  for y := 1 to (ImagemOriginal.Height - 2) do
    for x := 1 to (ImagemOriginal.Width - 2) do
    begin

      cinza := (4 * cinzas[x, y]) - cinzas[x + 1, y] -
        cinzas[x - 1, y] - cinzas[x, y + 1] - cinzas[x, y - 1];

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
  x, y, i, j, n: integer;
  cor: TColor;
  vermelho, verde, azul: integer;
  somaVermelho, somaVerde, somaAzul: integer;
begin
  AjustandoBarra();
  vermelho := 0;
  verde := 0;
  azul := 0;

  for y := 1 to (ImagemOriginal.Height - 2) do
    for x := 1 to (ImagemOriginal.Width - 2) do
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
  x, y, i, j, n: integer;
  cor: TColor;
  vermelho, verde, azul: integer;
  vermelhos, verdes, azuis: array[0..8] of integer;
begin
  AjustandoBarra();

  vermelho := 0;
  verde := 0;
  azul := 0;

  for y := 1 to (ImagemOriginal.Height - 2) do
    for x := 1 to (ImagemOriginal.Width - 2) do
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

      n := trunc(n / 2);

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
  x, y: integer;
  cor: TColor;
  vermelho, verde, azul: integer;
begin
  AjustandoBarra();
  vermelho := 0;
  verde := 0;
  azul := 0;
  for y := 0 to (ImagemOriginal.Height - 1) do
    for x := 0 to (ImagemOriginal.Width - 1) do
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

procedure TForm1.MenuItemRestaurarClick(Sender: TObject);
var
  x, y: integer;
  cor: TColor;
  vermelho, verde, azul: integer;
begin
  AjustandoBarra();
  vermelho := 0;
  verde := 0;
  azul := 0;
  for y := 0 to (ImagemOriginal.Height - 1) do
    for x := 0 to (ImagemOriginal.Width - 1) do
    begin
      cor := CanalVermelho.Canvas.Pixels[x, y];
      vermelho := GetRValue(cor);
      cor := CanalVerde.Canvas.Pixels[x, y];
      verde := GetGValue(cor);
      cor := CanalAzul.Canvas.Pixels[x, y];
      azul := GetBValue(cor);

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
  x, y: integer;
  vermelho, verde, azul: integer;
  r, intensidade: double;
  branco: boolean;
  input: string;
begin
  AjustandoBarra();

  vermelho := 0;
  verde := 0;
  azul := 0;

  input := InputBox('Adicionar Ruídos', 'Intensidade dos ruídos:', '');

  if input <> '' then
    intensidade := strToFloat(StringReplace(input, '.', ',', [rfReplaceAll])) / 100
  else
    intensidade := 10 / 100;

  for y := 0 to (ImagemOriginal.Height - 1) do
    for x := 0 to (ImagemOriginal.Width - 1) do
    begin
      r := Random;
      if r < intensidade then
      begin
        branco := (Random < 0.5);

        if branco then
          ImagemResultado.Canvas.Pixels[x, y] := RGB(255, 255, 255)
        else
          ImagemResultado.Canvas.Pixels[x, y] := RGB(0, 0, 0);
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
  fileName: string;
begin
  fileName := InputBox('Salvar Imagem', 'Nome da Imagem:', 'Imagem.png');
  try
    ImagemResultado.Picture.SaveToFile(fileName);
  finally
    ImagemResultado.Free;
  end;
end;

procedure TForm1.MenuItemSepararClick(Sender: TObject);
var
  x, y: integer;
  cor: TColor;
  vermelho, verde, azul: integer;
begin
  AjustandoBarra();
  vermelho := 0;
  verde := 0;
  azul := 0;
  for y := 0 to (ImagemOriginal.Height - 1) do
    for x := 0 to (ImagemOriginal.Width - 1) do
    begin
      ReceberCores(vermelho, verde, azul, x, y);

      cor := RGB(vermelho, vermelho, vermelho);
      CanalVermelho.Canvas.Pixels[x, y] := cor;

      cor := RGB(verde, verde, verde);
      CanalVerde.Canvas.Pixels[x, y] := cor;

      cor := RGB(azul, azul, azul);
      CanalAzul.Canvas.Pixels[x, y] := cor;

      Atualizar(y);
    end;
  ResetarBarra();

end;

procedure TForm1.MoverImagemClick(Sender: TObject);
var
  x, y: integer;
begin
  for y := 0 to (ImagemOriginal.Height - 1) do
    for x := 0 to (ImagemOriginal.Width - 1) do
    begin
      ImagemOriginal.Canvas.Pixels[x, y] := ImagemResultado.Canvas.Pixels[x, y];
    end;
end;

procedure ConverterRGBparaHSV(r, g, b: integer; var h, s, v: double);
var
  vermelhoTemp, verdeTemp, azulTemp: double;
  delta, menor, maior: double;
begin
  vermelhoTemp := r / 255;
  verdeTemp := g / 255;
  azulTemp := b / 255;

  maior := Max(Max(vermelhoTemp, verdeTemp), azulTemp);
  menor := Min(Min(vermelhoTemp, verdeTemp), azulTemp);
  delta := maior - menor;

  v := maior;

  if (maior = 0) then
    s := 0
  else
    s := delta / maior;

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

procedure ConverterHSVparaRGB(h, s, v: double; var r, g, b: integer);
var
  croma, secundario, ajuste: double;
  vermelhoTemp, verdeTemp, azulTemp: double;
  setor: integer;
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
    0: begin
      vermelhoTemp := croma;
      verdeTemp := secundario;
      azulTemp := 0;
    end;
    1: begin
      vermelhoTemp := secundario;
      verdeTemp := croma;
      azulTemp := 0;
    end;
    2: begin
      vermelhoTemp := 0;
      verdeTemp := croma;
      azulTemp := secundario;
    end;
    3: begin
      vermelhoTemp := 0;
      verdeTemp := secundario;
      azulTemp := croma;
    end;
    4: begin
      vermelhoTemp := secundario;
      verdeTemp := 0;
      azulTemp := croma;
    end;
    5: begin
      vermelhoTemp := croma;
      verdeTemp := 0;
      azulTemp := secundario;
    end;
    else
    begin
      vermelhoTemp := 0;
      verdeTemp := 0;
      azulTemp := 0;
    end;
  end;

  r := round(vermelhoTemp + ajuste) * 255;
  g := round(verdeTemp + ajuste) * 255;
  b := round(azulTemp + ajuste) * 255;
end;

procedure TForm1.ReceberCores(var r, g, b: integer; x, y: integer);
var
  cor: TColor;
begin
  cor := ImagemOriginal.Canvas.Pixels[x, y];
  r := GetRValue(cor);
  g := GetGValue(cor);
  b := GetBValue(cor);
end;

procedure OrdenarArray(var arr: array of integer);
var
  i, j, temp: integer;
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
  ProgressBar.Max := ImagemOriginal.Height;
end;

procedure TForm1.Atualizar(y: integer);
begin
  ProgressBar.Position := y;
  Application.ProcessMessages;
end;

procedure TForm1.ResetarBarra();
begin
  ProgressBar.Position := 0;
  Application.ProcessMessages;
end;

procedure ConverterRGBparaHSL(r, g, b: integer; var h, s, l: double);
var
  vermelhoTemp, verdeTemp, azulTemp: double;
  big, small, delta: double;
begin
  vermelhoTemp := r / 255.0;
  verdeTemp := g / 255.0;
  azulTemp := b / 255.0;

  big := Max(Max(vermelhoTemp, verdeTemp), azulTemp);
  small := Min(Min(vermelhoTemp, verdeTemp), azulTemp);
  delta := big - small;

  l := (big + small) / 2.0;

  if delta = 0 then
  begin
    s := 0;
    h := 0;
  end
  else
  begin
    s := delta / (1 - (Abs((2 * l) - 1)));

    if big = vermelhoTemp then
      h := (((verdeTemp - azulTemp) / delta) mod 6)
    else if big = verdeTemp then
      h := ((azulTemp - vermelhoTemp) / delta + 2)
    else if big = azulTemp then
      h := ((vermelhoTemp - verdeTemp) / delta + 4);
  end;
  h := Round(h * 60);
  l := Round(l * 100);
  s := Round(s * 100);
end;

procedure ConverterHSLparaRGB(h, s, l: double; var r, g, b: integer);
var
  c, x, m: double;
  vermelhoTemp, verdeTemp, azulTemp: double;
  setor: integer;
begin
  h := h mod 360;
  if (h < 0) then h := h + 360;
  if (s > 1) then s := s / 100;
  if (l > 1) then l := l / 100;

  c := (1 - Abs(2 * l - 1)) * s;
  x := c * (1 - Abs((h / 60) mod 2 - 1));
  m := l - (c / 2);

  setor := Floor(h / 60);
  case setor of
    0: begin
      vermelhoTemp := c;
      verdeTemp := x;
      azulTemp := 0;
    end;
    1: begin
      vermelhoTemp := x;
      verdeTemp := c;
      azulTemp := 0;
    end;
    2: begin
      vermelhoTemp := 0;
      verdeTemp := c;
      azulTemp := x;
    end;
    3: begin
      vermelhoTemp := 0;
      verdeTemp := x;
      azulTemp := c;
    end;
    4: begin
      vermelhoTemp := x;
      verdeTemp := 0;
      azulTemp := c;
    end;
    5: begin
      vermelhoTemp := c;
      verdeTemp := 0;
      azulTemp := x;
    end;
  end;

  r := Round((vermelhoTemp + m) * 255);
  g := Round((verdeTemp + m) * 255);
  b := Round((azulTemp + m) * 255);
end;



end.
