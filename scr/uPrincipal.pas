unit uPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Edit;

type
  TfrmPrincipal = class(TForm)
    layRodape: TLayout;
    btnGerarCobranca: TRectangle;
    Label1: TLabel;
    Layout1: TLayout;
    edtValor: TEdit;
    Layout2: TLayout;
    edtDescricao: TEdit;
    Layout3: TLayout;
    GroupBox1: TGroupBox;
    rdCredito: TRadioButton;
    RadioButton1: TRadioButton;
    rdDebito: TRadioButton;
    Layout4: TLayout;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;

implementation

{$R *.fmx}

end.
