
    CREATE DATABASE OnlineStore;
GO

USE OnlineStore;
GO


CREATE TABLE Client (
    client_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20),
    email NVARCHAR(100)
);
GO


CREATE TABLE Staff (
    staff_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20),
    role NVARCHAR(20) NOT NULL
        CHECK (role IN (N'Admin', N'Manager'))
);
GO


CREATE TABLE Category (
    category_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(300)
);
GO


CREATE TABLE Product (
    product_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    description NVARCHAR(300),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    size NVARCHAR(20),
    color NVARCHAR(30),
    quantity INT NOT NULL DEFAULT 0 CHECK (quantity >= 0),
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Category(category_id)
);
GO


CREATE TABLE Warehouse (
    warehouse_id INT IDENTITY(1,1) PRIMARY KEY,
    warehouse_name NVARCHAR(100) NOT NULL,
    city NVARCHAR(50) NOT NULL DEFAULT N'Алматы',
    address NVARCHAR(200),
    employee_name NVARCHAR(100),
    employee_phone NVARCHAR(20)
);
GO


CREATE TABLE CartPayment (
    cart_payment_id INT IDENTITY(1,1) PRIMARY KEY,
    client_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    payment_method NVARCHAR(30) NOT NULL
        CHECK (payment_method IN (
            N'Kaspi карта',
            N'Halyk карта'
        )),
    payment_status NVARCHAR(30) NOT NULL
        DEFAULT N'Күтілуде',
    created_at DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    FOREIGN KEY (client_id) REFERENCES Client(client_id)
);
GO


CREATE TABLE [Order] (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    client_id INT NOT NULL,
    staff_id INT,
    cart_payment_id INT,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL CHECK (price >= 0),
    total_amount AS (quantity * price) PERSISTED,
    order_date DATETIME2 NOT NULL DEFAULT SYSDATETIME(),
    status NVARCHAR(30) NOT NULL DEFAULT N'Жаңа',
    address NVARCHAR(200),
    delivery_time DATETIME2,
    qr_scanned BIT NOT NULL DEFAULT 0,

    FOREIGN KEY (client_id) REFERENCES Client(client_id),
    FOREIGN KEY (staff_id) REFERENCES Staff(staff_id),
    FOREIGN KEY (cart_payment_id)
        REFERENCES CartPayment(cart_payment_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id)
);
GO


CREATE TABLE Delivery (
    delivery_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT NOT NULL UNIQUE,
    courier_name NVARCHAR(100),
    courier_phone NVARCHAR(20),
    delivery_status NVARCHAR(30) NOT NULL DEFAULT N'Дайындалуда',
    delivered_at DATETIME2,
    FOREIGN KEY (order_id) REFERENCES [Order](order_id)
);
GO


INSERT INTO Warehouse (
    warehouse_name, city, address,
    employee_name, employee_phone
)
VALUES (
    N'Негізгі қойма',
    N'Алматы',
    N'Алматы қаласы',
    N'Қойма қызметкері',
    N'87000000000'
);
GO


INSERT INTO Category (name, description)
VALUES
(N'Футболка', N'Күнделікті киім'),
(N'Шалбар', N'Ерлер мен әйелдерге арналған'),
(N'Көйлек', N'Әйелдер киімі');
GO


INSERT INTO Product (
    name, description, price, size, color, quantity, category_id
)
VALUES
(N'Ақ футболка', N'Мақтадан жасалған', 5000, N'M', N'Ақ', 20, 1),
(N'Қара шалбар', N'Классикалық үлгі', 12000, N'L', N'Қара', 10, 2),
(N'Көк көйлек', N'Күнделікті киім', 15000, N'M', N'Көк', 8, 3);
GO

SELECT * FROM Client;
SELECT * FROM Staff;
SELECT * FROM Category;
SELECT * FROM Product;
SELECT * FROM Warehouse;
SELECT * FROM CartPayment;
SELECT * FROM [Order];
SELECT * FROM Delivery;




ALTER TABLE Product
ADD warehouse_id INT;


ALTER TABLE Product
ADD CONSTRAINT FK_Product_Warehouse
FOREIGN KEY (warehouse_id)
REFERENCES Warehouse(warehouse_id);
UPDATE Product
SET warehouse_id = (
    SELECT TOP 1 warehouse_id
    FROM Warehouse
    WHERE city = N'Алматы'
);

USE OnlineStore;
GO


INSERT INTO Client (name, phone, email)
VALUES
(N'Айдана Сәрсенова', N'87011111111', N'aidana@mail.kz'),
(N'Аружан Мұратова', N'87022222222', N'aruzhan@mail.kz'),
(N'Данияр Әлиев', N'87033333333', N'daniyar@mail.kz'),
(N'Мадина Қасымова', N'87044444444', N'madina@mail.kz'),
(N'Нұрсұлтан Ермеков', N'87055555555', N'nursultan@mail.kz');


INSERT INTO Staff (name, phone, role)
VALUES
(N'Әлия Нұрланова', N'87066666666', N'Admin'),
(N'Ержан Болатұлы', N'87077777777', N'Manager');


INSERT INTO CartPayment
    (client_id, total_amount, payment_method, payment_status)
VALUES
(1, 5000, N'Kaspi карта', N'Төленді'),
(2, 12000, N'Halyk карта', N'Күтілуде'),
(3, 15000, N'Kaspi карта', N'Төленді'),
(4, 10000, N'Halyk карта', N'Төленді'),
(5, 24000, N'Kaspi карта', N'Күтілуде');
GO


INSERT INTO [Order]
(
    client_id,
    staff_id,
    cart_payment_id,
    product_id,
    quantity,
    price,
    status,
    address,
    delivery_time
)
VALUES
(
    1, 2, 1, 1, 1, 5000,
    N'Жаңа',
    N'Алматы қаласы, Абай көшесі, 10',
    '2026-10-14T14:00:00'
),
(
    2, 2, 2, 2, 1, 12000,
    N'Өңделуде',
    N'Алматы қаласы, Достық көшесі, 25',
    '2026-10-14T16:00:00'
),
(
    3, 2, 3, 3, 1, 15000,
    N'Дайындалуда',
    N'Алматы қаласы, Төле би көшесі, 40',
    '2026-10-15T12:00:00'
);
GO


INSERT INTO Delivery
    (order_id, courier_name, courier_phone, delivery_status)
VALUES
(1, N'Асқар', N'87088888881', N'Дайындалуда'),
(2, N'Марат', N'87088888882', N'Курьерге берілді'),
(3, N'Әділет', N'87088888883', N'Дайындалуда');
GO




INSERT INTO Category (name, description)
VALUES
(N'Күртеше', N'Қысқы және күзгі сыртқы киім'),
(N'Юбка', N'Әйелдерге арналған юбкалар'),
(N'Аяқ киім', N'Күнделікті және классикалық аяқ киім'),
(N'Худи', N'Күнделікті спорттық киім'),
(N'Жейде', N'Ерлер мен әйелдерге арналған жейделер'),
(N'Спорттық киім', N'Спортпен айналысуға арналған киім'),
(N'Пальто', N'Суық мезгілге арналған сыртқы киім'),
(N'Свитер', N'Жылы тоқылған киім');

INSERT INTO Product
    (name, description, price, size, color, quantity, category_id)
VALUES
(N'Қара күртеше', N'Күзгі күндерге арналған', 25000, N'L', N'Қара', 12, 4),
(N'Ақ худи', N'Мақта матадан жасалған', 14000, N'M', N'Ақ', 15, 7),
(N'Көк жейде', N'Классикалық үлгі', 11000, N'L', N'Көк', 18, 8),
(N'Қара юбка', N'Күнделікті киюге арналған', 9000, N'M', N'Қара', 10, 5),
(N'Қысқы пальто', N'Жылы әрі ыңғайлы', 45000, N'L', N'Сұр', 7, 10),
(N'Спорттық костюм', N'Спортқа арналған киім', 22000, N'M', N'Қара', 14, 9),
(N'Ақ футболка Premium', N'Сапалы мақта', 7500, N'S', N'Ақ', 25, 1),
(N'Классикалық шалбар', N'Кеңсе стиліне арналған', 18000, N'L', N'Қара', 11, 2),
(N'Көк көйлек Premium', N'Жеңіл матадан тігілген', 20000, N'M', N'Көк', 9, 3);


INSERT INTO [Order]
(
    client_id,
    staff_id,
    cart_payment_id,
    product_id,
    quantity,
    price,
    status,
    address,
    delivery_time
)
VALUES
(1, 2, 1, 1, 2, 5000, N'Жаңа',
 N'Алматы қаласы, Абай көшесі, 15', '2026-10-14T10:00:00'),

(2, 2, 2, 2, 1, 12000, N'Өңделуде',
 N'Алматы қаласы, Достық көшесі, 20', '2026-10-14T14:00:00'),

(3, 2, 3, 3, 1, 15000, N'Дайындалуда',
 N'Алматы қаласы, Төле би көшесі, 30', '2026-10-15T12:00:00'),

(4, 2, 4, 4, 2, 9000, N'Жаңа',
 N'Алматы қаласы, Абылай хан көшесі, 40', '2026-10-15T16:00:00'),

(5, 2, 5, 5, 1, 24000, N'Өңделуде',
 N'Алматы қаласы, Сәтбаев көшесі, 50', '2026-10-16T11:00:00');




UPDATE Warehouse
SET
    employee_name = N'Аслан Нұрбеков',
    employee_phone = N'87012345678'
WHERE city = N'Алматы';
GO


SELECT
    o.order_id,
    c.name AS client_name,
    p.name AS product_name,
    o.price,
    cp.payment_status,
    o.status AS order_status
FROM [Order] o
JOIN Client c
    ON o.client_id = c.client_id
JOIN Product p
    ON o.product_id = p.product_id
JOIN CartPayment cp
    ON o.cart_payment_id = cp.cart_payment_id
WHERE cp.payment_status = N'Төленді'
  AND o.price BETWEEN 10000 AND 15000;


  -- 1 тексеріс
  --2 тексеріс