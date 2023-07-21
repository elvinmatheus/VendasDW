/* Conectado ao usuário dw */

-- Criação das colunas data_inicio, data_fim e flag_ativo na tabela tb_dim_cliente
ALTER TABLE tb_dim_cliente ADD (data_inicio DATE);
ALTER TABLE tb_dim_cliente ADD (data_fim DATE);
ALTER TABLE tb_dim_cliente ADD (flag_ativo CHAR(1));

-- Criação das colunas data_inicio, data_fim e flag_ativo na tabela tb_dim_produto
ALTER TABLE tb_dim_produto ADD (data_inicio DATE);
ALTER TABLE tb_dim_produto ADD (data_fim DATE);
ALTER TABLE tb_dim_produto ADD (flag_ativo CHAR(1));

-- Criação das colunas data_inicio, data_fim e flag_ativo na tabela tb_dim_loja
ALTER TABLE tb_dim_loja ADD (data_inicio DATE);
ALTER TABLE tb_dim_loja ADD (data_fim DATE);
ALTER TABLE tb_dim_loja ADD (flag_ativo CHAR(1));

-- Carga de dados nas novas colunas criadas em cada tabela
UPDATE tb_dim_cliente SET flag_ativo = 1;
commit;

UPDATE tb_dim_produto SET flag_ativo = 1;
commit;

UPDATE tb_dim_loja SET flag_ativo = 1;
commit;

UPDATE tb_dim_cliente SET data_inicio = CURRENT_DATE;
commit;

UPDATE tb_dim_produto SET data_inicio = CURRENT_DATE;
commit;

UPDATE tb_dim_loja SET data_inicio = CURRENT_DATE;
commit;