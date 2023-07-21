# Data Warehouse Vendas

## Visão Geral

Este documento descreve o projeto de construção de um Data Warehouse On-Premises para uma loja de varejo fictícia. O projeto teve como objetivo coletar dados de uma fonte dados, armazená-los em uma Staging Area, transformá-los e carregá-los no Data Warehouse. O Data Warehouse foi construído no `Oracle Database 21c` no ambiente `Red Hat Enterprise Linux 8`. 

## Arquitetura do projeto

![Arquitetura do DW](https://github.com/elvinmatheus/VendasDW/blob/main/images/Arquitetura.png)

1. **Extração dos dados:** Nesta etapa, os dados foram extraídos do banco de dados operacional da empresa fictícia. O método de extração escolhido foi a extração incremental, em que obtemos os dados diretamente da fonte.

2. **Staging Area:** Após a coleta, os dados foram armazenados em um Data Staging remoto. 

3. **Transformação dos dados:** Na etapa de transformação ocorreram as rotinas de limpeza de dados, eliminação de inconsistências, inclusão de elementos, merging de dados e integração.

4. **Carga de dados:** Após a transformação, os dados foram carregados nas tabelas dimensões e fato do Data Warehouse.

## Configuração e execução do Data Warehouse

1. **Modelagem Dimensional:** Após as etapas de modelagem de negócio e modelagem lógica inerentes ao processo de construção de um Data Warehouse, elaboramos um diagrama que representa a modelagem dimensional do DW a ser implementado.

![Modelagem Dimensional](https://github.com/elvinmatheus/VendasDW/blob/main/images/Modelagem%20Dimensional.png)

2. **Criação dos Schemas:** Execute o script `1.config.sql` no Oracle DB para a criação dos schemas SOURCE, STAREA e DW.

3. **Criação do Data Source e da Staging Area:** Execute os scripts `2.create_source.sql` e `3.create_stage.sql` no Oracle DB para a criação das tabelas da Fonte de Dados e da Staging Area, bem como para a carga das tabelas da Fonte de Dados.

4. **Extração e Carga para a Staging Area:** Execute o script `4.extract_and_load_to_staging_area.sql` no Oracle DB para extrair os dados da fonte e carregá-los na staging area.

5. **Transformação dos dados:** Execute o script `5.transform.sql` para realizar as rotinas de limpeza dos dados.

6. **Criação do Data Warehouse:** Execute o script `6.create_dw.sql` para criar as tabelas do Data Warehouse.

7. **Carga das tabelas dimensões e fato:** Execute os scripts `7.load_dimensions.sql`, `8.load_fact_table.sql` e `9.constraints` para carregar as tabelas dimensões e fato do Data Warehouse, bem como adicionar as constraints para a tabela fato.

8. **Extra:** Os scripts de 10 a 13 realizam alguns ajustes e melhorias na fonte de dados e Data Warehouse, como a adição de hierarquias, métricas e views.