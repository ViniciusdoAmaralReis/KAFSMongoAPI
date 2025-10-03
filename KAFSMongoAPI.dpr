program KAFSMongoAPI;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  uServerMethods in 'uServerMethods.pas',
  uServerContainer in 'uServerContainer.pas' {ServerContainer: TDataModule},
  uKAFSConexaoMongo in '..\TKAFSConexaoMongo\uKAFSConexaoMongo.pas',
  uKAFSMongo in '..\uKAFSMongo\uKAFSMongo.pas',
  uKAFSFuncoes in '..\uKAFSFuncoes\uKAFSFuncoes.pas';

begin
  try
    for var I := 1 to ParamCount do
      if (ParamStr(I) = '-p') and (I < ParamCount) then
        SalvarIni('cache', 'datasnap', 'porta', ParamStr(I + 1))
      else
        if (ParamStr(I) = '-u') and (I < ParamCount) then
          SalvarIni('cache', 'mongodb', 'nome', ParamStr(I + 1))
        else
          if (ParamStr(I) = '-s') and (I < ParamCount) then
            SalvarIni('cache', 'mongodb', 'senha', ParamStr(I + 1))
          else
            if (ParamStr(I) = '-h') and (I < ParamCount) then
              SalvarIni('cache', 'mongodb', 'servidor', ParamStr(I + 1))
            else
              if (ParamStr(I) = '-c') and (I < ParamCount) then
                SalvarIni('cache', 'mongodb', 'resfriamento', ParamStr(I + 1));

    RunDSServer;
    ReadLn;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end
end.

