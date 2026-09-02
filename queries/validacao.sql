-- =====================================================
-- SCRIPT DE VALIDAÇÃO - EBOOK SQL QA PROFESSIONAL
-- Objetivo: Garantir que o dump foi importado com sucesso
-- =====================================================

-- 1. Verificar se as tabelas foram criadas (Deve retornar o número de tabelas do seu schema)
SELECT COUNT(*) AS total_tabelas 
FROM information_schema.tables 
WHERE table_schema = 'public' AND table_type = 'BASE TABLE';

-- 2. Verificar se os dados foram inseridos (Contagem de registros da tabela principal)
-- Substitua 'sua_tabela_principal' pelo nome real
SELECT COUNT(*) AS total_registros_tabela_principal 
FROM sua_tabela_principal;

-- 3. Testar Relacionamento (JOIN) - Valida se as Foreign Keys e dados estão íntegros
-- Substitua pelos nomes reais das suas tabelas e colunas de join
SELECT t1.id, t1.nome, t2.descricao 
FROM sua_tabela_principal t1
INNER JOIN sua_tabela_secundaria t2 ON t1.id_secundario = t2.id
LIMIT 5;

-- 4. Testar Filtro de Dados - Valida se o conteúdo está legível e correto
-- Substitua pelos nomes reais
SELECT * 
FROM sua_tabela_principal 
WHERE coluna_de_status = 'ATIVO' -- ou qualquer filtro que faça sentido no seu negócio
LIMIT 5;