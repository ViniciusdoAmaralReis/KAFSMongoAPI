unit uServerMethods;

interface

uses
  System.Classes, System.DateUtils, System.JSON, System.SysUtils,
  Data.DBXCommon;

type
{$METHODINFO ON}
  TServerMethods = class(TComponent)

    function Ping: Boolean;
    function Timer: Int64;
    procedure InserirDadosMongoDB(const _base, _colecao: String; const _dados: TJSONArray);
    procedure EditarDadosMongoDB(const _base, _colecao, _filtros: String; const _dados: TJSONArray);
    function BuscarDadosMongoDB(const _base, _colecao, _filtros, _projecoes: String): TJSONArray;
    procedure ExcluirDadosMongoDB(const _base, _colecao, _filtros: String);
  end;
{$METHODINFO OFF}

implementation

uses
  uKAFSMongoDB, uServerContainer;

function TServerMethods.Ping: Boolean;
begin
  try
    Result := True;
  except
    on E: Exception do
      raise TDBXError.Create(0, 'Erro no servidor: ' + E.Message);
  end;
end;
function TServerMethods.Timer: Int64;
begin
  try
    Result := DateTimeToUnix(Now);
  except
    on E: Exception do
      raise TDBXError.Create(0, 'Erro no servidor: ' + E.Message);
  end;
end;

procedure TServerMethods.InserirDadosMongoDB(const _base, _colecao: String; const _dados: TJSONArray);
begin
  try
    InserirDados(_resfriamento, _base, _colecao, _dados);
  except
    on E: Exception do
      raise TDBXError.Create(0, 'Erro no servidor: ' + E.Message);
  end;
end;
procedure TServerMethods.EditarDadosMongoDB(const _base, _colecao, _filtros: String; const _dados: TJSONArray);
begin
  try
    EditarDados(_resfriamento, _base, _colecao, _filtros, _dados);
  except
    on E: Exception do
      raise TDBXError.Create(0, 'Erro no servidor: ' + E.Message);
  end;
end;
function TServerMethods.BuscarDadosMongoDB(const _base, _colecao, _filtros, _projecoes: String): TJSONArray;
begin
  try
    var _temp: TJSONArray := nil;
    try
      _temp := BuscarDados(_resfriamento, _base, _colecao, _filtros, _projecoes);
      Result := _temp.Clone as TJSONArray;
    finally
      FreeAndNil(_temp);
    end;
  except
    on E: Exception do
      raise TDBXError.Create(0, 'Erro no servidor: ' + E.Message);
  end;
end;
procedure TServerMethods.ExcluirDadosMongoDB(const _base, _colecao, _filtros: String);
begin
  try
    ExcluirDados(_resfriamento, _base, _colecao, _filtros);
  except
    on E: Exception do
      raise TDBXError.Create(0, 'Erro no servidor: ' + E.Message);
  end;
end;

end.

