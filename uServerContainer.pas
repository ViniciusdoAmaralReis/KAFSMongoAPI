unit uServerContainer;

interface

uses
  System.Classes, System.SysUtils,
  Datasnap.DSAuth, Datasnap.DSCommonServer, Datasnap.DSServer,
  Datasnap.DSTCPServerTransport,
  IPPeerAPI, IPPeerServer;

type
  TServerContainer = class(TDataModule)
    DSServer: TDSServer;
    DSTCPServerTransport: TDSTCPServerTransport;
    DSServerClass: TDSServerClass;

    procedure DSServerClassGetClass(DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
  end;

  procedure RunDSServer;

var
  _resfriamento: Integer = 0;

implementation

{%CLASSGROUP 'System.Classes.TPersistent'}

{$R *.dfm}

uses
  uKAFSConexaoMongoDBAtlas, uKAFSFuncoes, uServerMethods;

procedure TServerContainer.DSServerClassGetClass(DSServerClass: TDSServerClass; var PersistentClass: TPersistentClass);
begin
  PersistentClass := uServerMethods.TServerMethods;
end;
//------------------------------------------------------------------------------
function TestarPorta(const _porta: Integer): Boolean;
begin
  Result := True;

  try
    var _testar := PeerFactory.CreatePeer('', IIPTestServer) as IIPTestServer;
    _testar.TestOpenPort(_porta, nil);
  except
    Result := False;
  end;
end;
function VerificarPorta(const _porta: Integer): Integer;
begin
  if TestarPorta(_porta) then
    Result := _porta
  else
    Result := 0;
end;
//------------------------------------------------------------------------------
procedure ValidarMongoDBAtlas;
begin
  try
    Writeln('MONGODB ATLAS');
    Writeln('   - Testando conex�o');

    var _mongodb := TKAFSConexaoMongoDBAtlas.Create(nil);
    try
      Writeln('   - Conex�o ok');
    finally
      FreeAndNil(_mongodb);
    end;

    var _testar := LerIni('cache', 'mongodb', 'resfriamento');
    if (_testar = '') or
       (_testar = '0') then
      Writeln('   - Resfriamento desativado')
    else
      Writeln('   - Resfriamento ' + _testar + 'ms');
  except
    on E: Exception do
      Writeln('Erro: ' + E.Message);
  end;

  Writeln('----------------------------------------');
end;
function ValidarPorta: Integer;
begin
  Writeln('DATASNAP');
  Writeln('   - Testando porta');

  // Busca hist�rico local de porta
  var _porta := LerIni('cache', 'datasnap', 'porta');
  var _valor: Integer;
  var _ok := False;

  repeat
    // Verifica se � um valor inteiro
    if not TryStrToInt(_porta, _valor) then
    begin
      Writeln('Erro: Porta n�o definida e/ou inv�lida');
      Write('   - Nova porta >');
      Readln(_porta);
      Writeln(' ');

      Continue;
    end;

    // Verifica se a porta est� na faixa v�lida
    if (_valor < 1) or (_valor > 65535) then
    begin
      Writeln('Erro: Porta deve estar entre 1 e 65535');
      Write('   - Nova porta >');
      Readln(_porta);
      Writeln(' ');

      Continue;
    end;

    // Verifica se a porta j� est� em uso
    if VerificarPorta(StrToInt(_porta)) = 0 then
    begin
      Writeln('Erro: Porta j� est� em uso');
      Write('   - Nova porta >');
      Readln(_porta);
      Writeln(' ');

      Continue;
    end;

    _ok := True;

    Writeln('   - Porta ok');
    Writeln('----------------------------------------');
  until _ok;

  Result := StrToInt(_porta);
end;

procedure Start(const _servidor: TServerContainer);
begin
  var _start := True;

  if _servidor.DSServer.Started then
  begin
    Writeln('   - O servidor j� est� em execu��o');
    _start := False;
  end
  else
    if VerificarPorta(_servidor.DSTCPServerTransport.Port) <= 0 then
    begin
      Writeln(Format('   - Erro: Porta %s j� est� em uso', [_servidor.DSTCPServerTransport.Port.ToString]));
      _start := False;
    end;

  if _start then
  begin
    Writeln('   - Iniciando o servidor');
    _servidor.DSServer.Start;
    Writeln(' ');
    Writeln('SERVIDOR ONLINE');
    Writeln('   IP privado:   ' + uKAFSFuncoes.IPPrivado);
    Writeln('   IP p�blico:   ' + uKAFSFuncoes.IPPublico);
    Writeln('   Porta:        ' + _servidor.DSTCPServerTransport.Port.ToString);
  end;

  Writeln('----------------------------------------');
  Write('>');
end;
procedure Stop(const _servidor: TServerContainer);
begin
  if _servidor.DSServer.Started then
  begin
    Writeln('   - Parando o servidor');
    _servidor.DSServer.Stop;
    Writeln(' ');
    Writeln('SERVIDOR OFFLINE');
  end
  else
    Writeln('   - O servidor n�o est� em execu��o');

  Writeln('----------------------------------------');
  Write('>');
end;
procedure DefinirPorta(const _servidor: TServerContainer);
begin
  if _servidor.DSServer.Started then
    Writeln('   - Erro: N�o � poss�vel a altera��o com o servidor online')
  else
  begin
    var _porta: Integer;

    Write('   - Nova porta >');
    Readln(_porta);

    if VerificarPorta(_porta) > 0 then
    begin
      _servidor.DSTCPServerTransport.Port := _porta;
      Writeln('   - Nova porta definida');

      // Salva porta para inicializa��o futura
      SalvarIni('cache', 'datasnap', 'porta', IntToStr(_porta));
    end
    else
      Writeln('   - Erro: Porta j� est� em uso');
  end;

  Writeln('----------------------------------------');
  Write('>');
end;
procedure Status(const _servidor: TServerContainer);
begin
  Writeln('   Online:       ' + _servidor.DSServer.Started.ToString(TUseBoolStrs.True));
  Writeln('   IP privado:   ' + uKAFSFuncoes.IPPrivado);
  Writeln('   IP p�blico:   ' + uKAFSFuncoes.IPPublico);
  Writeln('   Porta:        ' + _servidor.DSTCPServerTransport.Port.ToString);
  Writeln('----------------------------------------');
  Write('>');
end;
procedure Resfriamento;
begin
  Write('   - Resfriamento em milisegundos (0: Para acesso livre) >');
  Readln(_resfriamento);

  SalvarIni('cache', 'mongodb', 'resfriamento', IntToStr(_resfriamento));

  Writeln('   - Resfriamento definido');
  Writeln('----------------------------------------');
  Write('>');
end;

procedure StatusDataSnap(const _porta: Integer);
begin
  Writeln('SERVIDOR ONLINE');
  Writeln('   IP privado:   ' + uKAFSFuncoes.IPPrivado);
  Writeln('   IP p�blico:   ' + uKAFSFuncoes.IPPublico);
  Writeln('   Porta:        ' + IntToStr(_porta));
  Writeln('----------------------------------------');
end;
procedure Comandos;
begin
  Writeln('COMANDOS: ');
  Writeln('   - "start"      iniciar o servidor');
  Writeln('   - "stop"       parar o servidor');
  Writeln('   - "set port"   mudar a porta padr�o');
  Writeln('   - "status"     vizualizar status do servidor');
  Writeln('   - "cooldown"   cria fila e resfriamento de acesso ao MongoDB Atlas');
  Writeln('   - "test mongo" testar conex�o com MongoDB Atlas');
  Writeln('   - "help"       vizualizar comandos');
  Writeln('   - "exit"       fechar o aplicativo');
  Writeln('----------------------------------------');
  Write('>');
end;

procedure RunDSServer;
begin
  ValidarMongoDBAtlas;

  var _modulo := TServerContainer.Create(nil);
  try
    // Associa a porta escolhida
    _modulo.DSTCPServerTransport.Port := ValidarPorta;

    try
      // Tenta iniciar o servidor
      _modulo.DSServer.Start;
    except
      on E: Exception do
      begin
        Writeln('Erro: ' + E.Message);
        Exit;
      end;
    end;

    // Salva porta para inicializa��o futura
    SalvarIni('cache', 'datasnap', 'porta', IntToStr(_modulo.DSTCPServerTransport.Port));

    // Exibe status
    StatusDataSnap(_modulo.DSTCPServerTransport.Port);

    // Exibe lista de comandos v�lidos
    Comandos;

    var _resposta: String;

    // Loop mantendo servido no aguardo
    while True do
    begin
      Readln(_resposta);
      _resposta := LowerCase(_resposta);

      // Analisa cada comando
      if SameText(_resposta, 'start') then
        Start(_modulo)
      else if SameText(_resposta, 'status') then
        Status(_modulo)
      else if SameText(_resposta, 'stop') then
        Stop(_modulo)
      else if _resposta.StartsWith('set port') then
        DefinirPorta(_modulo)
      else if _resposta.StartsWith('cooldown') then
        Resfriamento
      else if _resposta.StartsWith('test mongo') then
      begin
        ValidarMongoDBAtlas;
        Write('>');
      end
      else if SameText(_resposta, 'help') then
        Comandos
      else if SameText(_resposta, 'exit') then
      begin
        if _modulo.DSServer.Started then
          Stop(_modulo);

        Break
      end
      else
      begin
        Writeln('   - Erro: Comando inv�lido');
        Writeln(' ');
        Write('>');
      end;
    end;
  finally
    FreeAndNil(_modulo);
  end;

  Halt;
end;

end.

