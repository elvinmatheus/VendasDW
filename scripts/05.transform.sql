/* Conectado como usuário starea */

-- Consulta as linhas da tabela st_cadastro_cliente
SELECT * FROM st_cadastro_cliente

-- Adiciona coluna data_registro na tabela st_cadastro_cliente. Podemos fazer isso porque a tabela st_cadastro_cliente é "nossa".
ALTER TABLE st_cadastro_cliente ADD (data_registro DATE);

-- Atualiza os campos null da coluna data_registro para a data atual
UPDATE st_cadastro_cliente SET data_registro = CURRENT_DATE;
commit;

-- Atualiza os campos null da coluna email_cliente para 'Não Informado'
UPDATE st_cadastro_cliente SET email_cliente = 'Não Informado' WHERE email_cliente IS NULL;
commit;

-- Corrige o email do cliente escrito com xxx
UPDATE st_cadastro_cliente SET email_cliente = 'Não Informado' WHERE substr(email_cliente, 1, 3) = 'xxx';
commit;

-- Verfica se uma string pode ser convertida em um valor numérico
CREATE FUNCTION is_numeric(p_str IN VARCHAR2) -- declaração da função. p_str é o parâmetro de entrada do tipo VARCHAR2
    RETURN NUMBER -- A função retorna um valor do tipo NUMBER
IS -- Inicia a seção de declaração de variáveis locais
    l_num NUMBER; -- Declaração de uma variável local do tipo NUMBER
BEGIN -- Inicia a seção executável da função
    l_num := to_number(p_str); -- Tenta converter a string p_str em um valor numérico
    RETURN 1; -- Se a conversão for bem sucedida, retorna 1
EXCEPTION -- Inicia o tratamento de exceção
    WHEN value_error -- ocorre quando a conversão falha
    THEN
        RETURN 0; -- Se a conversão falhar, retorna 0
END; -- Finaliza a função

-- Atualiza os campos numéricos da coluna email_cliente para 'Não Informado'
UPDATE ST_CADASTRO_CLIENTE SET EMAIL_CLIENTE = 'Não Informado' WHERE is_numeric(email_cliente) = 1;
commit;

-- Cria tabela st_dim_cliente
CREATE TABLE st_dim_cliente (
    nk_id_cliente       NUMBER(20)      NOT NULL,
    nm_cliente          VARCHAR2(50)    NOT NULL,
    nm_cidade_cliente   VARCHAR2(50)    NOT NULL,
    flag_aceita_alertas CHAR(1)         NOT NULL,
    desc_cep            VARCHAR2(10)    NOT NULL
);

-- Insere os dados em st_dim_cliente a partir de st_cadastro_cliente e st_endereco
INSERT INTO st_dim_cliente
SELECT cc.id_cliente, cc.nome_cliente, e.cidade, 0, e.cep
FROM st_cadastro_cliente cc, st_endereco e
WHERE cc.id_cliente = e.id_cliente;
commit;

-- A quantidade de clientes na tabela st_dim_cliente será menor que a quantidade de registros de st_cadastro_cliente, pois alguns clientes não possuem endereço
-- Resolva com esse problema com a área de negócios
SELECT * FROM st_dim_cliente;

-- Limpeza e transformação da tabela st_loja
CREATE TABLE st_dim_loja (
    nk_id_loja      VARCHAR2(20) NOT NULL,
    nm_loja         VARCHAR2(50) NOT NULL,
    nm_cidade_loja  VARCHAR2(20) NOT NULL,
    nm_regiao_loja  VARCHAR2(50) NOT NULL
);

INSERT INTO st_dim_loja
SELECT id_loja, nome_loja, cidade_loja,  
CASE
    WHEN cidade_loja = 'Barueri'        THEN 'Sudeste'
    WHEN cidade_loja = 'São Paulo'      THEN 'Sudeste'
    WHEN cidade_loja = 'Rio de Janeiro' THEN 'Sudeste'
    WHEN cidade_loja = 'Salvador'       THEN 'Nordeste'
    WHEN cidade_loja = 'Tatuapé'        THEN 'Sudeste'
ELSE 'NA'
END as regiao
FROM st_loja;
commit;

-- Limpeza e transformação da tabela st_produto e st_categoria
CREATE TABLE st_dim_produto (
    nk_id_produto           VARCHAR2(20) NOT NULL,
    desc_SKU                VARCHAR2(50) NOT NULL,
    nm_produto              VARCHAR2(50) NOT NULL,
    nm_categoria_produto    VARCHAR2(30) NOT NULL,
    nm_marca_produto        VARCHAR2(30) NOT NULL
);

INSERT INTO st_dim_produto
SELECT p.id_produto, p.sku, p.nome_produto, c.nome_categoria
CASE
    WHEN p.nome_produto LIKE '%Sony%'   THEN 'Sony'
    WHEN p.nome_produto LIKE '%Iphone%' THEN 'Apple'
    WHEN p.nome_produto LIKE '%MSI%'    THEN 'MSI'
    WHEN p.nome_produto LIKE '%Galaxy%' THEN 'Samsung'
    WHEN p.nome_produto LIKE '%ASUS%'   THEN 'Asus'
    WHEN p.nome_produto LIKE '%Vaio%'   THEN 'Vaio'
    WHEN p.nome_produto LIKE '%Canon%'  THEN 'Canon'
ELSE 'NA'
END AS marca_produto
FROM st_produto p, st_categoria c
WHERE p.id_categoria = c.id_categoria;
commit;

-- Limpeza e transformação da tabela st_pedidos e st_itens_pedido
CREATE TABLE st_venda(
    id_transacao        INTEGER,
    data_venda          DATE,
    status_pagamento    VARCHAR2,
    id_cliente          INTEGER,
    id_loja             INTEGER,
    id_produto          INTEGER,
    quantidade          INTEGER,
    preco_unitario      DECIMAL
);

INSERT INTO st_venda 
SELECT p.id_transacao, p.data_entrega, 
CASE
    WHEN p.status_pagamento = 'NA' THEN 'Erro'
    ELSE A.status_pagamento
    END AS status_pagamento, p.id_cliente, p.id_loja, i.id_produto, i.quantidade, i.preco_unitario
FROM st_pedidos p, st_itens_pedido i
WHERE p.id_transacao = i.id_transacao;
commit;

GRANT SELECT ON starea.st_dim_cliente TO dw;
GRANT SELECT ON starea.st_dim_produto TO dw;
GRANT SELECT ON starea.st_dim_loja TO dw;
GRANT SELECT ON starea.st_venda TO dw;