/* Conectado como usuário dw */

-- Cria as sequências para as surrogate keys das tabela
CREATE SEQUENCE dim_cliente_id_seq  START WITH 100 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE SEQUENCE dim_produto_id_seq  START WITH 100 INCREMENT BY 1 NOCACHE NOCYCLE;

CREATE SEQUENCE dim_loja_id_seq     START WITH 100 INCREMENT BY 1 NOCACHE NOCYCLE;

-- Cria as tabelas dimensão e fato
CREATE TABLE tb_dim_cliente (
    sk_cliente          INTEGER DEFAULT dim_cliente_id_seq.NEXTVAL,
    nk_id_cliente       VARCHAR2(20) NOT NULL,
    nm_cliente          VARCHAR2(50) NOT NULL,
    nm_cidade_cliente   VARCHAR2(50) NOT NULL,
    flag_aceita_alertas CHAR(1) NOT NULL,
    desc_cep            VARCHAR2(10) NOT NULL,
    CONSTRAINT tb_dim_cliente_pk PRIMARY KEY (sk_cliente) ENABLE
);

CREATE TABLE tb_dim_produto (
    sk_produto              INTEGER DEFAULT dim_produto_id_seq.NEXTVAL,
    nk_id_produto           VARCHAR2(20) NOT NULL,
    desc_sku                VARCHAR2(50) NOT NULL,
    nm_produto              VARCHAR2(50) NOT NULL,
    nm_categoria_produto    VARCHAR2(30) NOT NULL,
    nm_marca_produto        VARCHAR2(30) NOT NULL,
    CONSTRAINT tb_dim_produto_pk PRIMARY KEY (sk_produto) ENABLE
);

CREATE TABLE tb_dim_loja (
    sk_loja         INTEGER DEFAULT dim_loja_id_seq.NEXTVAL,
    nk_id_loja      VARCHAR2(20) NOT NULL,
    nm_loja         VARCHAR2(50) NOT NULL,
    nm_cidade_loja  VARCHAR2(50) NOT NULL,
    nm_regiao_loja  VARCHAR2(50) NOT NULL,
    CONSTRAINT tb_dim_loja_pk PRIMARY KEY (sk_loja) ENABLE
);

CREATE TABLE tb_dim_tempo (
    sk_data         INTEGER NOT NULL,
    data            DATE NOT NULL,
    nr_ano          NUMBER(4) NOT NULL,
    nm_trimestre    VARCHAR2(11),
    nr_mes          NUMBER(2) NOT NULL,
    nm_mes          VARCHAR2(15) NOT NULL,
    nr_semana       NUMBER(2) NOT NULL,
    nm_ano_semana   VARCHAR2(10) NOT NULL,
    nr_dia          NUMBER(2) NOT NULL,
    nm_dia_semana   VARCHAR2(15) NOT NULL,
    flag_feriado    CHAR(3) NOT NULL,
    nm_feriado      VARCHAR2(50) NOT NULL,
    CONSTRAINT tb_dim_tempo_pk PRIMARY KEY (sk_data) ENABLE
);

CREATE TABLE tb_fato_venda (
    sk_cliente  INTEGER NOT NULL,
    sk_produto  INTEGER NOT NULL,
    sk_loja     INTEGER NOT NULL,
    sk_data     INTEGER NOT NULL,
    vl_venda    DECIMAL(12, 4),
    qtd_venda   INTEGER,
    data_carga  DATE,
    CONSTRAINT tb_fato_venda_pk PRIMARY KEY (sk_cliente, sk_produto, sk_loja, sk_data) ENABLE
);