unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, Math;

type

  { TForm2 }

  TForm2 = class(TForm)
    ButtonClose: TButton;
    ConverterHSVRGB: TButton;
    EditB: TEdit;
    EditG: TEdit;
    EditH: TEdit;
    EditR: TEdit;
    EditS: TEdit;
    EditV: TEdit;
    LabelB: TLabel;
    LabelG: TLabel;
    LabelH: TLabel;
    LabelR: TLabel;
    LabelS: TLabel;
    LabelV: TLabel;
    ConverterRGBHSV: TButton;
    procedure ButtonCloseClick(Sender: TObject);
    procedure ConverterHSVRGBClick(Sender: TObject);
    procedure ConverterRGBHSVClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

  procedure ConverterHSVparaRGB(h,s,v : Double; var r,g,b : Integer);
  procedure ConverterRGBparaHSV(r, g, b : Integer; var h, s, v : Double);

var
  Form2: TForm2;

implementation

{$R *.lfm}

{ TForm2 }

procedure TForm2.ConverterRGBHSVClick(Sender: TObject);
var
  vermelho, verde, azul : Integer;
  matiz, saturacao, valor : Double;
begin
  vermelho := StrToInt(EditR.Text);
  verde := StrToInt(EditG.Text);
  azul := StrToInt(EditB.Text);
  matiz := 0.0;
  saturacao := 0.0;
  valor := 0.0;

  ConverterRGBparaHSV(vermelho, verde, azul, matiz, saturacao, valor);

  EditR.Text := IntToStr(vermelho);
  EditG.Text := IntToStr(verde);
  EditB.Text := IntToStr(azul);

  EditH.Text := FloatToStr(matiz);
  EditS.Text := FloatToStr(saturacao);
  EditV.Text := FloatToStr(valor);
end;

procedure TForm2.ConverterHSVRGBClick(Sender: TObject);
var
  vermelho, verde, azul : Integer;
  matiz, saturacao, valor : Double;
begin
  vermelho := 0;
  verde := 0;
  azul := 0;
  matiz := StrToFloat(EditH.Text);
  saturacao := StrToFloat(EditS.Text);
  valor := StrToFloat(EditV.Text);

  ConverterRGBparaHSV(vermelho, verde, azul, matiz, saturacao, valor);

  EditR.Text := IntToStr(vermelho);
  EditG.Text := IntToStr(verde);
  EditB.Text := IntToStr(azul);

  EditH.Text := FloatToStr(matiz);
  EditS.Text := FloatToStr(saturacao);
  EditV.Text := FloatToStr(valor);
end;

procedure TForm2.ButtonCloseClick(Sender: TObject);
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

end.

