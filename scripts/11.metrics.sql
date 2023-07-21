/* Conectado ao usuário dw */

SELECT * FROM tb_dim_produto;

-- Adiciona a coluna preco_unitario na tabela tb_dim_produto
ALTER TABLE tb_dim_produto ADD (preco_unitario DECIMAL);

SELECT * FROM starea.st_venda;

-- Carrega os dados na coluna preco_unitario da tabela tb_dim_produto
BEGIN
    For i in (SELECT preco_unitario, id_produto FROM starea.st_venda)
    LOOP
        UPDATE tb_dim_produto
        SET preco_unitario = i.preco_unitario
        WHERE nk_id_produto = i.id_produto;
    END LOOP;
END;
commit;

-- Desabilita as chaves estrangeiras da tabela fato
ALTER TABLE tb_fato_venda MODIFY CONSTRAINT fk_tb_fato_venda_tb_dim_produto DISABLE;
ALTER TABLE tb_fato_venda MODIFY CONSTRAINT fk_tb_fato_venda_tb_dim_loja    DISABLE;
ALTER TABLE tb_fato_venda MODIFY CONSTRAINT fk_tb_fato_venda_tb_dim_tempo   DISABLE;
ALTER TABLE tb_fato_venda MODIFY CONSTRAINT fk_tb_fato_venda_tb_dim_cliente DISABLE;

-- Limpa a tabela fato
TRUNCATE TABLE tb_fato_venda;

-- Adiciona a coluna vl_venda_total e renomeia a coluna vl_venda para vl_venda_unitario, que serão as novas métricas da tabela fato
ALTER TABLE tb_fato_venda ADD (vl_venda_total NUMBER);
ALTER TABLE tb_fato_venda RENAME COLUMN vl_venda TO vl_venda_unitario;

-- Recarrega os dados na tabela fato
INSERT INTO tb_fato_venda (
            sk_cliente,
            sk_produto,
            sk_loja,
            sk_data,
            vl_venda_unitario,
            qtd_venda,
            vl_venda_total,
            data_carga)
    SELECT coalesce(c.sk_cliente, -1) AS sk_cliente, 
        coalesce(p.sk_produto, -1) AS sk_produto, 
        coalesce(l.sk_loja, -1) AS sk_loja,
        TO_NUMBER(TO_CHAR(v.data_venda,'yyyymmdd'), '99999999') AS sk_data,
        p.preco_unitario AS vl_venda_unitario,
        v.quantidade AS qtd_venda,
        (p.preco_unitario * v.quantidade) AS vl_venda_total,
        CURRENT_DATE
    FROM starea.st_venda v 
    LEFT JOIN tb_dim_cliente c ON v.id_cliente = c.nk_id_cliente
    LEFT JOIN tb_dim_produto p ON v.id_produto = p.nk_id_produto
    LEFT JOIN tb_dim_loja l ON v.id_loja = l.nk_id_loja;
    commit;

-- Reabilita as chaves estrangeiras da tabela fato
ALTER TABLE tb_fato_venda MODIFY CONSTRAINT fk_tb_fato_venda_tb_dim_produto ENABLE;
ALTER TABLE tb_fato_venda MODIFY CONSTRAINT fk_tb_fato_venda_tb_dim_loja    ENABLE; 
ALTER TABLE tb_fato_venda MODIFY CONSTRAINT fk_tb_fato_venda_tb_dim_tempo   ENABLE;
ALTER TABLE tb_fato_venda MODIFY CONSTRAINT fk_tb_fato_venda_tb_dim_cliente ENABLE;

-- Verficação da integridade dos dados
SELECT  p.nm_categoria_pai as categoria_pai,
        p.nm_categoria_produto as categoria,
        t.nm_mes as mes,
        t.nr_ano as ano,
        sum(f.qtd_venda) as qtd_venda_total,
        sum(f.vl_venda_total) as vl_venda_total
    FROM tb_fato_venda f
    INNER JOIN tb_dim_tempo t   ON f.sk_data = t.sk_data
    INNER JOIN tb_dim_cliente c ON f.sk_cliente = c.sk_cliente
    INNER JOIN tb_dim_produto p ON f.sk_produto = p.sk_produto
    INNER JOIN tb_dim_loja l    ON f.sk_loja = l.sk_loja
    GROUP BY p.nm_categoria_pai, p.nm_categoria_produto, t.nm_mes, t.nr_ano
    ORDER BY sum(a.vl_venda_total) DESC;