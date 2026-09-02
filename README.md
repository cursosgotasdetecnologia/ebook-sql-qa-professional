# SQL para QA na Prática — laboratório Banco Loja QA

Material complementar do ebook **SQL para QA na Prática**, de Everton Ulisses de Mendonça, do canal [Gotas de Tecnologia](https://www.youtube.com/c/GotasdeTecnologia).

Aqui você encontra o banco de dados usado nos exercícios, scripts de apoio e este guia de instalação. O laboratório simula um e-commerce com dados realistas e inconsistências preparadas para investigação de QA.

> Este guia foi escrito para Windows 10/11, 64 bits. No macOS ou Linux, os nomes dos menus do DBeaver são semelhantes, mas os caminhos de instalação mudam.

## Resultado esperado

Ao final, você terá:

- PostgreSQL 17 instalado localmente;
- DBeaver Community conectado ao PostgreSQL;
- Git e VS Code instalados;
- banco `loja_qa` restaurado a partir do arquivo `database/loja_qa.dump`;
- tabelas e dados disponíveis para executar as queries do ebook.

## 1. Arquivos do projeto

```text
sql-para-qa-na-pratica/
├── README.md
├── database/
│   └── loja_qa.dump
└── scripts/
    └── validacao_instalacao.sql
```

O arquivo `.dump` é um backup do PostgreSQL em formato de arquivo. Ele não deve ser aberto nem executado como um arquivo `.sql`; a importação é feita com o **pg_restore**, diretamente ou pelo DBeaver.

## 2. Ferramentas necessárias

Instale nesta ordem:

1. [PostgreSQL para Windows](https://www.postgresql.org/download/windows/) — use a versão 17 mostrada no vídeo;
2. [DBeaver Community](https://dbeaver.io/download/) — edição gratuita;
3. [Git for Windows](https://git-scm.com/download/win);
4. [Visual Studio Code](https://code.visualstudio.com/download);
5. conta gratuita no [GitHub](https://github.com/), apenas se quiser versionar seus próprios scripts.

Não é necessário instalar extensões no VS Code para acompanhar o ebook.

## 3. Instalar o PostgreSQL 17

Execute o instalador como administrador e mantenha selecionados:

- PostgreSQL Server;
- pgAdmin 4;
- Command Line Tools.

Durante a instalação:

- crie uma senha para o usuário administrador `postgres`;
- anote essa senha — ela não aparece depois;
- mantenha a porta padrão `5432`;
- mantenha a localidade sugerida pelo instalador;
- ao final, o Stack Builder pode ser ignorado.

Abra um novo Prompt de Comando e teste:

```powershell
psql --version
pg_restore --version
```

Se os comandos não forem reconhecidos, isso não significa que a instalação falhou. Use o caminho completo, ajustando a versão se necessário:

```powershell
"C:\Program Files\PostgreSQL\17\bin\psql.exe" --version
"C:\Program Files\PostgreSQL\17\bin\pg_restore.exe" --version
```

## 4. Instalar o DBeaver Community

Use as opções padrão do instalador. Ao criar a primeira conexão PostgreSQL, o DBeaver poderá solicitar o download do driver JDBC. Clique em **Baixar/Download** e aguarde a conclusão.

Crie a conexão com estes dados:

| Campo | Valor |
| --- | --- |
| Host | `localhost` |
| Porta | `5432` |
| Banco de dados | `postgres` |
| Usuário | `postgres` |
| Senha | a senha definida na instalação |

Clique em **Testar conexão**. Só continue quando a mensagem confirmar que a conexão foi estabelecida.

## 5. Instalar Git e VS Code

No Git for Windows, mantenha as opções padrão. No VS Code, marque as opções para adicionar a ação **Abrir com Code** ao menu de contexto, se elas forem exibidas.

Abra um novo Git Bash e teste:

```bash
git --version
code --version
```

## 6. Baixar este projeto

Você pode usar uma das opções.

### Opção A — baixar ZIP

No GitHub, clique em **Code > Download ZIP**, extraia o arquivo e abra a pasta no VS Code.

### Opção B — clonar com Git

> Autor: antes de publicar, substitua a URL abaixo pela URL definitiva do repositório.

```bash
git clone https://github.com/SEU_USUARIO/sql-para-qa-na-pratica.git
cd sql-para-qa-na-pratica
code .
```

Confirme se o arquivo `database/loja_qa.dump` está presente antes de continuar.

## 7. Criar o banco vazio no DBeaver

1. Abra a conexão local criada anteriormente.
2. Clique com o botão direito em **Bancos de dados/Databases**.
3. Escolha **Criar novo banco/Create New Database**.
4. Informe `loja_qa` como nome.
5. Use `postgres` como proprietário.
6. Confirme e pressione `F5` para atualizar o navegador.

Se o banco `loja_qa` já existir de uma tentativa anterior, consulte a seção **Recomeçar do zero** antes de restaurar.

## 8. Restaurar o dump pelo DBeaver

1. Clique com o botão direito no banco `loja_qa`.
2. Acesse **Ferramentas/Tools > Restaurar/Restore**.
3. Em **Arquivo de entrada/Input file**, selecione `database/loja_qa.dump`.
4. Se o DBeaver solicitar um cliente local, selecione a instalação do PostgreSQL 17, normalmente em `C:\Program Files\PostgreSQL\17`.
5. Marque as opções equivalentes a **Não restaurar proprietário** e **Não restaurar privilégios**, se estiverem disponíveis.
6. Inicie a restauração e aguarde o processo terminar sem erros.
7. Pressione `F5` em **Esquemas > public > Tabelas**.

Avisos sobre proprietário ou privilégios podem ocorrer quando um dump veio de outra máquina. Por isso usamos as opções `--no-owner` e `--no-privileges` na alternativa por terminal.

## 9. Alternativa: restaurar pelo Prompt de Comando

Abra o Prompt de Comando na pasta do projeto. Se os utilitários estiverem no `PATH`, execute:

```powershell
createdb -U postgres loja_qa
pg_restore -U postgres -d loja_qa --no-owner --no-privileges --exit-on-error "database\loja_qa.dump"
```

Se não estiverem no `PATH`, use:

```powershell
"C:\Program Files\PostgreSQL\17\bin\createdb.exe" -U postgres loja_qa
"C:\Program Files\PostgreSQL\17\bin\pg_restore.exe" -U postgres -d loja_qa --no-owner --no-privileges --exit-on-error "database\loja_qa.dump"
```

Digite a senha do usuário `postgres` quando solicitada. A senha não aparece enquanto você digita; isso é normal.

## 10. Validar a instalação

No DBeaver, abra um editor SQL conectado ao banco `loja_qa` e execute:

```sql
SELECT current_database() AS banco,
       current_user AS usuario,
       version() AS versao;

SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;

SELECT COUNT(*) AS total_clientes FROM clientes;
SELECT COUNT(*) AS total_pedidos FROM pedidos;
SELECT COUNT(*) AS total_produtos FROM produtos;
SELECT COUNT(*) AS total_itens FROM itens_pedido;
```

A instalação está correta quando:

- `current_database()` retorna `loja_qa`;
- as tabelas do laboratório aparecem no schema `public`;
- as consultas de contagem executam sem erro e retornam dados.

## 11. Problemas comuns

### `password authentication failed for user postgres`

A senha está incorreta ou pertence a outra instalação do PostgreSQL. Edite a conexão no DBeaver e teste novamente. Se você perdeu a senha, redefina-a antes de continuar; não reinstale todas as ferramentas sem necessidade.

### `connection refused` ou conexão recusada

Verifique se o serviço PostgreSQL está iniciado em **Serviços do Windows** e se a conexão usa `localhost` e porta `5432`.

### `port 5432 already in use`

Provavelmente já existe outra instalação do PostgreSQL. Não escolha uma porta aleatória sem necessidade: identifique qual serviço está usando a 5432 ou ajuste o DBeaver para a porta definida durante a instalação.

### `psql`, `createdb` ou `pg_restore` não é reconhecido

Use o caminho completo em `C:\Program Files\PostgreSQL\17\bin` ou configure essa pasta no `PATH` do Windows. Feche e abra o terminal depois de alterar o `PATH`.

### `Local client is not specified` no DBeaver

Na tela de restauração, configure o cliente local apontando para `C:\Program Files\PostgreSQL\17`. O DBeaver usa o driver JDBC para consultas comuns, mas precisa dos utilitários locais do PostgreSQL para restauração nativa.

### `input file appears to be a text format dump`

O arquivo recebido é SQL em texto, não um dump de arquivo. Nesse caso, não use `pg_restore`; execute com:

```powershell
psql -U postgres -d loja_qa -v ON_ERROR_STOP=1 -f "database\loja_qa.sql"
```

### Erros de proprietário, função ou privilégio

Restaure novamente em um banco vazio usando `--no-owner --no-privileges`. Não continue após uma restauração parcialmente concluída.

### O processo terminou, mas as tabelas não aparecem

Confirme se o editor está conectado a `loja_qa`, não ao banco `postgres`. Depois, pressione `F5` no navegador do DBeaver e expanda **Esquemas > public > Tabelas**.

## 12. Recomeçar do zero

Feche editores e desconecte sessões abertas no banco `loja_qa`. No DBeaver, exclua apenas esse banco, crie-o novamente vazio e repita a restauração. Essa operação apaga todo o progresso feito nele.

Uma alternativa pelo Prompt de Comando é:

```powershell
dropdb -U postgres --force loja_qa
createdb -U postgres loja_qa
pg_restore -U postgres -d loja_qa --no-owner --no-privileges --exit-on-error "database\loja_qa.dump"
```

## 13. Segurança e boas práticas

- Restaure somente o dump fornecido com o material oficial.
- Nunca publique sua senha do PostgreSQL no GitHub.
- Use este banco local para estudo; não execute comandos destrutivos em produção.
- Antes de `UPDATE` ou `DELETE`, valide o filtro com um `SELECT` e use transação quando o exercício orientar.
- Versione seus próprios scripts, mas não altere o dump original.

## Apoio

- Ebook: **SQL para QA na Prática**
- Autor: Everton Ulisses de Mendonça
- Canal: [Gotas de Tecnologia](https://www.youtube.com/c/GotasdeTecnologia)
- Vídeo de instalação: **[SUBSTITUIR PELO LINK NÃO LISTADO ANTES DE PUBLICAR]**

