program APIMAQUINETA;

uses
  System.StartUpCopy,
  FMX.Forms,
  uPrincipal in 'scr\uPrincipal.pas' {frmPrincipal},
  API.MercadoPago.Maquineta in 'scr\API.MercadoPago.Maquineta.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
