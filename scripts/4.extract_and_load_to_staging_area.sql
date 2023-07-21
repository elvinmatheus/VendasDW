/* Conectado como usuário system */

-- Concede privilégios ao usuário starea para acessar as tabelas do usuário source
GRANT SELECT ON source.tb_cadastro_cliente  TO starea;
GRANT SELECT ON source.tb_endereco          TO starea;
GRANT SELECT ON source.tb_produto           TO starea;
GRANT SELECT ON source.tb_categoria         TO starea;
GRANT SELECT ON source.tb_loja              TO starea;
GRANT SELECT ON source.tb_pedidos           TO starea;
GRANT SELECT ON source.tb_itens_pedido      TO starea;


/* Conectado ao usuário starea */

-- Carga de dados nas tabelas da staging area
TRUNCATE TABLE st_cadastro_cliente;
INSERT INTO st_cadastro_cliente
SELECT * FROM source.tb_cadastro_cliente;
commit;

TRUNCATE TABLE st_endereco;
INSERT INTO st_endereco
SELECT * FROM source.tb_endereco;
commit;

TRUNCATE TABLE st_produto;
INSERT INTO st_produto
SELECT * FROM source.tb_produto;
commit;

TRUNCATE TABLE st_categoria;
INSERT INTO st_categoria
SELECT * FROM source.tb_categoria;
commit;

TRUNCATE TABLE st_loja;
INSERT INTO st_loja
SELECT * FROM source.tb_loja;
commit;

TRUNCATE TABLE st_pedidos;
INSERT INTO st_pedidos
SELECT * FROM source.tb_pedidos;
commit;

TRUNCATE TABLE st_itens_pedido;
INSERT INTO st_itens_pedido
SELECT * FROM source.tb_itens_pedido;
commit;