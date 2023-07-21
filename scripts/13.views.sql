/* Conectado como usuário system */

GRANT CREATE VIEW TO dw;
GRANT CREATE MATERIALIZED VIEW TO dw;

/* Conectado ao usuário dw */ 

-- Criação das view
CREATE VIEW vw_vendas_2023 AS
SELECT  p.nm_categoria_pai as Categoria_Pai,
        p.nm_categoria_produto as Categoria,
        p.nm_produto as Produto,
        t.nr_dia as Dia,
        t.nr_ano as Ano,
        sum(v.qtd_venda) as Quantidade,
        sum(v.vl_venda_total) as Valor_Total
    FROM tb_fato_venda v
    INNER JOIN tb_dim_tempo t ON v.sk_data = t.sk_data
    INNER JOIN tb_dim_cliente c ON v.sk_cliente = c.sk_cliente
    INNER JOIN tb_dim_produto p ON v.sk_produto = p.sk_produto
    INNER JOIN tb_dim_loja l ON v.sk_loja = l.sk_loja
    GROUP BY p.nm_categoria_pai, p.nm_categoria_produto, p.nm_produto, t.nr_dia, t.nr_ano;
    ORDER BY sum(v.vl_venda_total) DESC;

-- Consulta do plano de execução da query
EXPLAIN PLAN FOR
SELECT  p.nm_categoria_pai as Categoria_Pai,
        p.nm_categoria_produto as Categoria,
        p.nm_produto as Produto,
        t.nr_dia as Dia,
        t.nr_ano as Ano,
        sum(v.qtd_venda) as Quantidade,
        sum(v.vl_venda_total) as Valor_Total
    FROM tb_fato_venda v
    INNER JOIN tb_dim_tempo t ON v.sk_data = t.sk_data
    INNER JOIN tb_dim_cliente c ON v.sk_cliente = c.sk_cliente
    INNER JOIN tb_dim_produto p ON v.sk_produto = p.sk_produto
    INNER JOIN tb_dim_loja l ON v.sk_loja = l.sk_loja
    GROUP BY p.nm_categoria_pai, p.nm_categoria_produto, p.nm_produto, t.nr_dia, t.nr_ano;
    ORDER BY sum(v.vl_venda_total) DESC;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Criação da materialized view
CREATE MATERIALIZED VIEW mv_vendas_2023 AS
SELECT  p.nm_categoria_pai as Categoria_Pai,
        p.nm_categoria_produto as Categoria,
        p.nm_produto as Produto,
        t.nr_dia as Dia,
        t.nr_ano as Ano,
        sum(v.qtd_venda) as Quantidade,
        sum(v.vl_venda_total) as Valor_Total
    FROM tb_fato_venda v
    INNER JOIN tb_dim_tempo t ON v.sk_data = t.sk_data
    INNER JOIN tb_dim_cliente c ON v.sk_cliente = c.sk_cliente
    INNER JOIN tb_dim_produto p ON v.sk_produto = p.sk_produto
    INNER JOIN tb_dim_loja l ON v.sk_loja = l.sk_loja
    GROUP BY p.nm_categoria_pai, p.nm_categoria_produto, p.nm_produto, t.nr_dia, t.nr_ano;
    ORDER BY sum(v.vl_venda_total) DESC;

-- Consulta do plano de execução da view
EXPLAIN PLAN FOR
SELECT * FROM mv_vendas_2023;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);

-- Refresh na Materialized View
EXEC DBMS_MVIEW.refresh('mv_vendas_2018');