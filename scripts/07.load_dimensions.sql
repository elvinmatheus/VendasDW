/* Conectado como usuário dw */

-- Carrega a tabela tb_dim_tempo
INSERT INTO tb_dim_tempo
SELECT
    TO_CHAR(TO_DATE('31/12/2018', 'DD/MM/YYYY')                 + NUMTODSINTERVAL(n, 'day'), 'YYYYMMDD') AS sk_data,
    TO_DATE('31/12/2018', 'DD/MM/YYYY')                         + NUMTODSINTERVAL(n, 'day') AS data,
    TO_CHAR(TO_DATE('31/12/2018', 'DD/MM/YYYY')                 + NUMTODSINTERVAL(n, 'day'), 'YYYY') AS nr_ano,
    'Trimestre-' || TO_CHAR(TO_DATE('31/12/2018', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'Q') AS nm_trimestre,
    TO_CHAR(TO_DATE('31/12/2018', 'DD/MM/YYYY')                 + NUMTODSINTERVAL(n, 'day'), 'MM') AS nr_mes,
    TO_CHAR(TO_DATE('31/12/2018', 'DD/MM/YYYY')                 + NUMTODSINTERVAL(n, 'day'), 'MONTH', 'NLS_DATE_LANGUAGE=PORTUGUESE') AS nm_mes,
    TO_CHAR(TO_DATE('31/12/2018', 'DD/MM/YYYY')                 + NUMTODSINTERVAL(n, 'day'), 'WW') AS nr_semana,
    TO_CHAR(TO_DATE('31/12/2018', 'DD/MM/YYYY')                 + NUMTODSINTERVAL(n, 'day'), 'YYYY') || '/' || 
    TO_CHAR(TO_DATE('31/12/2018', 'DD/MM/YYYY')                 + NUMTODSINTERVAL(n, 'day'), 'WW') AS nm_ano_semana,
    TO_CHAR(TO_DATE('31/12/2018', 'DD/MM/YYYY')                 + NUMTODSINTERVAL(n, 'day'), 'DD') AS nr_dia,
    TO_CHAR(TO_DATE('31/12/2018', 'DD/MM/YYYY')                 + NUMTODSINTERVAL(n, 'day'), 'DAY', 'NLS_DATE_LANGUAGE=PORTUGUESE') AS nm_dia_semana,

    CASE 
        WHEN TO_CHAR(TO_DATE('31/12/2018', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MMDD') 
        IN (0101, 0212, 0213, 0330, 0421, 0501, 0531, 0907, 1012, 1102, 1115, 1225) THEN  'SIM'
    ELSE 'NAO'
    END AS flag_feriado,

    CASE 
        WHEN TO_CHAR(TO_DATE('31/12/2018', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MMDD') = '0101' THEN 'ANO NOVO'
        WHEN TO_CHAR(TO_DATE('31/12/2018', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MMDD') = '0212' THEN 'CARNAVAL'
        WHEN TO_CHAR(TO_DATE('31/12/2018', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MMDD') = '0213' THEN 'CARNAVAL'
        WHEN TO_CHAR(TO_DATE('31/12/2018', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MMDD') = '0330' THEN 'SEXTA-FEIRA SANTA'
        WHEN TO_CHAR(TO_DATE('31/12/2018', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MMDD') = '0421' THEN 'TIRADENTES'
        WHEN TO_CHAR(TO_DATE('31/12/2018', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MMDD') = '0501' THEN 'DIA DO TRABALHADOR'
        WHEN TO_CHAR(TO_DATE('31/12/2018', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MMDD') = '0531' THEN 'CORPUS CHRISTI'
        WHEN TO_CHAR(TO_DATE('31/12/2018', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MMDD') = '0907' THEN 'INDEPENDÊNCIA DO BRASIL'
        WHEN TO_CHAR(TO_DATE('31/12/2018', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MMDD') = '1012' THEN 'NOSSA SENHORA APARECIDA'
        WHEN TO_CHAR(TO_DATE('31/12/2018', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MMDD') = '1102' THEN 'FINADOS'
        WHEN TO_CHAR(TO_DATE('31/12/2018', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MMDD') = '1115' THEN 'PROCLAMAÇÃO DA REPÚBLICA'
        WHEN TO_CHAR(TO_DATE('31/12/2018', 'DD/MM/YYYY') + NUMTODSINTERVAL(n, 'day'), 'MMDD') = '1225' THEN 'NATAL'
    ELSE 'DIA COMUM'
    END AS nm_feriado
    
FROM (
    SELECT LEVEL n 
    FROM dual 
    CONNECT BY LEVEL <= 2000
);
commit;

-- Carrega a tabela tb_dim_cliente
INSERT INTO tb_dim_cliente
SELECT  dim_cliente_id_seq.NEXTVAL,
        nk_id_cliente,
        nm_cliente,
        nm_cidade_cliente,
        flag_aceita_alertas,
        desc_cep
FROM starea.st_dim_cliente;
commit;

-- Carrega a tabela tb_dim_produto
INSERT INTO tb_dim_produto
SELECT  dim_cliente_id_seq.NEXTVAL,
        nk_id_produto,
        desc_sku,
        nm_produto,
        nm_categoria_produto,
        nm_marca_produto
FROM starea.st_dim_produto;
commit;

-- Carrega a tabela tb_dim_loja
INSERT INTO tb_dim_loja
SELECT  dim_cliente_id_seq.NEXTVAL,
        nk_id_loja,
        nm_loja,
        nm_cidade_loja,
        nm_regiao_loja
FROM starea.st_dim_loja;
commit;