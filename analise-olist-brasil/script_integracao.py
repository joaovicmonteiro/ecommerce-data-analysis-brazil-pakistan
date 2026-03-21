from sqlalchemy import create_engine
import pandas as pd

# 1. Configuração dos dados de acesso
usuario='root'
senha='2905'
host='localhost'
porta='3306'
banco='olist_ecommerce'

# 2. String de conexão - dialeto+driver://usuario:senha@host:porta/banco
url_conexao = f'mysql+mysqlconnector://{usuario}:{senha}@{host}:{porta}/{banco}'

# 3. Criar o engine 
engine = create_engine(url_conexao)

# 4. Puxando dados do banco 
try: 
    query1 = """
    SELECT 
        oi.order_id,
        p.product_category_name,
        oi.price,
        oi.freight_value
    FROM order_items oi
    JOIN products p ON oi.product_id = p.product_id
    ORDER BY oi.price DESC; """

    df = pd.read_sql(query1, con=engine)
    print(f"\n{10 * '='} 5 Consultas estratégicas {10 * '='}")
    print("\n1) Essa consulta tem como objetivo verificar as categorias de produtos que mais aparecem e as que menos aparecem acima do limite superior dos preços. \nPara assim entender quais as categorias consideradas Premium do ecommerce.\n Ela é uma relação entre as tabelas order_items e products.")
    print(df.head())

    query2 = """
    SELECT review_score, count(*) as total_review
    FROM order_reviews
    WHERE review_score in (1,2,3,4,5)
    GROUP BY review_score
    ORDER BY  review_score ASC;
"""
    print(f"\n2) Para buscar entender qual está sendo a avaliação dos compradores da empresa. Foi realizado a contagem de cada avaliação: ")
    df_2 = pd.read_sql(query2, con=engine)
    print(df_2)

    print(f"\n3) Número de clientes por região em ordem decrescente: ")
    query3 = """
    SELECT geo.geolocation_state, COUNT(c.customer_id) AS total_clientes
    FROM customers c
    JOIN(
	SELECT DISTINCT geolocation_zip_code_prefix, geolocation_state
    FROM geolocation) as geo 
    ON c.customer_zip_code_prefix = geo.geolocation_zip_code_prefix
    GROUP BY geo.geolocation_state
    ORDER BY total_clientes DESC;
"""
    df_3 = pd.read_sql(query3, con=engine)
    print(df_3)

    print(f"\n4) Cancelamentos por segmento de pedidos: ")
    query4 = """
    SELECT 
    CASE 
        WHEN sub.faturamento_pedido > 305.90 THEN 'Premium'
        ELSE 'Normal'
    END AS segmento_pedido,
    COUNT(sub.order_id) AS qtd_pedidos_cancelados,
    SUM(sub.faturamento_pedido) AS total_valor_cancelado
    FROM (
    -- Subquery para somar o valor total por pedido antes de filtrar
    SELECT o.order_id, o.order_status, SUM(i.price) AS faturamento_pedido
    FROM orders o
    JOIN order_items i ON o.order_id = i.order_id
    WHERE o.order_status = 'canceled'
    GROUP BY o.order_id
) AS sub
GROUP BY segmento_pedido;   
"""
    df_4 = pd.read_sql(query4, con=engine )
    print(df_4)
    print(f"\n5) Número de pedidos por categoria: ")
    query5 = """
    SELECT 
        p.product_category_name AS categoria,
        COUNT(DISTINCT o.order_id) AS total_pedidos
    FROM orders o
    JOIN order_items i ON o.order_id = i.order_id
    JOIN products p ON i.product_id = p.product_id
    WHERE o.order_status = 'delivered'
    GROUP BY p.product_category_name
    ORDER BY total_pedidos DESC;
"""
    df_5 = pd.read_sql(query5, con=engine)
    print(df_5.head(10))
except Exception as e:
    print(f"Erro ao conectar: {e}")
