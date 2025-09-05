program KAFSServidorDataSnap_CMD;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  uServerMethods in 'uServerMethods.pas',
  uServerContainer in 'uServerContainer.pas' {ServerContainer: TDataModule},
  uKAFSFuncoes in '..\uKAFSFuncoes\uKAFSFuncoes.pas',
  uKAFSMongoDB in '..\uKAFSMongoDB\uKAFSMongoDB.pas',
  uKAFSConexaoMongoDBAtlas in '..\TKAFSConexaoMongoDBAtlas\uKAFSConexaoMongoDBAtlas.pas';

begin
  try
    RunDSServer;
    ReadLn;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end
end.

