<div align="center">
<img width="223" height="200" alt="Logo" src="https://github.com/user-attachments/assets/3a33800c-24e5-47bd-b086-6851796932e6" /></div><p>

# <div align="center"><strong>KAFSServidorDataSnap</strong></div> 

<div align="center">
Servidor DataSnap integrado com MongoDB Atlas para persistência de dados.<br>
Oferece endpoints RESTful para operações básicas de banco de dados.
</p>

[![Delphi](https://img.shields.io/badge/Delphi-12.3+-B22222?logo=delphi)](https://www.embarcadero.com/products/delphi)
[![DataSnap](https://img.shields.io/badge/DataSnap-Server-007ACC)]([https://www.embarcadero.com/products/datasnap](https://docwiki.embarcadero.com/RADStudio/Athens/en/Developing_DataSnap_Applications))
[![FireDAC](https://img.shields.io/badge/FireDAC-Connector-FF6600)]([https://www.embarcadero.com/products/firedac](https://docwiki.embarcadero.com/RADStudio/Athens/en/FireDAC))
[![MongoDB](https://img.shields.io/badge/MongoDB-Atlas-47A248?logo=mongodb)](https://www.mongodb.com/atlas)
[![Multiplatform](https://img.shields.io/badge/Multiplatform-Win/Linux-8250DF)]([https://www.embarcadero.com/products/delphi/cross-platform](https://docwiki.embarcadero.com/RADStudio/Athens/en/Developing_Multi-Device_Applications))
[![Docker](https://img.shields.io/badge/Docker-Container-2496ED?logo=docker)](https://www.docker.com)
[![License](https://img.shields.io/badge/License-GPLv3-blue)](LICENSE)
</div><br>

## ⚠️ Dependências externas
- 🧩 [TKAFSConexaoMongoDBAtlas](https://github.com/ViniciusdoAmaralReis/TKAFSConexaoMongoDBAtlas) 
- 🧩 [uKAFSFuncoes](https://github.com/ViniciusdoAmaralReis/uKAFSFuncoes) 
- 🧩 [uKAFSMongoDB](https://github.com/ViniciusdoAmaralReis/uKAFSMongoDB) 
- *🧩 [TKAFSConexaoDataSnap](https://github.com/ViniciusdoAmaralReis/TKAFSConexaoDataSnap)

*Componente utilizado nos exemplos de consumo no cliente. Não é necessário para compilar este projeto servidor.
<div></div><br><br>

## 🪟 Executar no Windows
```bash
KAFSServidorDataSnap.exe -p porta -u usuario_mongodbatlas -s senha_mongodbatlas -h servidor_mongodbatlas
```
ou somente
```bash
KAFSServidorDataSnap.exe
```
<div></div><br><br>

## 🐧 Executar no Linux
```bash
chmod +x KAFSServidorDataSnap
./KAFSServidorDataSnap -p porta -u usuario_mongodbatlas -s senha_mongodbatlas -h servidor_mongodbatlas
```
ou somente
```bash
chmod +x KAFSServidorDataSnap
./KAFSServidorDataSnap
```
<div></div><br><br>

## ⚡ Método - Inserir dados
```pascal
function TServerMethods.InserirDadosMongoDB(const _banco, _colecao: String; const _dados: TJSONObject): TJSONObject;
```
🏛️ Exemplo de consumo:
```pascal
var _conexao := TKAFSConexaoDataSnap.Create(nil);
var _metodo := TServerMethodsClient.Create(_conexao.DBXConnection);
var _dados := TJSONObject.Create;
var _resultado := TJSONObject.Create;
try
  // Preparar dados para inserção
  with _dados do
  begin
    AddPair('nome', TJSONString.Create('João'));
    AddPair('email', TJSONString.Create('joao@email.com'));
    AddPair('nivel', TJSONNumber.Create(1));
  end;

  // Executar inserção
  _resultado := _metodo.InserirDadosMongoDB('meu_banco', 'minha_coleção', _dados);

  // Verificar resultado
  if not _resultado.GetValue<Boolean>('sucesso') then
    raise Exception.Create(_resultado.GetValue<string>('erro'));

  ShowMessage('Usuário inserido com sucesso!');
finally
  FreeAndNil(_resultado);
  FreeAndNil(_dados);
  FreeAndNil(_metodo);
  FreeAndNil(_conexao);
end;
```
📜 Respostas:
```json
{"sucesso": true}
```
```json
{"sucesso": false, "erro": "Mensagem do erro aqui"}
```
<div></div><br><br>


## ⚡ Método - Editar dados
```pascal
function TServerMethods.EditarDadosMongoDB(const _banco, _colecao: String; const _filtros, _atualizacoes: TJSONObject): TJSONObject;
```
🏛️ Exemplo de consumo:
```pascal
var _conexao := TKAFSConexaoDataSnap.Create(nil);
var _metodo := TServerMethodsClient.Create(_conexao.DBXConnection);
var _filtros := TJSONObject.Create;
var _atualizacoes := TJSONObject.Create;
var _resultado := TJSONObject.Create;
try
  // Preparar filtros para edição
  with _filtros do
  begin
    AddPair('email', TJSONString.Create('joao@email.com'));
  end;

  // Preparar dados para atualização
  with _atualizacoes do
  begin
    AddPair('nivel', TJSONNumber.Create(2));
    AddPair('ultima_atualizacao', TJSONString.Create(FormatDateTime('yyyy-mm-dd hh:nn:ss', Now)));
  end;

  // Executar edição
  _resultado := _metodo.EditarDadosMongoDB('meu_banco', 'minha_coleção', _filtros, _atualizacoes);

  // Verificar resultado
  if not _resultado.GetValue<Boolean>('sucesso') then
    raise Exception.Create(_resultado.GetValue<string>('erro'));

  ShowMessage('Usuário atualizado com sucesso!');
finally
  FreeAndNil(_resultado);
  FreeAndNil(_atualizacoes);
  FreeAndNil(_filtros);
  FreeAndNil(_metodo);
  FreeAndNil(_conexao);
end;
```
📜 Respostas:
```json
{"sucesso": true}
```
```json
{"sucesso": false, "erro": "Mensagem do erro aqui"}
```
<div></div><br><br>


## ⚡ Método - Buscar dados
```pascal
function TServerMethods.BuscarDadosMongoDB(const _banco, _colecao: string; const _filtros: TJSONObject): TJSONObject;
```
🏛️ Exemplo de consumo:
```pascal
var _conexao := TKAFSConexaoDataSnap.Create(nil);
var _metodo := TServerMethodsClient.Create(_conexao.DBXConnection);
var _filtros := TJSONObject.Create;
var _resultado := TJSONObject.Create;
try
  // Preparar filtro para busca
  _filtros := TJSONObject.Create;
  with _filtros do
  begin
    AddPair('email', TJSONString.Create('joao@email.com'));
  end;

  // Executar busca
  _resultado := _metodo.BuscarDadosMongoDB('meu_banco', 'minha_coleção', _filtros);

  // Verificar resultado
  if not _resultado.GetValue<Boolean>('sucesso') then
    raise Exception.Create(_resultado.GetValue<string>('erro'));

  // Processar resultados
  var _quantidade := _resultado.GetValue<Integer>('quantidade');
  var _usuarios := _resultado.GetValue<TJSONArray>('resultados');

  ShowMessage(Format('%d usuário(s) encontrado(s)', [_quantidade]));
finally
  FreeAndNil(_resultado);
  FreeAndNil(_filtros);
  FreeAndNil(_metodo);
  FreeAndNil(_conexao);
end;
```
📜 Respostas:
```json
{
  "sucesso": true,
  "quantidade": 2,
  "resultados": [
    {
      "_id": "65a1b2c3d4e5f67890123456",
      "nome": "João",
      "email": "joao@email.com",
      "nivel": 1
    },
    {
      "_id": "65a1b2c3d4e5f67890123457",
      "nome": "Maria",
      "email": "maria@email.com",
      "nivel": 2
    }
  ]
}
```
```json
{
  "sucesso": true,
  "quantidade": 0,
  "resultados": []
}
```
```json
{"sucesso": false, "erro": "Mensagem do erro aqui"}
```
<div></div><br><br>


## ⚡ Método - Excluir dados
```pascal
function TServerMethods.ExcluirDadosMongoDB(const _banco, _colecao: String; const _filtros: TJSONObject): TJSONObject;
```
🏛️ Exemplo de consumo:
```pascal
var _conexao := TKAFSConexaoDataSnap.Create(nil);
var _metodo := TServerMethodsClient.Create(_conexao.DBXConnection);
var _filtros := TJSONObject.Create;
var _resultado := TJSONObject.Create;
try
  // Preparar filtros para exclusão
  with _filtros do
  begin
    AddPair('email', TJSONString.Create('joao@email.com'));
  end;

  // Executar exclusão
  _resultado := _metodo.ExcluirDadosMongoDB('meu_banco', 'minha_coleção', _filtros);

  // Verificar resultado
  if not _resultado.GetValue<Boolean>('sucesso') then
    raise Exception.Create(_resultado.GetValue<string>('erro'));

  ShowMessage('Usuário excluído com sucesso!');
finally
  FreeAndNil(_resultado);
  FreeAndNil(_filtros);
  FreeAndNil(_metodo);
  FreeAndNil(_conexao);
end;
```
📜 Respostas:
```json
{"sucesso": true}
```
```json
{"sucesso": false, "erro": "Mensagem do erro aqui"}
```
<div></div><br><br>

---
**Nota**: Requer configuração prévia do MongoDB Atlas e das credenciais apropriadas para funcionamento completo. Certifique-se de ter todas as unidades externas baixadas e configuradas corretamente no projeto.
