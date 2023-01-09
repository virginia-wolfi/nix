import psycopg2
import pandas as pd

connection = psycopg2.connect(user="postgres",
                              password="....", #пароль
                              host="127.0.0.1",
                              port="5432",
                              database="nix")

cursor = connection.cursor()

cursor.execute(
    '''
        CREATE TABLE Users
        (user_id INT PRIMARY KEY,
        email VARCHAR(255),
        password VARCHAR(255),
        first_name VARCHAR(255),
        last_name VARCHAR(255),
        middle_name VARCHAR(255),
        is_staff SMALLINT,
        country VARCHAR(255),
        city VARCHAR(255),
        address TEXT);
        
        CREATE TABLE Categories
        (category_id INT PRIMARY KEY,
        category_title VARCHAR(255),
        category_description TEXT);
        
        CREATE TABLE Products
        (product_id INT PRIMARY KEY,
        product_title VARCHAR(255),
        product_description TEXT,
        in_stock INT,
        price REAL,
        slug VARCHAR(45),
        category_id INT REFERENCES Categories(category_id));
        
        CREATE TABLE Order_status
        (order_status_id INT PRIMARY KEY,
        status_name VARCHAR(255));
        
        CREATE TABLE Carts
        (cart_id INT PRIMARY KEY,
        Users_user_id INT REFERENCES Users(user_id),
        subtotal DECIMAL,
        total DECIMAL,
        timestamp TIMESTAMP(2));
        
        CREATE TABLE Orders
        (order_id INT PRIMARY KEY,
        Carts_cart_id INT REFERENCES Carts(cart_id),
        Order_status_order_status_id INT REFERENCES Order_status(order_status_id),
        shipping_total DECIMAL,
        total DECIMAL,
        created_at TIMESTAMP(2),
        updated_at TIMESTAMP(2));
        
        CREATE TABLE Cart_product
        (carts_cart_id INT REFERENCES Carts(cart_id),
        products_product_id INT REFERENCES Products(product_id));
    ''')
connection.commit()
#Далее необходимо загрузить данный из файлов csv в базу данных.
# Это можно быстро и просто сделать в терминале через заранее установленный
# терминальный интерфейс для PostgreSQL.
# Логинемся на сервер и входим в базу данных:
# sudo -i -u postgres
# psql
# psql -U<USERNAME> -h<HOSTNAME> -d<DB_NAME>
# файлы с данным csv нужно перести в папку кластера БД, для это найдем её:
# show data_directory;
# перенесем туда файлы, чтобы у пользователя postgres были права для
# работы с данными файлами
# \COPY <таблица> FROM <путь до csv файла> DELIMITER ','


