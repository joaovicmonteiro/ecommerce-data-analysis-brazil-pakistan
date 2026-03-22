CREATE SCHEMA olist_ecommerce;

CREATE TABLE Customers(
customer_id CHAR(32) PRIMARY KEY, -- ID da transação/ ID do Carrinho
customer_unique_id CHAR(32), -- id que se refere a um cliente / Como se fosse um 'CPF'
customer_zip_code_prefix VARCHAR(5), -- Chave estrangeira?
-- customer_city VARCHAR(50),
--  customer_state CHAR(2),
FOREIGN KEY (customer_zip_code_prefix) REFERENCES Geolocation(geolocation_zip_code_prefix) -- Garante que o cliente esteja cadastrado na tabela geolocation.
);

-- Talvez tenha que criar uma variavel para ficar como chave primaria
CREATE TABLE Geolocation(
geolocation_zip_code_prefix VARCHAR(5) PRIMARY KEY, -- Chave primaria? Depende?
geolocation_lat DECIMAL(10,8), -- Ponto que pode dar problema. Devido a qnt de numeros.
geolocation_lng DECIMAL(11,8),
geolocation_city VARCHAR(100),
geolocation_state CHAR(2)
);

CREATE TABLE Order_items(
order_id CHAR (32), -- Chave estrangeira?  Tirar duvida em relação a quantidade - Os ids estão todos com 32 de tamanho.
order_item_id SMALLINT, -- Não sei oq é isso. Descobrir. (serve para identificar se aquele é o primeiro, o segundo ou o terceiro item desse pedido específico)
product_id	VARCHAR(50), -- Chave estrangeira
seller_id VARCHAR(50), -- Chave estrangeira
shipping_limit_date DATETIME, -- Tirar duvida entre DATIME e TIMESTAMP(FUSO)
price DECIMAL(10,2),
freight_value DECIMAL(10,2),
-- A chave primária é a combinação do Pedido + Sequencial do Item
PRIMARY KEY (order_id, order_item_id),
FOREIGN KEY (order_id) REFERENCES Orders(order_id),
FOREIGN KEY (product_id) REFERENCES Products(product_id),
FOREIGN KEY (seller_id) REFERENCES Sellers(seller_id)
);

CREATE TABLE Order_payments(
order_id CHAR(32), -- Chave estrangeira?
payment_sequential TINYINT, -- Tirar duvida. Qual a melhor forma? 
payment_type VARCHAR(20),
payment_installments TINYINT,
payment_value DECIMAL(10,2),
PRIMARY KEY (order_id, payment_sequential),
FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Order_reviews(
review_id CHAR(32),
order_id CHAR(32), -- Chave estrangeira
review_score TINYINT, -- Numeros de 1 a 5.
review_comment_title VARCHAR(50),
review_comment_message VARCHAR(500),
review_creation_date DATETIME,
review_answer_timestamp DATETIME,
PRIMARY KEY (review_id, order_id),
FOREIGN KEY (order_id) REFERENCES Orders(order_id),
CONSTRAINT check_review_score_limite CHECK (review_score >= 0 AND review_score <= 5) -- Não sei se funciona. Objetivo de limitar de 0 a 5 a avaliação.
);

CREATE TABLE Orders(
order_id CHAR(32) PRIMARY KEY,
customer_id CHAR(32), -- Chave estrangeira
order_status VARCHAR(20),
order_purchase_timestamp DATETIME,
order_approved_at DATETIME,
order_delivered_carrier_date DATETIME,
order_delivered_customer_date DATETIME,
order_estimated_delivery_date DATETIME,
FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Rever se o uso de tinyint e smallint estão corretos na tabela.
CREATE TABLE Products(
product_id CHAR(32) PRIMARY KEY,
product_category_name VARCHAR(100), -- Chave estrangeira
product_name_length DECIMAL(10,1),
product_description_length SMALLINT,
product_photos_qty TINYINT,
product_weight_g DECIMAL(10,1),
product_length_cm DECIMAL(10,1),
product_height_cm DECIMAL(10,1), -- Verificar se o uso está correto.
product_width_cm DECIMAL(10,1),
FOREIGN KEY (product_category_name) REFERENCES Product_category_name_translation(product_category_name)
);

CREATE TABLE Sellers(
seller_id VARCHAR(50) PRIMARY KEY,
seller_zip_code_prefix VARCHAR(5), -- Pode dar erro pela quantidade.
-- seller_city VARCHAR (50), -- Cidade e estado não deveria vir também da tabela geolocation?
-- seller_state CHAR(2), -- Remover os dois seria a melhor opção para não duplicar dados. Verificar com JOIN se preciso.
FOREIGN KEY (seller_zip_code_prefix) REFERENCES Geolocation(geolocation_zip_code_prefix)
);

-- Rever a necessidade dessa tabela.
CREATE TABLE Product_category_name_translation(
product_category_name VARCHAR(100) PRIMARY KEY,
product_category_name_english VARCHAR(100)
);


