-- ============================================
-- ONLINE CLOTHING STORE
-- 13 КЕСТЕ
-- БАРЛЫҒЫ БАЙЛАНЫСҚАН
-- ============================================

USE master;
GO

-- Егер база бұрын бар болса, өшіреміз
IF DB_ID('OnlineClothingStore') IS NOT NULL
BEGIN
    ALTER DATABASE OnlineClothingStore
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;

    DROP DATABASE OnlineClothingStore;
END
GO

-- ============================================
-- DATABASE ҚҰРУ
-- ============================================

CREATE DATABASE OnlineClothingStore;
GO

USE OnlineClothingStore;
GO


-- ============================================
-- 1. ADMIN — ӘКІМШІ
-- ============================================

CREATE TABLE Admin
(
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100),
    password NVARCHAR(100)
);
GO


-- ============================================
-- 2. MANAGER — МЕНЕДЖЕР
-- ============================================

CREATE TABLE Manager
(
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(30),
    email NVARCHAR(100),

    admin_id INT,

    FOREIGN KEY (admin_id)
        REFERENCES Admin(id)
);
GO


-- ============================================
-- 3. CLIENT — КЛИЕНТ
-- ============================================

CREATE TABLE Client
(
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(30),
    email NVARCHAR(100),
    address NVARCHAR(200),
    password NVARCHAR(100),

    admin_id INT,

    FOREIGN KEY (admin_id)
        REFERENCES Admin(id)
);
GO


-- ============================================
-- 4. CATEGORY — САНАТ
-- ============================================

CREATE TABLE Category
(
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(500),

    admin_id INT,

    FOREIGN KEY (admin_id)
        REFERENCES Admin(id)
);
GO


-- ============================================
-- 5. WAREHOUSE — ҚОЙМА
-- ============================================

CREATE TABLE Warehouse
(
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    address NVARCHAR(200),
    phone NVARCHAR(30),

    admin_id INT,
    manager_id INT,

    FOREIGN KEY (admin_id)
        REFERENCES Admin(id),

    FOREIGN KEY (manager_id)
        REFERENCES Manager(id)
);
GO


-- ============================================
-- 6. WAREHOUSE EMPLOYEE — ҚОЙМА ҚЫЗМЕТКЕРІ
-- ============================================

CREATE TABLE WarehouseEmployee
(
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(30),
    position NVARCHAR(100),

    warehouse_id INT,
    manager_id INT,

    FOREIGN KEY (warehouse_id)
        REFERENCES Warehouse(id),

    FOREIGN KEY (manager_id)
        REFERENCES Manager(id)
);
GO


-- ============================================
-- 7. PRODUCT — ТАУАР
-- ============================================

CREATE TABLE Product
(
    id INT PRIMARY KEY IDENTITY(1,1),
    name NVARCHAR(150) NOT NULL,
    description NVARCHAR(500),
    price DECIMAL(10,2) NOT NULL,
    image_url NVARCHAR(300),
    status NVARCHAR(50),

    category_id INT,
    warehouse_id INT,
    manager_id INT,
    admin_id INT,

    FOREIGN KEY (category_id)
        REFERENCES Category(id),

    FOREIGN KEY (warehouse_id)
        REFERENCES Warehouse(id),

    FOREIGN KEY (manager_id)
        REFERENCES Manager(id),

    FOREIGN KEY (admin_id)
        REFERENCES Admin(id)
);
GO


-- ============================================
-- 8. CART — СЕБЕТ
-- ============================================

CREATE TABLE Cart
(
    id INT PRIMARY KEY IDENTITY(1,1),
    client_id INT NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    total DECIMAL(10,2) DEFAULT 0,

    FOREIGN KEY (client_id)
        REFERENCES Client(id)
);
GO


-- ============================================
-- 9. CART ITEM — СЕБЕТТЕГІ ТАУАР
-- ============================================

CREATE TABLE CartItem
(
    id INT PRIMARY KEY IDENTITY(1,1),
    cart_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (cart_id)
        REFERENCES Cart(id),

    FOREIGN KEY (product_id)
        REFERENCES Product(id)
);
GO


-- ============================================
-- 10. ORDER — ТАПСЫРЫС
-- ============================================

CREATE TABLE [Order]
(
    id INT PRIMARY KEY IDENTITY(1,1),
    client_id INT NOT NULL,
    manager_id INT,
    admin_id INT,

    order_date DATETIME DEFAULT GETDATE(),
    status NVARCHAR(50),
    total_amount DECIMAL(10,2),
    address NVARCHAR(200),
    comment NVARCHAR(500),

    FOREIGN KEY (client_id)
        REFERENCES Client(id),

    FOREIGN KEY (manager_id)
        REFERENCES Manager(id),

    FOREIGN KEY (admin_id)
        REFERENCES Admin(id)
);
GO


-- ============================================
-- 11. ORDER ITEM — ТАПСЫРЫС ПОЗИЦИЯСЫ
-- ============================================

CREATE TABLE OrderItem
(
    id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,

    FOREIGN KEY (order_id)
        REFERENCES [Order](id),

    FOREIGN KEY (product_id)
        REFERENCES Product(id)
);
GO


-- ============================================
-- 12. PAYMENT — ТӨЛЕМ
-- ============================================

CREATE TABLE Payment
(
    id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    admin_id INT,

    amount DECIMAL(10,2) NOT NULL,
    method NVARCHAR(50),
    status NVARCHAR(50),
    transaction_id NVARCHAR(100),
    paid_at DATETIME,

    FOREIGN KEY (order_id)
        REFERENCES [Order](id),

    FOREIGN KEY (admin_id)
        REFERENCES Admin(id)
);
GO


-- ============================================
-- 13. DELIVERY — ЖЕТКІЗУ
-- ============================================

CREATE TABLE Delivery
(
    id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    manager_id INT,
    warehouse_employee_id INT,

    courier_name NVARCHAR(100),
    tracking_number NVARCHAR(100),
    status NVARCHAR(50),
    delivery_address NVARCHAR(200),
    delivered_at DATETIME,

    FOREIGN KEY (order_id)
        REFERENCES [Order](id),

    FOREIGN KEY (manager_id)
        REFERENCES Manager(id),

    FOREIGN KEY (warehouse_employee_id)
        REFERENCES WarehouseEmployee(id)
);
GO


-- ============================================
-- БАРЛЫҚ 13 КЕСТЕНІ ТЕКСЕРУ
-- ============================================

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;
GO

-- ============================================
-- ТЕКСЕРУ
-- ============================================
create table univer(
    id int primery key,
    name varchar(50),
    age int check (Age >= 21));
)
