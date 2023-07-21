/* Conectado como usuário starea */

-- Criação das tabelas
CREATE TABLE st_cadastro_cliente (
    id_cliente      INTEGER NOT NULL,
    nome_cliente    VARCHAR2(255),
    email_cliente   VARCHAR2(255)
);

CREATE TABLE st_endereco (
    id_endereco INTEGER NOT NULL,
    logradouro  VARCHAR2(255),
    numero      INTEGER,
    cidade      VARCHAR2(255),
    estado      VARCHAR2(255),
    pais        VARCHAR2(255),
    cep         VARCHAR2(255),
    id_cliente  INTEGER
);

CREATE TABLE st_categoria (
    id_categoria        INTEGER NOT NULL,
    nome_categoria      VARCHAR2(255),
    nome_sub_categoria  VARCHAR2(255)
);

CREATE TABLE st_produto (
    id_produto      INTEGER NOT NULL,
    sku             VARCHAR2(255),
    nome_produto    VARCHAR2(255),
    id_categoria    INTEGER
);

CREATE TABLE st_loja (
    id_loja     INTEGER NOT NULL,
    nome_loja   VARCHAR2(255),
    cidade_loja VARCHAR2(255)
);

CREATE TABLE st_pedidos (
    id_transacao        INTEGER NOT NULL,
    data_transacao      TIMESTAMP,
    data_entrega        TIMESTAMP,
    status_pagamento    VARCHAR2(255),
    id_loja             INTEGER,
    id_cliente          INTEGER
);

CREATE TABLE st_itens_pedido (
    id_transacao    INTEGER NOT NULL,
    id_produto      INTEGER NOT NULL,
    quantidade      INTEGER,
    preco_unitario  DOUBLE PRECISION
);