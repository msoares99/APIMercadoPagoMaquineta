{
  ===========================================================================

  Copyright (c) 2023 MANASSÉS DE ASSIS SOARES

  Todos os direitos reservados.

  [Classe de conexão com a API do MercadoPago para integração com maquinetas]

  ===========================================================================
}

unit API.MercadoPago.Maquineta;

interface

uses
  System.JSON, REST.Types, REST.Client, FMX.Dialogs;

type
  TMeioPagamento = (mpCredito, mpDebito, mpPix);
  TAPIMercadoPagoMaquineta = class
    private
      FAccessToken: string;
      FValor: string;
      FDescricao: string;
      FMeioPagamento: TMeioPagamento;
    FIdCobranca: string;
      procedure SetAccessToken(const Value: string);
      procedure SetDescricao(const Value: string);
      procedure SetMeioPagamento(const Value: TMeioPagamento);
      procedure SetValor(const Value: string);
      function MontarJson(): string;
      function RecuperarIdCobranca(pString: string): string;
      function VerificarPagamentoCobranca(pIdCobranca: string): boolean;
      procedure CriarIntencaoPagamento();
    procedure SetIdCobranca(const Value: string);
    public
      property IdCobranca: string read FIdCobranca write SetIdCobranca;
      property Valor: string read FValor write SetValor;
      property Descricao: string read FDescricao write SetDescricao;
      property MeioPagamento: TMeioPagamento read FMeioPagamento write SetMeioPagamento;
      property AccessToken: string read FAccessToken write SetAccessToken;
  end;

implementation

{ TAPIMercadoPagoMaquineta }

procedure TAPIMercadoPagoMaquineta.CriarIntencaoPagamento();
var
  lRESTClient: TRESTClient;
  lRESTRequest: TRESTRequest;
  lRESTResponse: TRESTResponse;
begin
  lRESTClient := TRESTClient.Create('https://api.mercadopago.com/v1/payments');
  lRESTRequest := TRESTRequest.Create(nil);
  lRESTResponse := TRESTResponse.Create(nil);
  try
    lRESTClient.Accept := 'application/json';
    lRESTRequest.Client := lRESTClient;
    lRESTRequest.Response := lRESTResponse;
    lRESTRequest.Method := TRESTRequestMethod.rmPOST;
    lRESTRequest.Accept := 'application/json';
    lRESTRequest.AcceptCharset := 'utf-8, *;q=0.8';
    lRESTRequest.Params.Clear;
    lRESTRequest.Params.AddItem('Authorization', 'Bearer ' + FAccessToken, TRESTRequestParameterKind.pkHTTPHEADER, [poDoNotEncode]);
    lRESTRequest.Params.AddItem('Content-Type', 'application/json', TRESTRequestParameterKind.pkHTTPHEADER, [poDoNotEncode]);
    lRESTRequest.AddBody(MontarJson(), TRESTContentType.ctAPPLICATION_JSON);
    lRESTRequest.Execute;

    if (lRESTResponse.StatusCode = 201) then
     FIdCobranca := RecuperarIdCobranca(lRESTResponse.Content)
    else
      ShowMessage('Erro ao gerar cobrança PIX: ' + lRESTResponse.Content);
  finally
    lRESTClient.Free;
    lRESTRequest.Free;
    lRESTResponse.Free;
  end;
end;

function TAPIMercadoPagoMaquineta.MontarJson(): string;
var
  lJsonObj, lPaymentObj, lAdditionalInfoObj: TJSONObject;
begin
  lJsonObj := TJSONObject.Create;
  try
    lJsonObj.AddPair('amount', TJSONNumber.Create(FValor));
    lJsonObj.AddPair('description', FDescricao);

    lPaymentObj := TJSONObject.Create;
    lPaymentObj.AddPair('installments', TJSONNumber.Create(1));
    lPaymentObj.AddPair('type', 'credit_card');

    lJsonObj.AddPair('payment', lPaymentObj);

    lAdditionalInfoObj := TJSONObject.Create;
    lAdditionalInfoObj.AddPair('external_reference', 'MASInfo');
    lAdditionalInfoObj.AddPair('print_on_terminal', TJSONBool.Create(True));

    lJsonObj.AddPair('additional_info', lAdditionalInfoObj);

    Result := lJsonObj.ToString;
  finally
    lJsonObj.Free;
  end;

end;

function TAPIMercadoPagoMaquineta.RecuperarIdCobranca(pString: string): string;
var
  lJsonObj: TJSONObject;
begin
  Result := '';

  lJsonObj := TJSONObject.ParseJSONValue(pString) as TJSONObject;
  try
    if Assigned(lJsonObj) then
    begin
      if lJsonObj.TryGetValue<string>('id', Result) then
        Result := lJsonObj.Values['id'].Value;
    end;
finally
    lJsonObj.Free;
  end;
end;

procedure TAPIMercadoPagoMaquineta.SetAccessToken(const Value: string);
begin
  FAccessToken := Value;
end;

procedure TAPIMercadoPagoMaquineta.SetDescricao(const Value: string);
begin
  FDescricao := Value;
end;

procedure TAPIMercadoPagoMaquineta.SetIdCobranca(const Value: string);
begin
  FIdCobranca := Value;
end;

procedure TAPIMercadoPagoMaquineta.SetMeioPagamento(const Value: TMeioPagamento);
begin
  FMeioPagamento := Value;
end;

procedure TAPIMercadoPagoMaquineta.SetValor(const Value: string);
begin
  FValor := Value;
end;

function TAPIMercadoPagoMaquineta.VerificarPagamentoCobranca(pIdCobranca: string): boolean;
var
  lJsonObj: TJSONObject;
  lStateValue: string;
begin
  Result := False;

  lJsonObj := TJSONObject.ParseJSONValue(pIdCobranca) as TJSONObject;
  try
    if Assigned(lJsonObj) then
    begin
      if lJsonObj.TryGetValue<string>('state', lStateValue) then
        Result := (lStateValue = 'FINISHED');
    end;
  finally
    lJsonObj.Free;
  end;
end;

end.
