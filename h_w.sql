-- 12 
--В созданной БД в задании 4:
--1. добавьте в таблицу users колонку phone_number (int)
--2. поменяйте тип данных в таблице users колонка phone_number с int на varchar

ALTER TABLE users
ADD COLUMN phone_number int;

ALTER TABLE users
ALTER COLUMN phone_number SET  DATA TYPE varchar

--13
--В созданной БД в задании 4:  
--в таблице products увеличьте цену в 2 раза
UPDATE products
SET price = price*2


--14
--Вывести:
--1. всех юзеров,
--2. все продукты,
--3. все статусы заказов

SELECT first_name || ' ' || last_name FROM users;
SELECT product_title FROM products;
SELECT status_name FROM order_status

-- 15
--Вывести заказы, которые успешно доставлены и оплачены

SELECT * FROM orders
JOIN order_status USING(order_status_id)
WHERE status_name = 'Finished'

--16.	
--Вывести: (если задание можно решить несколькими способами, указывай все)
--1. продукты, цена которых больше 80.00 и меньше или равно 150.00
--2. заказы совершенные после 01.10.2020 (поле created_at)
--3. заказы полученные за первое полугодие 2020 года
--4. подукты следующих категорий Category 7, Category 11, Category 18
--5. незавершенные заказы по состоянию на 31.12.2020
--6. вывести все корзины, которые были созданы, но заказ так и не был оформлен.

SELECT product_title
FROM products
WHERE price BETWEEN 81 AND 150;

SELECT * FROM orders
WHERE created_at > '2020-10-01';

SELECT * FROM orders
WHERE created_at BETWEEN '2020-01-01' AND '2020-06-30';

SELECT product_title
FROM products 
JOIN categories USING(category_id)
WHERE category_title IN ('Category 7', 'Category 11', 'Category 18');

SELECT * FROM orders
JOIN order_status USING(status_id)
WHERE status_name <> 'Finished';

SELECT * FROM carts
JOIN (SELECT cart_id FROM carts
	  EXCEPT
	  SELECT cart_id FROM orders) AS  not_proceeded
USING(cart_id)

--17.
--Вывести:
--1. среднюю сумму всех завершенных сделок
--2. вывести максимальную сумму сделки за 3 квартал 2020

SELECT AVG(total)
FROM orders
JOIN order_status
USING(order_status_id)
WHERE status_name = 'Finished';


SELECT MAX(total)
FROM orders
WHERE created_at BETWEEN '2020-06-01' AND '2020-09-01';


-- 18.
-- Создайте новую таблицу potential_customers с полями id, email, name, surname, second_name, city
-- Заполните данными таблицу.
-- Выведите имена и электронную почту потеницальных и существующих пользователей из города city 17

CREATE TABLE potential_customers
	(p_c_id int,
	p_c_email varchar(20),
	p_c_name varchar,
	p_c_surname varchar,
	p_c_second_name varchar
	p_c_city varchar)

--19.
--Вывести имена и электронные адреса всех users отсортированных по городам и по имени (по алфавиту)

SELECT first_name || ' ' || last_name, email
FROM users
ORDER BY city, first_name, last_name



-- 20.
-- Вывести наименование группы товаров,
-- общее количество по группе товаров в порядке убывания количества

SELECT category_title, SUM(in_stock) AS total_amount
FROM categories JOIN products USING(category_id)
GROUP BY category_id
ORDER BY total_amount DESC;


-- 21.	
-- 1. Вывести продукты, которые ни разу не попадали в корзину.
-- 2. Вывести все продукты, которые так и не попали ни в 1 заказ. (но в корзину попасть могли).
-- 3. Вывести топ 10 продуктов, которые добавляли в корзины чаще всего.
-- 4. Вывести топ 10 продуктов, которые не только добавляли в корзины, но и оформляли заказы чаще всего.
-- 5. Вывести топ 5 юзеров, которые потратили больше всего денег (total в заказе).
-- 6. Вывести топ 5 юзеров, которые сделали больше всего заказов (кол-во заказов).
-- 7. Вывести топ 5 юзеров, которые создали корзины, но так и не сделали заказы.

SELECT product_id, product_title
FROM products
WHERE product_id NOT IN (SELECT product_id
				         FROM products JOIN cart_products
				         USING(product_id));
				
SELECT cart_id, product_id INTO ordered_products
FROM cart_products JOIN orders
USING(cart_id);		

SELECT product_id, product_title
FROM products
WHERE product_id NOT IN (SELECT product_id
				         FROM ordered_products);

SELECT product_id, COUNT(product_id) INTO popular_products
FROM products JOIN cart_products
USING(product_id)
GROUP BY product_id
ORDER BY COUNT(product_id) DESC
LIMIT 10;


SELECT product_id, product_title
FROM popular_products
JOIN products
USING(product_id);

					 
SELECT product_id, COUNT(product_id) INTO most_ordered_products
FROM cart_products JOIN orders
USING(cart_id)
GROUP BY product_id
ORDER BY COUNT(product_id) DESC
LIMIT 10;

SELECT product_id, product_title
FROM most_ordered_products
JOIN products
USING(product_id);

DROP TABLE biggest_sales; 

SELECT order_id, user_id, orders.total INTO biggest_sales
FROM carts JOIN orders
USING(cart_id)
ORDER BY orders.total DESC
LIMIT 5;

SELECT user_id, first_name || ' ' || last_name AS user_name
FROM biggest_sales JOIN users
USING(user_id)

SELECT user_id, COUNT(order_id) as orders_amount INTO loyal_clients
FROM carts JOIN orders
USING(cart_id)
GROUP BY user_id
ORDER BY orders_amount DESC
LIMIT 5;


SELECT user_id, first_name || ' ' || last_name AS user_name
FROM loyal_clients
JOIN users
USING(user_id);

SELECT user_id, first_name || ' ' || last_name AS user_name
FROM users JOIN carts 
USING(user_id)
WHERE cart_id NOT IN 
					(SELECT cart_id
					FROM orders)
					
LIMIT 5
