/* Conectado ao usuário dw */

-- Serão inseridas apenas 3 linhas, pois há vendas sem um cliente especificado
INSERT INTO tb_fato_venda
SELECT v.sk_cliente,
        p.sk_produto,
        l.sk_loja,
        TO_NUMBER(TO_CHAR(v.data_venda, 'yyyymmdd'), '99999999') AS sk_data,
        v.quantidade AS qtd_venda,
        (v.preco_unitario * v.quantidade) AS vl_venda,
        CURRENT_DATE
FROM starea.st_venda v, tb_dim_cliente c, tb_dim_produto p, tb_dim_loja l, tb_dim_tempo t
WHERE v.id_cliente = c.nk_id_cliente
AND v.id_produto = p.nk_id_produto
AND v.id_loja = l.nk_id_loja;
commit;

-- Corrigindo problemas de ausência de dados
INSERT INTO tb_dim_cliente VALUES(-1, -1, '<não identificado>', '<não identificado>', 0, 'NA');
commit;

INSERT INTO tb_dim_produto VALUES(-1, -1, '<não identificado>', '<não identificado>', '<não identificado>', '<não identificado>');
commit;

INSERT INTO tb_dim_loja VALUES(-1, -1, '<não identificado>', '<não identificado>', '<não identificado>');
commit;

-- Limpa a tabela fato
TRUNCATE TABLE tb_fato_venda;

-- Recarrega os dados na tabela fato
INSERT INTO tb_fato_venda
SELECT coalesce(c.sk_cliente, -1) AS sk_cliente, -- coalesce() retorna o primeiro valor não nulo, retornará -1 caso o valor seja nulo. 
       coalesce(p.sk_produto, -1) AS sk_produto, 
       coalesce(l.sk_loja, -1) AS sk_loja,
       TO_NUMBER(TO_CHAR(v.data_venda,'yyyymmdd'), '99999999') AS sk_data,
       (v.preco_unitario * v.quantidade) AS vl_venda,
       v.quantidade AS qtd_venda,
       CURRENT_DATE
    FROM starea.st_venda v LEFT JOIN tb_dim_cliente c 
    ON v.id_cliente = c.nk_id_cliente
    LEFT JOIN tb_dim_produto p 
    ON v.id_produto = p.nk_id_produto
    LEFT JOIN tb_dim_loja l
    ON v.id_loja = l.nk_id_loja;
commit;