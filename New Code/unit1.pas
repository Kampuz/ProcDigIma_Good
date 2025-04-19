unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, Menus, StdCtrls,
  ExtCtrls;

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
    procedure FormCreate(Sender: TObject);
    procedure ImagemOriginalClick(Sender: TObject);
    procedure LabelSClick(Sender: TObject);
    procedure MoverImagemClick(Sender: TObject);
    procedure MenuItemImagemClick(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.MenuItemImagemClick(Sender: TObject);
begin

end;

procedure TForm1.MoverImagemClick(Sender: TObject);
begin

end;

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.ImagemOriginalClick(Sender: TObject);
begin

end;

procedure TForm1.LabelSClick(Sender: TObject);
begin

end;

end.

