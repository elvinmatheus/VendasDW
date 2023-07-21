/* Conectado como usuário source */

-- Criação das tabelas
CREATE TABLE tb_cadastro_cliente (
    id_cliente    INTEGER         NOT NULL,
    nome_cliente  VARCHAR2(100),
    email_cliente VARCHAR2(50),
    CONSTRAINT tb_cadastro_cliente_pk PRIMARY KEY (id_cliente) ENABLE
);

CREATE TABLE tb_endereco (
    id_endereco INTEGER         NOT NULL, 
    logradouro  VARCHAR2(50), 
    numero      NUMBER,
    cidade      VARCHAR2(20), 
    estado      VARCHAR2(20), 
    pais        VARCHAR2(20),
    cep         VARCHAR2(20),
    id_cliente  INTEGER,
    CONSTRAINT tb_endereco_pk   PRIMARY KEY (id_endereco) ENABLE,
    CONSTRAINT tb_endereco_fk1  FOREIGN KEY (id_cliente) REFERENCES tb_cadastro_cliente(id_cliente) ENABLE
);

CREATE TABLE tb_categoria (
    id_categoria        INTEGER         NOT NULL, 
    nome_categoria      VARCHAR2(20),
    nome_sub_categoria  VARCHAR2(20),
    CONSTRAINT tb_categoria_pk PRIMARY KEY (id_categoria) ENABLE
);

CREATE TABLE tb_produto (
    id_produto      INTEGER         NOT NULL, 
    SKU             VARCHAR2(30),
    nome_produto    VARCHAR2(100),
    id_categoria    INTEGER,
    CONSTRAINT tb_produto_pk    PRIMARY KEY (id_produto) ENABLE,
    CONSTRAINT tb_produto_fk1   FOREIGN KEY (id_categoria) REFERENCES tb_categoria(id_categoria) ENABLE
);

CREATE TABLE tb_loja (
    id_loja     INTEGER         NOT NULL,
    nome_loja   VARCHAR2(100),
    cidade_loja VARCHAR2(20),
    CONSTRAINT tb_loja_pk PRIMARY KEY (id_loja) ENABLE
);

CREATE TABLE tb_pedidos (
    id_transacao        INTEGER         NOT NULL, 
    data_transacao      TIMESTAMP, 
    data_entrega        TIMESTAMP,
    status_pagamento    VARCHAR2(20),
    id_cliente          INTEGER,
    id_loja             INTEGER,
    CONSTRAINT tb_pedidos_pk    PRIMARY KEY (id_transacao)  ENABLE,
    CONSTRAINT tb_pedidos_fk1   FOREIGN KEY (id_cliente)    REFERENCES tb_cadastro_cliente(id_cliente) ENABLE,
    CONSTRAINT tb_pedidos_fk2   FOREIGN KEY (id_loja)       REFERENCES tb_loja(id_loja) ENABLE
);

CREATE TABLE tb_itens_pedido (
    id_transacao    INTEGER NOT NULL,
    id_produto      INTEGER NOT NULL,
    quantidade      INTEGER,
    preco_unitario  DOUBLE PRECISION,
    CONSTRAINT tb_itens_pedido_pk   PRIMARY KEY (id_transacao, id_produto) ENABLE,
    CONSTRAINT tb_itens_pedido_fk1  FOREIGN KEY (id_produto) REFERENCES tb_produto(id_produto) ENABLE
);

-- Carga dos dados
TRUNCATE TABLE TB_CADASTRO_CLIENTE;
INSERT ALL
    INTO tb_cadastro_cliente (id_cliente, nome_cliente, email_cliente) VALUES ('1098', 'Pele', 'pele@gmail.com');
    INTO tb_cadastro_cliente (id_cliente, nome_cliente, email_cliente) VALUES ('1099', 'Zico', 'zico@gmail.com');
    INTO tb_cadastro_cliente (id_cliente, nome_cliente, email_cliente) VALUES ('1000', 'Ronaldo', 'ronaldo@gmail.com');
    INTO tb_cadastro_cliente (id_cliente, nome_cliente, email_cliente) VALUES ('1198', 'Rivaldo', 'rivaldo@gmail.com');
    INTO tb_cadastro_cliente (id_cliente, nome_cliente, email_cliente) VALUES ('1298', 'Zidane', 'zidane@gmail.com');
    INTO tb_cadastro_cliente (id_cliente, nome_cliente, email_cliente) VALUES ('1398', 'Cristiano', 'cristiano@gmail.com');
    INTO tb_cadastro_cliente (id_cliente, nome_cliente, email_cliente) VALUES ('1048', 'Messi', '');
    INTO tb_cadastro_cliente (id_cliente, nome_cliente, email_cliente) VALUES ('1928', 'Julio', 'xxxgmail.com');
    INTO tb_cadastro_cliente (id_cliente, nome_cliente, email_cliente) VALUES ('1028', 'Messias', 'messias@gmail.com');
    INTO tb_cadastro_cliente (id_cliente, nome_cliente, email_cliente) VALUES ('1348', 'Matusalem', '12345');
commit;

TRUNCATE TABLE TB_ENDERECO;
INSERT ALL 
    INTO tb_endereco (id_endereco, logradouro, numero, cidade, estado, pais, cep, id_cliente) VALUES ('999887766', 'Rua Nano', '245', 'Rio de Janeiro', 'RJ', 'Brasil', '22998-761', '1098');
    INTO tb_endereco (id_endereco, logradouro, numero, cidade, estado, pais, cep, id_cliente) VALUES ('999887768', 'Rua Macieiras', '12', 'Belo Horizonte', 'MG', 'Brasil', '22998-763', '1099');
    INTO tb_endereco (id_endereco, logradouro, numero, cidade, estado, pais, cep, id_cliente) VALUES ('999887769', 'Av. Goiabeiras', '76', 'Vela Velha', 'ES', 'Brasil', '21998-763', '1000');
    INTO tb_endereco (id_endereco, logradouro, numero, cidade, estado, pais, cep, id_cliente) VALUES ('999887770', 'Av. Kremilim', '769', 'Cariacica', 'ES', 'Brasil', '21398-763', '1198');
commit;

TRUNCATE TABLE TB_CATEGORIA;
INSERT ALL 
    INTO tb_categoria (id_categoria, nome_categoria, nome_sub_categoria) VALUES ('87654', 'Notebook', 'Pessoal');
    INTO tb_categoria (id_categoria, nome_categoria, nome_sub_categoria) VALUES ('87655', 'Notebook', 'Business');
    INTO tb_categoria (id_categoria, nome_categoria, nome_sub_categoria) VALUES ('87656', 'Camera', 'Longa Distância');
    INTO tb_categoria (id_categoria, nome_categoria, nome_sub_categoria) VALUES ('87657', 'Camera', 'Semi Profissional');
    INTO tb_categoria (id_categoria, nome_categoria, nome_sub_categoria) VALUES ('87658', 'Smartphone', '8 GB Memória');
    INTO tb_categoria (id_categoria, nome_categoria, nome_sub_categoria) VALUES ('87659', 'Smartphone', '4 GB Memória');
commit;

TRUNCATE TABLE TB_PRODUTO;
INSERT ALL
    INTO tb_produto (id_produto, sku, nome_produto, id_categoria) VALUES ('12098712', 'DFGTHN6ER4RF', 'Notebook Vaio', '87654');
    INTO tb_produto (id_produto, sku, nome_produto, id_categoria) VALUES ('12098713', 'DFWEHN6ER4RF', 'Iphone 8', '87658');
    INTO tb_produto (id_produto, sku, nome_produto, id_categoria) VALUES ('12098714', 'DF11HN6ER4RF', 'Camera Sony', '87657');
    INTO tb_produto (id_produto, sku, nome_produto, id_categoria) VALUES ('12098715', 'DFGUHN6ER4RF', 'Notebook MSI 16 GB', '87654');
    INTO tb_produto (id_produto, sku, nome_produto, id_categoria) VALUES ('12098716', 'DFGUHN6E07RF', 'Samsung Galaxy 9', '87659');
    INTO tb_produto (id_produto, sku, nome_produto, id_categoria) VALUES ('12098717', 'DFGUHN6ER08F', 'Camera Canon XTR', '87656');
    INTO tb_produto (id_produto, sku, nome_produto, id_categoria) VALUES ('12098718', 'DFGUHN6094RF', 'Notebook ASUS 16 GB', '87654');
commit;

TRUNCATE TABLE TB_LOCALIDADE;
INSERT ALL
    INTO tb_loja (id_loja, nome_loja, cidade_loja) VALUES ('1', 'Loja Barueri', 'Barueri');
    INTO tb_loja (id_loja, nome_loja, cidade_loja) VALUES ('2', 'Loja Centro', 'São Paulo');
    INTO tb_loja (id_loja, nome_loja, cidade_loja) VALUES ('3', 'Loja Tatuape', 'Tatuapé');
    INTO tb_loja (id_loja, nome_loja, cidade_loja) VALUES ('4', 'Loja Cinelandia', 'Rio de Janeiro');
    INTO tb_loja (id_loja, nome_loja, cidade_loja) VALUES ('5', 'Loja Pelourinho', 'Salvador');
commit;

TRUNCATE TABLE TB_PEDIDOS;
INSERT ALL 
    INTO tb_pedidos (id_transacao, data_transacao, data_entrega, status_pagamento, id_cliente, id_loja) VALUES ('009987654432', null, TO_TIMESTAMP('2023-04-17 14:23:22.395000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 'Pago', '1099', 1);
    INTO tb_pedidos (id_transacao, data_transacao, data_entrega, status_pagamento, id_cliente, id_loja) VALUES ('009985654432', TO_TIMESTAMP('2023-04-16 14:22:38.437000000', 'YYYY-MM-DD HH24:MI:SS.FF'), TO_TIMESTAMP('2023-04-17 15:23:22.395000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 'Pago', '1098', 2);
    INTO tb_pedidos (id_transacao, data_transacao, data_entrega, status_pagamento, id_cliente, id_loja) VALUES ('009985554432', null, TO_TIMESTAMP('2023-04-17 16:23:22.395000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 'Pago', '1000', 5);
    INTO tb_pedidos (id_transacao, data_transacao, data_entrega, status_pagamento, id_cliente, id_loja) VALUES ('009981254432', TO_TIMESTAMP('2023-04-16 16:22:38.437000000', 'YYYY-MM-DD HH24:MI:SS.FF'), TO_TIMESTAMP('2023-04-17 16:23:22.395000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 'NA', '1398', 2);
    INTO tb_pedidos (id_transacao, data_transacao, data_entrega, status_pagamento, id_cliente, id_loja) VALUES ('009982354432', TO_TIMESTAMP('2023-04-16 17:28:38.437000000', 'YYYY-MM-DD HH24:MI:SS.FF'), TO_TIMESTAMP('2023-04-17 17:13:22.395000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 'Pago', '1048', 3);
    INTO tb_pedidos (id_transacao, data_transacao, data_entrega, status_pagamento, id_cliente, id_loja) VALUES ('009987954432', TO_TIMESTAMP('2023-04-16 18:24:38.437000000', 'YYYY-MM-DD HH24:MI:SS.FF'), TO_TIMESTAMP('2023-04-17 18:43:22.395000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 'Pago', '1028', 4);
    INTO tb_pedidos (id_transacao, data_transacao, data_entrega, status_pagamento, id_cliente, id_loja) VALUES ('009980954432', TO_TIMESTAMP('2023-04-16 13:29:38.437000000', 'YYYY-MM-DD HH24:MI:SS.FF'), TO_TIMESTAMP('2023-04-17 19:53:22.395000000', 'YYYY-MM-DD HH24:MI:SS.FF'), 'Pago', '1348', 5);
commit;

TRUNCATE TABLE TB_ITENS_PEDIDO;
INSERT ALL 
    INTO tb_itens_pedido (id_transacao, id_produto, quantidade, preco_unitario) VALUES ('009987654432', '12098712', '1', '2900.00');
    INTO tb_itens_pedido (id_transacao, id_produto, quantidade, preco_unitario) VALUES ('009985654432', '12098713', '1', '3900.00');
    INTO tb_itens_pedido (id_transacao, id_produto, quantidade, preco_unitario) VALUES ('009985554432', '12098712', '3', '2870.00');
    INTO tb_itens_pedido (id_transacao, id_produto, quantidade, preco_unitario) VALUES ('009981254432', '12098715', '1', '1765.00');
    INTO tb_itens_pedido (id_transacao, id_produto, quantidade, preco_unitario) VALUES ('009982354432', '12098714', '2', '1740.00');
    INTO tb_itens_pedido (id_transacao, id_produto, quantidade, preco_unitario) VALUES ('009987954432', '12098712', '1', '1900.00');
    INTO tb_itens_pedido (id_transacao, id_produto, quantidade, preco_unitario) VALUES ('009980954432', '12098718', '2', '856.00');
commit;