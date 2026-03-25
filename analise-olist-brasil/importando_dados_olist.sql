SET GLOBAL local_infile = 1;
-- 'OPT_LOCAL_INFILE=1' (passo extra 02 junto ao load data) inserir na sua conexão local (edit da conexão >> Advanced >> Others)

-- Vai adicionando uma parte por vez, no lugar de colocar os 100.000 itens de uma vez.
-- Usar 20.000 itens por arquivo.

SET FOREIGN_KEY_CHECKS = 0; -- Desliga o "segurança"
SET FOREIGN_KEY_CHECKS = 1; -- Liga o "segurança"

LOAD DATA LOCAL INFILE 'C:/Users/joao.gmonteiro.SENACRJEDU/OneDrive - SENAC RIO/UC2_new/Projeto/dados_tratados/geolocation_limpo.csv'
INTO TABLE geolocation
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SET FOREIGN_KEY_CHECKS = 0; -- Como existe dados de custumers que não estão na tabela geolocation, é necessário desligar a checagem.
LOAD DATA LOCAL INFILE 'C:\\Users\\joao.gmonteiro.SENACRJEDU\\OneDrive - SENAC RIO\\UC2_new\\Projeto\\dados_tratados\\customers_limpo.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- customers -> mesma coisa acontece com essa tabela. (talvez seja necessário dividir em 5 também)
LOAD DATA LOCAL INFILE 'C:\\Users\\joao.gmonteiro.SENACRJEDU\\OneDrive - SENAC RIO\\UC2_new\\Projeto\\dados_tratados\\sellers_limpo.csv'
INTO TABLE sellers
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
SET FOREIGN_KEY_CHECKS = 1; 


-- orders -> Adicionar as 5 partes.
LOAD DATA LOCAL INFILE 'C:\\Users\\joao.gmonteiro.SENACRJEDU\\OneDrive - SENAC RIO\\UC2_new\\Projeto\\dados_tratados\\order_limpo\\order_parte_5.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(order_id, customer_id, order_status, @v_purchase, @v_approved, @v_carrier, @v_customer, @v_estimated)
SET 
    order_purchase_timestamp = NULLIF(@v_purchase, ''),
    order_approved_at = NULLIF(@v_approved, ''),
    order_delivered_carrier_date = NULLIF(@v_carrier, ''),
    order_delivered_customer_date = NULLIF(@v_customer, ''),
    order_estimated_delivery_date = NULLIF(@v_estimated, '');
-- é necessário adicionar essa parte para caso seja vazio fique como NULL na tabela.

-- Inserir os dados ->  product_category_name_translation
LOAD DATA LOCAL INFILE 'C:\\Users\\joao.gmonteiro.SENACRJEDU\\OneDrive - SENAC RIO\\UC2_new\\Projeto\\dados_usados\\product_category_name_translation.csv'
INTO TABLE product_category_name_translation
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- products -> Adicionar as 4 partes.
LOAD DATA LOCAL INFILE 'C:\\Users\\joao.gmonteiro.SENACRJEDU\\OneDrive - SENAC RIO\\UC2_new\\Projeto\\dados_tratados\\products_limpo\\products_parte_4.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(product_id, @vproduct_category_name, @v_name_len, @v_desc_len, @v_photos_qty, @v_weight, @v_length, @v_height, @v_width)
SET 
	product_category_name = NULLIF(@vproduct_category_name, ''),
    product_name_length = NULLIF(@v_name_len, ''),
    product_description_length = NULLIF(@v_desc_len, ''),
    product_photos_qty = NULLIF(@v_photos_qty, ''),
    product_weight_g = NULLIF(@v_weight, ''),
    product_length_cm = NULLIF(@v_length, ''),
    product_height_cm = NULLIF(@v_height, ''),
    product_width_cm = NULLIF(@v_width, '');
    

-- order_items -> Adicionar as 5 partes
LOAD DATA LOCAL INFILE 'C:\\Users\\joao.gmonteiro.SENACRJEDU\\OneDrive - SENAC RIO\\UC2_new\\Projeto\\dados_tratados\\order_items_limpo\\order_items_parte_5.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- order_reviews -> adicionar as 5 partes
LOAD DATA LOCAL INFILE 'C:\\Users\\joao.gmonteiro.SENACRJEDU\\OneDrive - SENAC RIO\\UC2_new\\Projeto\\dados_tratados\\order_reviews_limpo\\order_reviews_parte_5.csv'
INTO TABLE order_reviews
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
ESCAPED BY ''  -- Necessário pois existe \' no texto 
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(review_id, order_id, review_score, @v_review_comment_title, @v_review_comment_message, review_creation_date, review_answer_timestamp)
SET
	review_comment_title = NULLIF(@v_review_comment_title, ''),
    review_comment_message = NULLIF(@v_review_comment_message, '');

-- order_payments -> Adicionar as 5 partes
LOAD DATA LOCAL INFILE 'C:\\Users\\joao.gmonteiro.SENACRJEDU\\OneDrive - SENAC RIO\\UC2_new\\Projeto\\dados_tratados\\order_payments_limpo\\order_payments_parte_5.csv'
INTO TABLE order_payments
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SHOW WARNINGS;
TRUNCATE TABLE order_reviews;
Select * from product_category_name_translation


