unit uServerMethods;

interface

uses
  System.Classes, System.Generics.Collections, System.Json;

type
{$METHODINFO ON}
  TServerMethods = class(TComponent)

    function InserirDadosMongoDB(const _banco, _colecao: String; const _dados: TJSONObject): TJSONObject;
    function EditarDadosMongoDB(const _banco, _colecao: String; const _filtros, _atualizacoes: TJSONObject): TJSONObject;
    function BuscarDadosMongoDB(const _banco, _colecao: string; const _filtros: TJSONObject): TJSONObject;
    function ExcluirDadosMongoDB(const _banco, _colecao: String; const _filtros: TJSONObject): TJSONObject;
  end;
{$METHODINFO OFF}

implementation

uses
  uKAFSMongoDB;

function TServerMethods.InserirDadosMongoDB(const _banco, _colecao: String; const _dados: TJSONObject): TJSONObject;
begin
  Result := InserirDados(_banco, _colecao, _dados);
end;
function TServerMethods.EditarDadosMongoDB(const _banco, _colecao: String; const _filtros, _atualizacoes: TJSONObject): TJSONObject;
begin
  Result := EditarDados(_banco, _colecao, _filtros, _atualizacoes);
end;
function TServerMethods.BuscarDadosMongoDB(const _banco, _colecao: string; const _filtros: TJSONObject): TJSONObject;
begin
  Result := BuscarDados(_banco, _colecao, _filtros);
end;
function TServerMethods.ExcluirDadosMongoDB(const _banco, _colecao: String; const _filtros: TJSONObject): TJSONObject;
begin
  Result := ExcluirDados(_banco, _colecao, _filtros);
end;

end.

