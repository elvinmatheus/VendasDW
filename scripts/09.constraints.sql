/* Conectado como usuário dw */

-- Adicionando as chaves estrangeiras
ALTER TABLE tb_fato_venda
    ADD CONSTRAINT fk_tb_fato_venda_tb_dim_cliente 
    FOREIGN KEY (sk_cliente) REFERENCES tb_dim_cliente (sk_cliente) 
    ENABLE;

ALTER TABLE tb_fato_venda
    ADD CONSTRAINT fk_tb_fato_venda_tb_dim_produto 
    FOREIGN KEY (sk_produto) REFERENCES tb_dim_produto (sk_produto)
    ENABLE;

ALTER TABLE tb_fato_venda
    ADD CONSTRAINT fk_tb_fato_venda_tb_dim_loja 
    FOREIGN KEY (sk_loja) REFERENCES tb_dim_loja (sk_loja)
    ENABLE;

ALTER TABLE tb_fato_venda
    ADD CONSTRAINT fk_tb_fato_venda_tb_dim_tempo
    FOREIGN KEY (sk_data) REFERENCES tb_dim_tempo (sk_data)
    ENABLE;


-- Verificando a integridade dos dados
SELECT sum(quantidade) FROM starea.st_venda;

-- Consulta
SELECT
        l.nm_regiao_loja AS Regiao,
        t.nm_mes AS Mes,
        t.nr_ano AS Ano,
        SUM(t.qtd_venda) AS qtd_venda_total,
        SUM(t.vl_venda) AS vl_venda_total
    FROM tb_fato_venda v
    INNER JOIN tb_dim_tempo t   ON v.sk_data = t.sk_data    
    INNER JOIN tb_dim_cliente c ON v.sk_cliente = c.sk_cliente
    INNER JOIN tb_dim_produto p ON v.sk_produto = p.sk_produto
    INNER JOIN tb_dim_loja l    ON v.sk_loja = l.sk_loja
    GROUP BY l.nm_regiao_loja, t.nr_ano, t.nm_mes 
    ORDER BY SUM(t.vl_venda) DESC;