unit Unit2;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { Conversor }

  Conversor = class(TForm)
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
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Conversor: Conversor;

implementation

{$R *.lfm}

{ Conversor }

procedure Conversor.FormCreate(Sender: TObject);
begin

end;

end.

