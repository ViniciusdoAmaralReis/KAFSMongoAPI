<div align="center">
<img width="223" height="200" alt="Logo" src="https://github.com/user-attachments/assets/3a33800c-24e5-47bd-b086-6851796932e6" /></div><p>

# <div align="center"><strong>KAFS Mongo API</strong></div> 

<div align="center">
Servidor DataSnap integrado com MongoDB Atlas para persistência de dados.<br>
Oferece endpoints RESTful para operações básicas de banco de dados.
</p>

[![Delphi](https://img.shields.io/badge/Delphi-12.3+-B22222?logo=delphi)](https://www.embarcadero.com/products/delphi)
[![DataSnap](https://img.shields.io/badge/DataSnap-Server-007ACC)]([https://www.embarcadero.com/products/datasnap](https://docwiki.embarcadero.com/RADStudio/Athens/en/Developing_DataSnap_Applications))
[![FireDAC](https://img.shields.io/badge/FireDAC-Connector-FF6600)]([https://www.embarcadero.com/products/firedac](https://docwiki.embarcadero.com/RADStudio/Athens/en/FireDAC))
[![MongoDB](https://img.shields.io/badge/MongoDB-Atlas-47A248?logo=mongodb)](https://www.mongodb.com/atlas)
[![Multiplatform](https://img.shields.io/badge/Multiplatform-Windows/Linux-8250DF)]([https://www.embarcadero.com/products/delphi/cross-platform](https://docwiki.embarcadero.com/RADStudio/Athens/en/Developing_Multi-Device_Applications))
[![Docker](https://img.shields.io/badge/Docker-Container-2496ED?logo=docker)](https://www.docker.com)
[![License](https://img.shields.io/badge/License-GPLv3-blue)](LICENSE)
</div><br>

## ⚠️ Dependências externas
- [TKAFSConexaoMongo](https://github.com/ViniciusdoAmaralReis/TKAFSConexaoMongo) 
- [uKAFSFuncoes](https://github.com/ViniciusdoAmaralReis/uKAFSFuncoes) 
- [uKAFSMongoDB](https://github.com/ViniciusdoAmaralReis/uKAFSMongoDB) 
- *[TKAFSConexaoDataSnap](https://github.com/ViniciusdoAmaralReis/TKAFSConexaoDataSnap)

*Componente utilizado nos exemplos de consumo no cliente. Não é necessário para compilar este projeto servidor.
<div></div><br><br>


## 🪟 Executar no Windows
```bash
KAFSMongoDBAPI.exe -p porta -u usuario_mongodbatlas -s senha_mongodbatlas -h servidor_mongodbatlas -c resfriamento_em_milisegundos_mongodbatlas 
```
ou somente
```bash
KAFSMongoDBAPI.exe
```
<div></div><br><br>


## 🐧 Executar no Linux
```bash
chmod +x KAFSMongoDBAPI
./KAFSMongoDBAPI -p porta -u usuario_mongodbatlas -s senha_mongodbatlas -h servidor_mongodbatlas -c resfriamento_em_milisegundos_mongodbatlas
```
ou somente
```bash
chmod +x KAFSMongoDBAPI
./KAFSMongoDBAPI
```
*(-c "tempo_em_milisegundos") Todas as requisições respeitarão uma fila e um tempo determinado antes de serem executadas. Isso evita estouro de condições de planos do MongoDB Atlas. 

*(-c 0) Caso determine como ZERO, não será montada fila e todas as requisições serão executadas livremente em tempo real.

*O sistema também pode ser executado sem determinar nenhuma configuração, neste caso as configurações serão requisitadas internamente na primeira execução.
<div></div><br><br>


## ⚡ Método - Ping
```pascal
function TServerMethods.Ping: Boolean;
```
🏛️ Exemplo de consumo no cliente:
```pascal
var ServidorAtivo := ServerMethods.Ping;
if ServidorAtivo then
  ShowMessage('Servidor respondendo corretamente')
else
  ShowMessage('Servidor indisponível');
```
<div></div><br><br>


## ⚡ Método - Timer
```pascal
function TServerMethods.Timer: Int64;
```
🏛️ Exemplo de consumo no cliente:
```pascal
var TimestampServidor := ServerMethods.Timer;
ShowMessage('Timestamp do servidor: ' + IntToStr(TimestampServidor));
```
<div></div><br><br>


## ⚡ Método - Inserir dados
```pascal
procedure TServerMethods.InserirDadosMongoDB(const _base, _colecao: String; const _dados: TJSONArray);
```
🏛️ Exemplo de consumo no cliente:
```pascal
var _dadosinserir := TJSONArray.Create;
var _novousuario: TJSONObject;
try
  // Primeiro documento
  _novousuario := TJSONObject.Create;
  _novousuario.AddPair('nome', 'João Silva');
  _novousuario.AddPair('email', 'joao@empresa.com');
  _novousuario.AddPair('data_nascimento', TJSONNumber.Create(831456000)); // Unix: 01/05/1996
  _novousuario.AddPair('departamento', 'TI');
  _novousuario.AddPair('salario', TJSONNumber.Create(4500.00));
  _novousuario.AddPair('ativo', TJSONBool.Create(True));
  _dadosinserir.AddElement(_novousuario);

  // Segundo documento
  _novousuario := TJSONObject.Create;
  _novousuario.AddPair('nome', 'Maria Santos');
  _novousuario.AddPair('email', 'maria@empresa.com');
  _novousuario.AddPair('data_nascimento', TJSONNumber.Create(713808000)); // Unix: 15/08/1992
  _novousuario.AddPair('departamento', 'TI');
  _novousuario.AddPair('salario', TJSONNumber.Create(5200.00));
  _novousuario.AddPair('ativo', TJSONBool.Create(True));
  _dadosinserir.AddElement(_novousuario);

  // Adicione quantos documentos forem necessários...

  // Executa inserção
  ServerMethods.InserirDadosMongoDB('nome_base', 'nome_coleção', _dadosinserir);
  ShowMessage('Dados inseridos com sucesso!');
finally
  FreeAndNil(_dadosinserir);
end;
```
<div></div><br><br>


## ⚡ Método - Editar dados
```pascal
procedure TServerMethods.EditarDadosMongoDB(const _base, _colecao, _filtros: String; const _dados: TJSONArray);
```
🏛️ Exemplo de consumo no cliente:
```pascal
var _filtros := '{"$and": [{"departamento": "TI"}, {"data_nascimento": {"$lte": 788918400}}]}'; // Nascidos antes de 1995
var _dadosatualizar := TJSONArray.Create;
var _camposatualizar: TJSONObject;
try
  _camposAtualizar := TJSONObject.Create;
  _camposAtualizar.AddPair('salario', TJSONNumber.Create(5500.00));
  _camposAtualizar.AddPair('nivel', 'Sênior');
  _camposAtualizar.AddPair('ultima_promocao', FormatDateTime('yyyy-mm-dd', Now));
  _dadosatualizar.AddElement(_camposatualizar);

  // Adicione quantos documentos forem necessários...

  // Executa edição
  ServerMethods.EditarDadosMongoDB('nome_base', 'nome_coleção', _filtros, _dadosatualizar);
  ShowMessage('Dados editados com sucesso!');
finally
  FreeAndNil(_dadosatualizar);
end;
```
<div></div><br><br>


## ⚡ Método - Buscar dados
```pascal
function TServerMethods.BuscarDadosMongoDB(const _base, _colecao, _filtros, _projecoes: String): TJSONArray;
```
🏛️ Exemplo de consumo no cliente:
```pascal
var _resultados: TJSONArray;
var _filtros := '{"departamento": "TI"}';
var _projecoes := '{"nome": 1, "email": 1, "data_nascimento": 1, "salario": 1, "nivel": 1, "_id": 0}';
var _dadosusuario: TJSONObject;
var _dataNasc: TDateTime;
try
  // Executa busca
  var _resultados := ServerMethods.BuscarDadosMongoDB('nome_base', 'nome_coleção', _filtros, _projecoes);
    
  // Varre o resultado
  for var I := 0 to _resultados.Count - 1 do
  begin
    _dadosusuario := _resultados.Items[I] as TJSONObject;
      
    ShowMessage(Format('%s (%s) - Nascimento: %s - Salário: R$ %.2f - Nível: %s', 
      [_dadosusuario.GetValue('nome').Value,
       _dadosusuario.GetValue('email').Value,
       FormatDateTime('dd/mm/yyyy', UnixToDateTime(_dadosusuario.GetValue('data_nascimento').Value.ToInteger)),
       _dadosusuario.GetValue('salario').Value.ToDouble,
       _dadosusuario.GetValue('nivel', 'Não definido')]));
  end;
    
  ShowMessage(Format('Encontrados %d funcionários de TI', [_resultados.Count]));
finally
  FreeAndNil(_resultados);
end;
```
📜 Respostas:
```json
[
  {
    "nome": "João Silva",
    "email": "joao@empresa.com",
    "data_nascimento": 831456000,
    "salario": 4500.00
  },
  {
    "nome": "Maria Santos",
    "email": "maria@empresa.com", 
    "data_nascimento": 713808000,
    "salario": 5500.00,
    "nivel": "Sênior"
  }
]
```
<div></div><br><br>


## ⚡ Método - Excluir dados
```pascal
procedure TServerMethods.ExcluirDadosMongoDB(const _base, _colecao, _filtros: String);
```
🏛️ Exemplo de consumo no cliente:
```pascal
// Excluir usuários inativos OU com salário muito baixo
var _filtros := '{"$or": [{"ativo": false}, {"salario": {"$lt": 2000}}]}';
ServerMethods.ExcluirDadosMongoDB('nome_base', 'nome_coleção', _filtros);
```
*A exclusão é PERMANENTE. Sempre teste os filtros com BuscarDados antes de executar ExcluirDados!
<div></div><br><br>


---
**Nota**: Requer configuração prévia do MongoDB Atlas e das credenciais apropriadas para funcionamento completo. Certifique-se de ter todas as unidades externas baixadas e configuradas corretamente no projeto.
