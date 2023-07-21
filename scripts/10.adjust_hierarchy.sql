/* Conectado ao usuário source */

-- Desabilita a chave estrangeira da tabela tb_produto
ALTER TABLE tb_produto MODIFY CONSTRAINT tb_produto_fk1 DISABLE;

-- Limpa a tabela tb_categoria
TRUNCATE TABLE tb_categoria;

-- Apaga a coluna nome_sub_categoria e adiciona a coluna id_categoria_pai
ALTER TABLE tb_categoria DROP COLUMN nome_sub_categoria;
ALTER TABLE tb_categoria ADD (id_categoria_pai NUMBER);

-- Insere os novos dados na tabela tb_categoria
INSERT ALL 
    INTO tb_categoria (id_categoria, nome_categoria, id_categoria_pai) VALUES ('87654', 'Notebook', NULL)
    INTO tb_categoria (id_categoria, nome_categoria, id_categoria_pai) VALUES ('87660', 'Pessoal', '87654')
    INTO tb_categoria (id_categoria, nome_categoria, id_categoria_pai) VALUES ('87661', 'Business', '87654')
    INTO tb_categoria (id_categoria, nome_categoria, id_categoria_pai) VALUES ('87656', 'Camera', NULL)
    INTO tb_categoria (id_categoria, nome_categoria, id_categoria_pai) VALUES ('87662', 'Longa Distância', '87656')
    INTO tb_categoria (id_categoria, nome_categoria, id_categoria_pai) VALUES ('87663', 'Semi Profissional', '87656')
    INTO tb_categoria (id_categoria, nome_categoria, id_categoria_pai) VALUES ('87658', 'Smartphone', NULL)
    INTO tb_categoria (id_categoria, nome_categoria, id_categoria_pai) VALUES ('87664', '8 GB Memória', '87658')
    INTO tb_categoria (id_categoria, nome_categoria, id_categoria_pai) VALUES ('87665', '4 GB Memória', '87658')
commit;

-- Atualiza a coluna id_categoria da tabela tb_produto
UPDATE tb_produto SET id_categoria = '87661' WHERE id_produto = 12098712;
UPDATE tb_produto SET id_categoria = '87664' WHERE id_produto = 12098713;
UPDATE tb_produto SET id_categoria = '87662' WHERE id_produto = 12098714;
UPDATE tb_produto SET id_categoria = '87660' WHERE id_produto = 12098715;
UPDATE tb_produto SET id_categoria = '87665' WHERE id_produto = 12098716;
UPDATE tb_produto SET id_categoria = '87663' WHERE id_produto = 12098717;
UPDATE tb_produto SET id_categoria = '87660' WHERE id_produto = 12098718;
commit;

-- Habilita a chave estrangeira da tabela tb_produto
ALTER TABLE TB_PRODUTO MODIFY CONSTRAINT TB_PRODUTO_FK1 ENABLE;

-- Verifica os dados
SELECT nome_produto, nome_categoria
    FROM tb_produto, tb_categoria
    WHERE tb_categoria.id_categoria = tb_produto.id_categoria;

-- Concede privilégios de leitura para o usuário starea
GRANT SELECT ON tb_categoria    TO starea;
GRANT SELECT ON tb_produto      TO starea;

/* Conectado como usuário starea */

-- Apaga a tabela st_categoria
DROP TABLE st_categoria;

-- Recria a tabela st_categoria com a coluna id_categoria_pai
CREATE TABLE st_categoria (
    id_categoria        INTEGER NOT NULL, 
    nome_categoria      VARCHAR2(255),
    id_categoria_pai    VARCHAR2(255) 
);

-- Insere os dados na tabela st_categoria
INSERT INTO st_categoria
SELECT * FROM source.tb_categoria;
commit;

-- Apaga a tabela st_produto
DROP TABLE st_produto;

-- Recria a tabela st_produto
CREATE TABLE st_produto (
    id_produto      INTEGER NOT NULL,
    sku             VARCHAR2(255),
    nome_produto    VARCHAR2(255),
    id_produto      INTEGER
);

-- Insere os dados na tabela st_produto
INSERT INTO st_produto
SELECT * FROM source.tb_produto;
commit;

-- Apaga a tabela st_dim_produto
DROP TABLE st_dim_produto;

-- Recria a tabela st_dim_produto
CREATE TABLE st_dim_produto (
    nk_id_produto           VARCHAR2(20)    NOT NULL,
    desc_sku                VARCHAR2(50)    NOT NULL,
    nm_produto              VARCHAR2(50)    NOT NULL,
    id_categoria_produto    INTEGER,
    nm_categoria_produto    VARCHAR2(30)    NOT NULL,
    id_categoria_pai        VARCHAR2(30)    NOT NULL,
    nm_marca_produto        VARCHAR2(30)    NOT NULL
);

-- Concede privilégios de leitura na tabela st_dim_produto para o usuário dw 
GRANT SELECT ON st_dim_produto TO dw;

-- Verificação dos dados
SELECT p.id_produto, p.sku, p.nome_produto, c.id_categoria, c.nome_categoria, c.id_categoria_pai
    FROM st_produto p, st_categoria c
    WHERE p.id_categoria = c.id_categoria;

SELECT c1.id_categoria, c1.nome_categoria, c1.id_categoria_pai, c2.nome_categoria AS nome_categoria_pai
    FROM st_categoria c1, st_categoria c2
    WHERE c1.id_categoria_pai = c2.id_categoria;

-- Carga dos dados na tabela st_dim_produto
INSERT INTO st_dim_produto
SELECT  p.id_produto, 
        p.sku,
        p.nome_produto,
        c1.id_categoria,
        c1.nome_categoria,
        c1.id_categoria_pai,
        c2.nome_categoria AS nome_categoria_pai,
        CASE
            WHEN p.nome_produto LIKE '%Sony%' THEN 'Sony'
            WHEN p.nome_produto LIKE '%Iphone%' THEN 'Apple'
            WHEN p.nome_produto LIKE '%MSI%' THEN 'MSI'
            WHEN p.nome_produto LIKE '%Galaxy%' THEN 'Samsung'
            WHEN p.nome_produto LIKE '%ASUS%' THEN 'Asus'
            WHEN p.nome_produto LIKE '%Vaio%' THEN 'Vaio'
            WHEN p.nome_produto LIKE '%Canon%' THEN 'Canon'
        ELSE 'NA'
        END as nm_marca_produto
    FROM st_produto p, st_categoria c1, st_categoria c2
    WHERE p.id_categoria = c1.id_categoria
    AND c1.id_categoria_pai = c2.id_categoria;

/* Conectado ao usuário dw */

-- Desabilita as chaves entrangeiras da tabela fato
ALTER TABLE tb_fato_venda MODIFY CONSTRAINT fk_tb_fato_venda_tb_dim_cliente DISABLE;
ALTER TABLE tb_fato_venda MODIFY CONSTRAINT fk_tb_fato_venda_tb_dim_produto DISABLE;
ALTER TABLE tb_fato_venda MODIFY CONSTRAINT fk_tb_fato_venda_tb_dim_loja DISABLE;  
ALTER TABLE tb_fato_venda MODIFY CONSTRAINT fk_tb_fato_venda_tb_dim_tempo DISABLE;

-- Limpa a tabela tb_dim_produto
TRUNCATE TABLE tb_dim_produto;

-- Adiciona as colunas id_categoria_produto, id_categoria_pai e nm_categoria_pai na tabela tb_dim_produto
ALTER TABLE tb_dim_produto ADD (id_categoria_produto INTEGER);
ALTER TABLE tb_dim_produto ADD (id_categoria_pai INTEGER);
ALTER TABLE tb_dim_produto ADD (nm_categoria_pai VARCHAR2(20));

-- Carrega os dados na tabela tb_dim_produto
INSERT INTO tb_dim_produto (sk_produto, 
	                        nk_id_produto, 
       						desc_sku, 
       						nm_produto, 
       						id_categoria_produto, 
       						nm_categoria_produto, 
       						id_categoria_pai, 
       						nm_categoria_pai, 
       						nm_marca_produto)
    SELECT  dim_produto_id_seq.NEXTVAL, 
            nk_id_produto, 
            desc_sku, 
            nm_produto, 
            id_categoria_produto, 
            nm_categoria_produto, 
            id_categoria_pai, 
            nm_categoria_pai, 
            nm_marca_produto
    FROM starea.st_dim_produto;
commit;

-- Limpa a tabela fato
TRUNCATE TABLE tb_fato_venda;

-- Recarrega os dados na tabela fato
INSERT INTO tb_fato_venda
SELECT coalesce(c.sk_cliente, -1) AS sk_cliente, 
       coalesce(p.sk_produto, -1) AS sk_produto, 
       coalesce(l.sk_loja, -1) AS sk_loja,
       TO_NUMBER(TO_CHAR(v.data_venda,'yyyymmdd'), '99999999') AS sk_data,
       (v.preco_unitario * v.quantidade) AS vl_venda,
       v.quantidade AS qtd_venda,
       CURRENT_DATE
    FROM starea.st_venda v 
    LEFT JOIN tb_dim_cliente c 
    ON v.id_cliente = c.nk_id_cliente
    LEFT JOIN tb_dim_produto p 
    ON v.id_produto = p.nk_id_produto
    LEFT JOIN tb_dim_loja l
    ON v.id_loja = l.nk_id_loja;
commit;

-- Habilita as chaves entrangeiras da tabela fato
ALTER TABLE tb_fato_venda MODIFY CONSTRAINT fk_tb_fato_venda_tb_dim_cliente ENABLE;
ALTER TABLE tb_fato_venda MODIFY CONSTRAINT fk_tb_fato_venda_tb_dim_produto ENABLE;
ALTER TABLE tb_fato_venda MODIFY CONSTRAINT fk_tb_fato_venda_tb_dim_loja    ENABLE;  
ALTER TABLE tb_fato_venda MODIFY CONSTRAINT fk_tb_fato_venda_tb_dim_tempo   ENABLE;

-- Verificação dos dados
SELECT  p.nm_categoria_pai as Categoria,
        t.nm_mes as Mes,
        t.nr_ano as Ano,
        SUM(v.qtd_venda) as qtd_venda_total,
        SUM(v.vl_venda) as vl_venda_total
    FROM tb_fato_venda v
    INNER JOIN tb_dim_tempo t      ON v.sk_data        = t.sk_data
    INNER JOIN tb_dim_cliente c    ON v.sk_cliente     = c.sk_cliente
    INNER JOIN tb_dim_produto p    ON v.sk_produto     = D.sk_produto
    INNER JOIN tb_dim_loja l       ON v.sk_localidade  = l.sk_localidade
    GROUP BY D.nm_categoria_pai, B.nr_ano, B.nm_mes
    ORDER BY SUM(v.vl_venda) DESC;