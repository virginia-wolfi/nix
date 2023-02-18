-- Использовать транзакции для insert, update, delete на 3х таблицах. 

START TRANSACTION;
DELETE FROM orders
WHERE updated_at <= '2018-01-01';
ROLLBACK;


START TRANSACTION;
INSERT INTO categories (category_id, category_title, category_description)
VALUES 
(21, 'Category 21', 'Category 21 description'),
(22, 'Category 22', 'Category 22 description');
ROLLBACK;

START TRANSACTION;
UPDATE users
SET phone_number = CONCAT('phone_number ', user_id);
ROLLBACK;

-- Придумать 3 запроса, которые можно оптимизировать с помощью индекса 
-- (проверять стоит ли оптимизировать запрос оператором explain) 
-- и оптимизировать их используя индекс. 
-- Результат проверять также оператором explain.

EXPLAIN ANALYZE
SELECT * FROM users
WHERE first_name = 'first_name 2742' and last_name = 'last_name 2742';


CREATE INDEX first_last_name ON users(first_name, last_name);


EXPLAIN ANALYZE
SELECT  * FROM products
WHERE price BETWEEN 200 AND 300

CREATE INDEX price_ind ON products(price)

EXPLAIN ANALYZE
SELECT  * FROM products
WHERE price BETWEEN 200 AND 500

-- Написать представление для таблицы products, для таблиц order_status и order , 
-- для таблиц products и category

CREATE VIEW rare_products AS
SELECT * FROM products
WHERE in_stock < 5
WITH LOCAL CHECK OPTION;

CREATE VIEW accepted_orders AS
SELECT order_id, cart_id, total
FROM order_status
JOIN orders USING(order_status_id)
WHERE order_status_id = 1;

CREATE VIEW cat_20_products AS
SELECT product_id, product_title, in_stock, price
FROM products JOIN categories USING(category_id)
WHERE category_id = 20

-- Написать 2 любые хранимые процедуры.

ALTER TABLE products
ALTER COLUMN product_id 
ADD GENERATED ALWAYS AS IDENTITY (start with 4001 increment by 1);

CREATE OR REPLACE PROCEDURE add_product
	(	title varchar,
		description text,
		stock int,
		price real,
		slug varchar,
		category_id int
	)
LANGUAGE sql
AS $$
	INSERT INTO products (product_title, product_description, in_stock, price, slug, category_id)
	VALUES
		(
		title,
		description,
		stock, 
		price, 
		slug, 
		category_id
		)

$$;

CREATE OR REPLACE PROCEDURE change_status (order_id int, status_id int)
LANGUAGE SQL
AS $$
	UPDATE orders
	SET order_status_id = status_id
	WHERE order_id = order_id
	
$$


-- Создать функцию, которая сетит shipping_total = 0 в таблице order, если город юзера равен x. 
-- Использовать IF clause.

ALTER TABLE orders
ADD CONSTRAINT cart_id_fk FOREIGN KEY (cart_id) REFERENCES carts(cart_id)

CREATE  OR REPLACE FUNCTION set_shipping_total (city_name varchar) RETURNS void AS $$
DECLARE 
BEGIN
	IF city_name NOT IN (SELECT city FROM users) THEN
	RAISE EXCEPTION 'There is no (%) in users table', city_name;
	ELSE
		UPDATE orders
		SET shipping_total = 0
		WHERE cart_id IN
						(SELECT cart_id 
						FROM carts JOIN users 
						USING(user_id)
						WHERE city = city_name);
	END IF;
END;
$$ language plpgsql

SELECT set_shipping_total('city 1')
DROP FUNCTION set_shipping_total(character varying)
-- Сравнить цену каждого продукта n с средней ценой продуктов в категории продукта n. 
-- Использовать window function. Таблица результата должна содержать такие колонки: 
-- category_title, product_title, price, avg. 
-- Пример для решения можно найти в теории.



