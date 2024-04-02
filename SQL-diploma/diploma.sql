--USE CHAINDIPLOMA;

-- CREATE DATABASE

CREATE DATABASE CHAINDIPLOMA;
GO
-------------------------------------------------------------------------------------------
CREATE SCHEMA production;      --for creating SCHEMA production
GO

CREATE SCHEMA hr;              --for creating SCHEMA hr
GO

CREATE SCHEMA sales;           --for creating SCHEMA sales
GO

-------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS production.suppliers;

-- CREATE TABLE production.suppliers

CREATE TABLE production.suppliers (
      supplierid          INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,       -- supplier ID 
      companyname         NVARCHAR(20) NOT NULL,                         -- name of company
      contactname         NVARCHAR(50) NOT NULL,                         -- contact name
      contacttitle        VARCHAR(50) NOT NULL,                          -- contact`s position
      [address]           NVARCHAR(100),                                 -- adress
      city                NVARCHAR(50) NOT NULL,                         -- city
      region              NVARCHAR(10),                                  -- region
      postalcode          INT NOT NULL,                                  -- postalcode
      country             NVARCHAR(20) NOT NULL,                         -- country
      phone               NVARCHAR(20) NOT NULL,                         -- phone
      fax                 NVARCHAR(20)                                   -- fax
      );
GO

--SELECT * FROM production.suppliers;
-------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS production.categories;

-- CREATE TABLE production.categories;  

CREATE TABLE production.categories (
      categoryid          INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,       -- category ID
      categoryname        VARCHAR(20) NOT NULL,                          -- name of category
      [description]       VARCHAR(60) NOT NULL,                          -- description of category
      );                 
GO                   
                   
--SELECT * FROM production.categories;          
                   
--------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS production.products;

-- CREATE TABLE production.products;           
                   
CREATE TABLE production.products (           
      productid           INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,       -- product ID
      productname         NVARCHAR(13) NOT NULL,                         -- name of product
      supplierid          INT NOT NULL,                                  -- supplier ID
      categoryid          INT NOT NULL,                                  -- category ID
      unitprice           NUMERIC(10,2) DEFAULT (0),                     -- price per one unit
                          CHECK (unitprice >= (0)),                      
      discontinued        INT DEFAULT (0),                               -- discontinued
      CONSTRAINT          fksupplierid 
      FOREIGN KEY         (supplierid) 
      REFERENCES          production.suppliers (supplierid),
      CONSTRAINT          fkcategoryid 
      FOREIGN KEY         (categoryid) 
      REFERENCES          production.categories (categoryid)
      );
GO

--SELECT * FROM production.products;

-------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS sales.orderdetails;

--CREATE TABLE sales.orderdetails;

CREATE TABLE sales.orderdetails (
      orderid             INT NOT NULL,                                  -- order ID
      productid           INT NOT NULL,                                  -- product ID
      unitprice           NUMERIC(10,2) DEFAULT (0),                     -- price per one unit
                          CHECK (unitprice >= (0)),
      qty                 INT DEFAULT (1),                               -- quantity of units
                          CHECK (qty >(0)),
      discount            NUMERIC(10,2) DEFAULT (0),                     -- discount 
                          CHECK (discount >= (0) 
                          AND discount <= (1)),
      PRIMARY KEY         (orderid, productid),
      CONSTRAINT          fkproductid FOREIGN KEY (productid) 
      REFERENCES          production.products(productid)
      );
GO

--SELECT * FROM sales.orderdetails;

-------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS sales.customers;

--CREATE TABLE sales.customers;

CREATE TABLE sales.customers(
      custid              INT IDENTITY(1, 1) NOT NULL PRIMARY KEY,       -- customer ID
      companyname         NVARCHAR(12) NOT NULL,                         -- name of company
      contactname         NVARCHAR(40) NOT NULL,                         -- contacts of company
      contacttitle        VARCHAR(40) NOT NULL,                          -- title of contact
      [address]           NVARCHAR(50) NOT NULL,                         -- company`s adress
      city                NVARCHAR(20) NOT NULL,                         -- city
      region              NVARCHAR(20),                                  -- region
      postalcode          INT NOT NULL,                                  -- postalcode
      country             NVARCHAR(20) NOT NULL,                         -- country
      phone               NVARCHAR(20) NOT NULL,                         -- phone
      fax                 NVARCHAR(20),                                  -- fax
      );
GO

--SELECT * FROM sales.customers
-------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS sales.shippers;

--CREATE TABLE sales.shippers;

CREATE TABLE sales.shippers (
      shipperid           INT NOT NULL PRIMARY KEY,                      -- shipper ID
      companyname         NVARCHAR(15) NOT NULL,                         -- name of company
      phone               NVARCHAR(15) NOT NULL                          -- phone
      );
GO

--SELECT * FROM sales.shippers

-------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS hr.employees;

--CREATE TABLE hr.employees;

CREATE TABLE hr.employees (
      empid               INT NOT NULL PRIMARY KEY,                      -- employee ID
      lastname            NVARCHAR(20) NOT NULL,                         -- last name of employee
      firstname           NVARCHAR(20) NOT NULL,                         -- first name of employee
      title               VARCHAR(25) NOT NULL,                          -- title of employee  
      titleofcourtesy     VARCHAR(10) NOT NULL,                          -- title of courtesy of employee
      birthdate           DATETIME,                                      -- birthdate of employee  
                          CHECK (birthdate <= GETDATE()),                          
      hiredate            DATETIME,                                      -- hiredate of employee
      [address]           NVARCHAR(50) NOT NULL,                         -- employee's residential address
      city                NVARCHAR(10) NOT NULL,                         -- employee's residential city
      region              NVARCHAR(2),                                   -- region, employee`s from
      postalcode          INT NOT NULL,                                  -- postal code
      country             NVARCHAR(20) NOT NULL,                         -- country, employee`s from
      phone               NVARCHAR(20) NOT NULL,                         -- employee`s phone number 
      mgrid               INT,                                           -- employee`s position ID
      modifieddate        DATETIME DEFAULT CURRENT_TIMESTAMP             -- modified date
      CONSTRAINT          fkmgrid FOREIGN KEY (mgrid) 
      REFERENCES          hr.employees(empid)
      );
GO

--SELECT * FROM hr.employees

-------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS sales.orders;

--CREATE TABLE sales.orders;

CREATE TABLE sales.orders (
      orderid             INT NOT NULL PRIMARY KEY,                       -- order ID
      custid              INT NOT NULL,                                   -- customer ID
      empid               INT NOT NULL,                                   -- employee ID
      orderdate           DATETIME,                                       -- order date
      requireddate        DATETIME,                                       -- required date
      shippeddate         DATETIME,                                       -- shipped date
      shipperid           INT NOT NULL,                                   -- shipper ID
      freight             NUMERIC(10,2) DEFAULT (0),                      -- freight 
      shipname            NVARCHAR(20) NOT NULL,                          -- name of ship
      shipaddress         NVARCHAR(60) NOT NULL,                          -- address of ship
      shipcity            NVARCHAR(20) NOT NULL,                          -- ship`s city  
      shipregion          NVARCHAR(20),                                   -- ship`s region
      shippostalcode      INT NOT NULL,                                   -- postal code of ship
      shipcountry         NVARCHAR(20) NOT NULL,                          -- country of ship
      CONSTRAINT          fkcustid FOREIGN KEY (custid) 
      REFERENCES          sales.customers(custid),
      CONSTRAINT          fkempid FOREIGN KEY (empid) 
      REFERENCES          hr.employees(empid),
      CONSTRAINT          fkshipperid FOREIGN KEY (shipperid) 
      REFERENCES          sales.shippers (shipperid)
      );
GO

--SELECT * FROM sales.orders;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--ALTER TABLE sales.orderdetails;

ALTER TABLE sales.orderdetails
      ADD CONSTRAINT fkorderid2
      FOREIGN KEY (orderid) 
      REFERENCES sales.orders(orderid);
GO

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT production.suppliers

INSERT INTO production.suppliers (companyname, contactname, contacttitle, [address], city, region, postalcode, country, phone, fax)
       VALUES (N'Поставщик SWRXU', N'Adolphi,Stephan', 'Purchasing Manager', N'2345 Gilbert St.', N'Лондон', NULL, 10023, N'Великобритания', N'(171) 456-7890', NULL),
              (N'Поставщик VHQZD', N'Hance,Jim', 'Order Administrator', N'P.O. Box 5678', N'Новый Орлеан', 'LA', 10013, N'США', N'(100) 555-0111', NULL),
              (N'Поставщик STUAZ', N'Parovszky, Alfons', 'Sales Representative', N'1234 Oxford Rd.', N'Энн-Арбор', 'MI', 10026, N'США', N'(313) 555-0109', N'(313) 555-0112'),
              (N'Поставщик QOVFD', N'Balázs, Erzsébet', 'Marketing Manager', N'7890 Sekimai MСШАshino-shi', N'Токио', NULL, 10011, N'Япония', N'(03) 6789-0123', NULL),
              (N'Поставщик EQPNC', N'Holm, Michael', 'Export Administrator', N'Calle del Rosal 4567', N'Овьедо', N'Астурия', 10029, N'Испания', N'(98) 123 45 67', NULL),
              (N'Поставщик QWUSF', N'Popkova, Darya', 'Marketing Representative', N'8901 Setsuko Chuo-ku', N'Осака', NULL, 10028, N'Япония', N'(06) 789-0123', NULL),
              (N'Поставщик GQRCV', N'Ræbild, Jesper', 'Marketing Manager', N'5678 Rose St. Moonie Ponds', N'Мельбурн', N'Виктория', 10018, N'Австралия', N'(03) 123-4567', N'(03) 456-7890'),
              (N'Поставщик BWGYE', N'Iallo, Lucio', 'Sales Representative', N'9012 King`s Way', N'Манчестер', NULL, 10021, N'Великобритания', N'(161) 567-8901', NULL),
              (N'Поставщик QQYEU', N'Basalik, Evan', 'Sales Agent', N'Kaloadagatan 4567', N'Гетеборг', NULL, 10022, N'Швеция', N'031-345 67 89', N'031-678 90 12'),
              (N'Поставщик UNAHG', N'Barnett, Dave', 'Marketing Manager', N'Av. das Americanas 2345', N'Сан-Паулу', NULL, 10034, N'Бразилия', N'(11) 345 6789', NULL),
              (N'Поставщик ZPYVS', N'Jain, Mukesh', 'Sales Manager', N'Tiergartenstraße 3456', N'Берлин', NULL, 10016, N'Германия', N'(010) 3456789', NULL),
              (N'Поставщик SVIYA', N'Regev, Barak', 'International Marketing Mgr.', N'Bogenallee 9012', N'Франкфурт', NULL, 10024, N'Германия', N'(069) 234567', NULL),
              (N'Поставщик TEGSC', N'Brehm, Peter', 'Coordinator Foreign Markets', N'Frahmredder 3456', N'Куксхафен', NULL, 10019, N'Германия', N'(04721) 1234', N'(04721) 2345'),
              (N'Поставщик KEREV', N'Keil, Kendall', 'Sales Representative', N'Viale Dante, 6789', N'Равенна', NULL, 10015, N'Италия', N'(0544) 56789', N'(0544) 34567'),
              (N'Поставщик NZLIF', N'Sałas-Szlejter, Karolina', 'Marketing Manager', N'Hatlevegen 1234', N'Сандвика', NULL, 10025, N'Норвегия', N'(0)9-012345', NULL),
              (N'Поставщик UHZRG', N'Scholl, Thorsten', 'Regional Account Rep.', N'8901 - 8th Avenue Suite 210', N'Бенд', 'OR', 10035, N'США', N'(503) 555-0108', NULL),
              (N'Поставщик QZGUF', N'Kleinerman, Christian', 'Sales Representative', N'Brovallavägen 0123', N'Стокгольм', NULL, 10033, N'Швеция', N'08-234 56 78', NULL),
              (N'Поставщик LVJUA', N'Canel, Fabrice','Sales Manager', N'3456, Rue des Francs-Bourgeois', N'Париж', NULL, 10031, N'Франция', N'(1) 90.12.34.56', N'(1) 01.23.45.67'),
              (N'Поставщик JDNUG', N'Chapman, Greg', 'Wholesale Account Agent', N'Order Processing Dept. 7890 Paul Revere Blvd.', N'Бостон', 'MA', 10027, N'США', N'(617) 555-0110', N'(617) 555-0113'),
              (N'Поставщик CIYNM', N'Köszegi, Emília', 'Owner', N'6789 Serangoon Loop, Suite #402', N'Сингапур', NULL, 10037, N'Сингапур', N'012-3456', NULL),
              (N'Поставщик XOXZA', N'Shakespear, Paul', 'Sales Manager', N'Lyngbysild Fiskebakken 9012', N'Лингби', NULL, 10012, N'Дания', N'67890123', N'78901234'),
              (N'Поставщик FNUXM', N'Skelly, Bonnie L.', 'Accounting Manager', N'Verkoop Rijnweg 8901', N'Зандам', NULL, 10014, N'Нидерланды', N'(12345) 8901', N'(12345) 5678'),
              (N'Поставщик ELCRN', N'LaMee, Brian', 'Менеджер по продукту', N'Valtakatu 1234', N'Лаппеэнранта', NULL, 10032, N'Финляндия', N'(953) 78901', NULL),
              (N'Поставщик JNNES', N'Clark, Molly', 'Sales Representative', N'6789 Prince Edward Parade Hunter`s Hill', N'Сидней', N'NSW', 10030, N'Австралия', N'(02) 234-5678', N'(02) 567-8901'),
              (N'Поставщик ERVYZ', N'Sprenger, Christof', 'Marketing Manager', N'7890 Rue St. Laurent', N'Монреаль', N'Квебек', 10017, N'Канада', N'(514) 456-7890', NULL),
              (N'Поставщик ZWZDM', N'Cunha, Gonçalo', 'Order Administrator', N'Via dei Gelsomini, 5678', N'Салерно', NULL, 10020, N'Италия', N'(089) 4567890', N'(089) 4567890'),
              (N'Поставщик ZRYDZ', N'Leoni, Alessandro', 'Sales Manager', N'4567, rue H. Voiron', N'Монсо', NULL, 10036, N'Франция', N'89.01.23.45', NULL),
              (N'Поставщик OAVQT', N'Teper, Jeff', 'Sales Representative', N'Bat. B 2345, rue des Alpes', N'Анси', NULL, 10010, N'Франция', N'01.23.45.67', N'89.01.23.45'),
              (N'Поставщик OGLRK', N'Walters, Rob', 'Accounting Manager', N'0123 rue Chasseur', N'Сент-Иасент', N'Квебек', 10009, N'Канада', N'(514) 567-890', N'(514) 678-9012');
GO
--SELECT * FROM production.suppliers;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT production.categories

INSERT INTO production.categories (categoryname, [description])
       VALUES ('Beverages', 'Soft drinks, coffees, teas, beers, and ales'),
              ('Condiments', 'Sweet and savory sauces, relishes, spreads, and seasonings'),
              ('Confections', 'Desserts, candies, and sweet breads'),
              ('Dairy Products', 'Cheeses'),
              ('Grains/Cereals', 'Breads, crackers, pasta, and cereal'),
              ('Meat/Poultry', 'Prepared meats'),
              ('Produce', 'Dried fruit and bean curd'),
              ('Seafood', 'Seaweed and fish');
GO
--SELECT * FROM production.categories;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT production.products

INSERT INTO production.products (productname, supplierid, categoryid, unitprice, discontinued)
       VALUES (N'Продукт HHYDP', 1, 1, 18, 0),
              (N'Продукт RECZE', 1, 1, 19, 0),
              (N'Продукт IMEHJ', 1, 2, 10, 0),
              (N'Продукт KSBRM', 2, 2, 22, 0),
              (N'Продукт EPEIM', 2, 2, 21.35, 1),
              (N'Продукт VAIIV', 3, 2, 25, 0),
              (N'Продукт HMLNI', 3, 7, 30, 0),
              (N'Продукт WVJFP', 3, 2, 40, 0),
              (N'Продукт AOZBW', 4, 6, 97, 1),
              (N'Продукт YHXGE', 4, 8, 31, 0),
              (N'Продукт QMVUN', 5, 4, 21, 0),
              (N'Продукт OSFNS', 5, 4, 38, 0),
              (N'Продукт POXFU', 6, 8, 6, 0),
              (N'Продукт PWCJB', 6, 7, 23.25, 0),
              (N'Продукт KSZOI', 6, 2, 15.5, 0),
              (N'Продукт PAFRH', 7, 3, 17.45, 0),
              (N'Продукт BLCAX', 7, 6, 39, 1),
              (N'Продукт CKEDC', 7, 8, 62.5, 0),
              (N'Продукт XKXDO', 8, 3, 9.2, 0),
              (N'Продукт QHFFP', 8, 3, 81, 0),
              (N'Продукт VJZZH', 8, 3, 10, 0),
              (N'Продукт CPHFY', 9, 5, 21, 0),
              (N'Продукт JLUDZ', 9, 5, 9, 0),
              (N'Продукт QOGNU', 10, 1, 4.5, 1),
              (N'Продукт LYLNI', 11, 3, 14, 0),
              (N'Продукт HLGZA', 11, 3, 31.23, 0),
              (N'Продукт SMIOH', 11, 3, 43.9, 0),
              (N'Продукт OFBNT', 12, 7, 45.6, 1),
              (N'Продукт VJXYN', 12, 6, 123.79, 1),
              (N'Продукт LYERX', 13, 8, 25.89, 0),
              (N'Продукт XWOXC', 14, 4, 12.5, 0),
              (N'Продукт NUNAW', 14, 4, 32, 0),
              (N'Продукт ASTMN', 15, 4, 2.5, 0),
              (N'Продукт SWNJY', 16, 1, 14, 0),
              (N'Продукт NEVTJ', 16, 1, 18, 0),
              (N'Продукт GMKIJ', 17, 8, 19, 0),
              (N'Продукт EVFFA', 17, 8, 26, 0),
              (N'Продукт QDOMO', 18, 1, 263.5, 0),
              (N'Продукт LSOFL', 18, 1, 18, 0),
              (N'Продукт YZIXQ', 19, 8, 18.4, 0),
              (N'Продукт TTEEX', 19, 8, 9.65, 0),
              (N'Продукт RJVNM', 20, 5, 14, 1),
              (N'Продукт ZZZHR', 20, 1, 46, 0),
              (N'Продукт VJIEO', 20, 2, 19.45, 0),
              (N'Продукт AQOKR', 21, 8, 9.5, 0),
              (N'Продукт CBRRL', 21, 8, 12, 0),
              (N'Продукт EZZPR', 22, 3, 9.5, 0),
              (N'Продукт MYNXN', 22, 3, 12.75, 0),
              (N'Продукт FPYPN', 23, 3, 20, 0),
              (N'Продукт BIUDV', 23, 3, 16.25, 0),
              (N'Продукт APITJ', 24, 7, 53, 0),
              (N'Продукт QSRXF', 24, 5, 7, 0),
              (N'Продукт BKGEA', 24, 6, 32.8, 1),
              (N'Продукт QAQRL', 25, 6, 7.45, 0),
              (N'Продукт YYWRT', 25, 6, 24, 0),
              (N'Продукт VKCMF', 26, 5, 38, 0),
              (N'Продукт OVLQI', 26, 5, 19.5, 0),
              (N'Продукт ACRVI', 27, 8, 13.25, 0),
              (N'Продукт UKXRI', 28, 4, 55, 0),
              (N'Продукт WHBYK', 28, 4, 34, 0),
              (N'Продукт XYZPE', 29, 2, 28.5, 0),
              (N'Продукт WUXYK', 29, 3, 49.3, 0),
              (N'Продукт ICKNK', 7, 2, 43.9, 0),
              (N'Продукт HCQDE', 12, 5, 33.25, 0),
              (N'Продукт XYWBZ', 2, 2, 21.05, 0),
              (N'Продукт LQMGN', 2, 2, 17, 0),
              (N'Продукт XLXQF', 16, 1, 14,0),
              (N'Продукт TBTBL', 8, 3, 12.5,0),
              (N'Продукт COAXA', 15, 4, 36, 0),
              (N'Продукт TOONT', 7, 1, 15, 0),
              (N'Продукт MYMOI', 15, 4, 21.5, 0),
              (N'Продукт GEEOO', 14, 4, 34.8, 0),
              (N'Продукт WEUJZ', 17, 8, 15, 0),
              (N'Продукт BKAZJ', 4, 7, 10, 0),
              (N'Продукт BWRLG', 12, 1, 7.75, 0),
              (N'Продукт JYGFE', 23, 1, 18, 0),
              (N'Продукт LUNZZ', 12, 2, 13, 0);
GO

--SELECT * FROM production.products;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT sales.customers;

INSERT INTO sales.customers (companyname, contactname, contacttitle, [address], city, region, postalcode, country, phone, fax)
       VALUES (N'Клиент NRZBB', N'Allen, Michael', 'Sales Representative', N'Obere Str. 0123', N'Берлин', NULL, 10092, N'Германия', N'030-3456789', N'030-0123456'), 
              (N'Клиент MLTDN', N'Hassall, Mark', 'Owner', N'Avda. de la Constitución 5678', N'Мехико', NULL, 10077, N'Мексика', N'(5) 789-0123', N'(5) 456-7890'), 
              (N'Клиент KBUDE', N'Peoples, John', 'Owner', N'Mataderos  7890', N'Мехико', NULL, 10097, N'Мексика', N'(5) 123-4567', NULL),
              (N'Клиент HFBZG', N'Arndt, Torsten', 'Sales Representative', N'7890 Hanover Sq.', N'Лондон', NULL, 10046, N'Великобритания', N'(171) 456-7890', N'(171) 456-7891'), 
              (N'Клиент HGVLZ', N'Higginbotham, Tom', 'Order Administrator', N'Berguvsvägen  5678', N'Лулео', NULL, 10112, N'Швеция', N'0921-67 89 01', N'0921-23 45 67'), 
              (N'Клиент XHXJV', N'Польша, Carole', 'Sales Representative', N'Forsterstr. 7890', N'Мангейм', NULL, 10117, N'Германия', N'0621-67890', N'0621-12345'), 
              (N'Клиент QXVLA', N'Bansal, Dushyant', 'Marketing Manager', N'2345, place Kléber', N'Страсбург', NULL, 10089, N'Франция', N'67.89.01.23', N'67.89.01.24'), 
              (N'Клиент QUHWH', N'Ilyina, Julia', 'Owner', N'C/ Araquil, 0123', N'Мадрид', NULL, 10104, N'Испания', N'(91) 345 67 89', N'(91) 012 34 56)'), 
              (N'Клиент RTXGC', N'Raghav, Amritansh', 'Owner', N'6789, rue des Bouchers', N'Марсель', NULL, 10105, N'Франция', N'23.45.67.89', N'23.45.67.80'), 
              (N'Клиент EEALV', N'Bassols, Pilar Colome', 'Accounting Manager', N'8901 Тсаввассен Blvd.', N'Тсаввассен', 'BC', 10111, N'Канада', N'(604) 901-2345', N'(604) 678-9012)'), 
              (N'Клиент UBHAU', N'Jaffe, David', 'Sales Representative', N'Fauntleroy Circus 4567', N'Лондон', NULL, 10064, N'Великобритания', N'(171) 789-0123', NULL), 
              (N'Клиент PSNMQ', N'Ray, Mike', 'Sales Agent', N'Cerrito 3456', N'Буэнос-Айрес', NULL, 10057, N'Аргентина', N'(1) 890-1234', N'(1) 567-8901'),
              (N'Клиент VMLOG', N'Benito, Almudena', 'Marketing Manager', N'Sierras de Granada 7890', N'Мехико', NULL, 10056, N'Мексика', N'(5) 456-7890', N'(5) 123-4567'), 
              (N'Клиент WNMAF', N'Jelitto, Jacek', 'Owner', N'Hauptstr. 0123', N'Берн', NULL, 10065, N'Швейцария', N'0452-678901', NULL), 
              (N'Клиент JUWXK', N'Richardson, Shawn', 'Sales Associate', N'Av. dos Lusíadas, 6789', N'Сан-Паулу', 'SP', 10087, N'Бразилия', N'(11) 012-3456', NULL), 
              (N'Клиент GYBBY', N'Birkby, Dana', 'Sales Representative', N'Berkeley Gardens 0123 Brewery', N'Лондон', NULL, 10039, N'Великобритания', N'(171) 234-5678', N'(171) 234-5679)'), 
              (N'Клиент FEVNN', N'Jones, TiAnna', 'Order Administrator', N'Walserweg 4567', N'Ахен', NULL, 10067, N'Германия', N'0241-789012', N'0241-345678'), 
              (N'Клиент BSVAR', N'Rizaldy, Arif', 'Owner', N'3456, rue des Cinquante Otages', N'Нант', NULL, 10041, N'Франция', N'89.01.23.45', N'89.01.23.46'), 
              (N'Клиент RFNQC', N'Boseman, Randall', 'Sales Agent', N'5678 King George', N'Лондон', NULL, 10110, N'Великобритания', N'(171) 345-6789', N'(171) 345-6780'), 
              (N'Клиент THHDP', N'Kane, John', 'Sales Manager', N'Kirchgasse 9012', N'Грац', NULL, 10059, N'Австрия', N'1234-5678', N'9012-3456');
GO 

--SELECT * FROM sales.customers;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT sales.shippers;

INSERT INTO sales.shippers (shipperid, companyname, phone)
       VALUES (1, N'Shipper GVSUA', N'(503) 555-0137'), 
              (2, N'Shipper ETYNR', N'(425) 555-0136'),
              (3, N'Shipper ZHISN', N'(415) 555-0138');
GO
--SELECT * FROM sales.shippers;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--INSERT hr.employees;

INSERT INTO hr.employees (empid, lastname, firstname, title, titleofcourtesy, birthdate, hiredate, [address], city, region, postalcode, country, phone, mgrid)
       VALUES (1, N'Дэвис', N'Сара', 'CEO', 'мисс', '1958-12-08', '2002-05-01', N'7890 - 20th Ave. E., Apt. 2A', N'Сиэтл', 'WA', 10003, N'США', N'(206) 555-0101', NULL),
              (2, N'Функ', N'Дон', 'Vice President, Sales', 'доктор', '1962-02-19', '2002-08-14', N'9012 W. Capital Way', N'Такома', 'WA', 10001, N'США', N'(206) 555-0100', 1),
              (3, N'Лью', N'Джуди', 'Sales Manager', 'мисс', '1973-08-30', '2002-04-01', N'2345 Moss Bay Blvd.', N'Киркланд', 'WA', 10007, N'США', N'(206) 555-0103', 2),
              (4, N'Пелед', N'Иаиль', 'Sales Representative', 'миссис', '1947-09-19', '2003-05-03', N'5678 Old Redmond Rd.', N'Редмонд', 'WA', 10009, N'США', N'(206) 555-0104', 3),
              (5, N'Бак', N'Свен', 'Sales Manager', 'мистер', '1965-03-04', '2003-10-17', N'8901 Garrett Hill', N'Лондон', NULL, 10004, N'Великобритания', N'(71) 234-5678', 2),
              (6, N'Суурс', N'Пол', 'Sales Representative', 'мистер', '1973-07-02', '2003-10-17', N'3456 Coventry House, Miner Rd.', N'Лондон', NULL, 10005, N'Великобритания', N'(71) 345-6789', 5),
              (7, N'Кинг', N'Рассел', 'Sales Representative', 'мистер', '1970-05-29', '2004-01-02', N'6789 Edgeham Hollow, Winchester Way', N'Лондон', NULL, 10002, N'Великобритания', N'(71) 123-4567', 5),
              (8, N'Камерон', N'Мария', 'Sales Representative', 'мисс', '1968-01-09', '2004-03-05', N'4567 - 11th Ave. N.E.', N'Сиэтл', 'WA', 10006, N'США', N'(206) 555-0102', 3),
              (9, N'Долгопятова', N'Зоя', 'Sales Representative', 'мисс', '1976-01-27', '2004-11-15', N'1234 Houndstooth Rd.', N'Лондон', NULL, 10008, N'Великобритания', N'(71) 456-7890', 5);

--SELECT * FROM hr.employees;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT sales.orders;

INSERT INTO sales.orders (orderid, custid, empid, orderdate, requireddate, shippeddate, shipperid, freight, shipname, shipaddress, shipcity, shipregion, shippostalcode, shipcountry)
       VALUES (10248, 4, 5, '2006-07-04', '2006-08-01', '2006-07-16', 3, 32.38, N'Ship to 85-B', N'6789 rue de l`Abbaye', N'Reims', NULL, 10345, N'Франция'),
              (10249, 16, 6, '2006-07-05', '2006-08-16', '2006-07-10', 1, 11.61, N'Ship to 79-C', N'Luisenstr. 9012', N'Münster', NULL, 10328, N'Германия'),
              (10250, 15, 4, '2006-07-08', '2006-08-05', '2006-07-12', 2, 65.83, N'Destination SCQXA', N'Rua do Paço, 7890', N'Рио-де-Жанейро', 'RJ', 10195, N'Бразилия'),
              (10251, 19, 3, '2006-07-08', '2006-08-05', '2006-07-15', 1, 41.34, N'Ship to 84-A', N'3456, rue du Commerce', N'Lyon', NULL, 10342, N'Франция'),
              (10252, 14, 4, '2006-07-09', '2006-08-06', '2006-07-11', 2, 51.3, N'Ship to 76-B', N'Boulevard Tirou, 9012', N'Шарлеруа', NULL, 10318, N'Бельгия'),
              (10253, 5, 3, '2006-07-10', '2006-07-24', '2006-07-16', 2, 58.17, N'Destination JPAIY', N'Rua do Paço, 8901', N'Рио-де-Жанейро', 'RJ', 10196, N'Бразилия'),
              (10254, 2, 5, '2006-07-11', '2006-08-08', '2006-07-23', 2, 22.98, N'Destination YUJRD', N'Hauptstr. 1234', N'Берн', NULL, 10139, N'Швейцария'),
              (10255, 12, 9, '2006-07-12', '2006-08-09', '2006-07-15', 3, 148.33, N'Ship to 68-A', N'Starenweg 6789', N'Женева', NULL, 10294, N'Швейцария'),
              (10256, 8, 3, '2006-07-15', '2006-08-12', '2006-07-17', 2, 13.97, N'Ship to 88-B', N'Rua do Mercado, 5678', N'Резенди', 'SP', 10354, N'Бразилия'),
              (10257, 13, 4, '2006-07-16', '2006-08-13', '2006-07-22', 3, 81.91, N'Destination JYDLM', N'Carrera1234 con Ave. Carlos Soublette #8-35', N'Сан-Кристобаль', N'Тачира', 10199, 'Венесуэла'),
              (10258, 1, 1, '2006-07-17', '2006-08-14', '2006-07-23', 1, 140.51, N'Destination RVDMF', N'Kirchgasse 9012', N'Грац', NULL, 10157, N'Австрия'),
              (10259, 11, 4, '2006-07-18', '2006-08-15', '2006-07-25', 3, 3.25, N'Destination LGGCH', N'Sierras de Granada 9012', N'Мехико', NULL, 10137, N'Мексика'),
              (10260, 7, 4, '2006-07-19', '2006-08-16', '2006-07-29', 1, 55.09, N'Ship to 56-A', N'Mehrheimerstr. 0123', N'Köln', NULL, 10258, N'Германия'),
              (10261, 18, 4, '2006-07-19', '2006-08-16', '2006-07-30', 2, 3.05, N'Ship to 61-B', N'Rua da Panificadora, 6789', N'Рио-де-Жанейро', 'RJ', 10274, N'Бразилия'),
              (10262, 9, 8, '2006-07-22', '2006-08-19', '2006-07-25', 3, 48.29, N'Ship to 65-B', N'8901 Milton Dr.', N'Альбукерке', 'NM', 10286, N'США'),
              (10263, 20, 9, '2006-07-23', '2006-08-20', '2006-07-31', 3, 146.06, N'Destination FFXKT', N'Kirchgasse 0123', N'Грац', NULL, 10158, N'Австрия'),
              (10264, 17, 6, '2006-07-24', '2006-08-21', '2006-08-23', 3, 3.67, N'Destination KBSBN', N'Åkergatan 9012', N'Брацке', NULL, 10167, N'Швеция'),
              (10265, 7, 2,  '2006-07-25', '2006-08-22', '2006-08-12', 1, 55.28, N'Ship to 7-A', N'0123, place Kléber', N'Страсбург', NULL, 10329, N'Франция'),
              (10266, 6, 3, '2006-07-26', '2006-09-06', '2006-07-31', 3, 25.73, N'Ship to 87-B', N'Torikatu 2345', N'Оулу', NULL, 10351, N'Финляндия'),
              (10283, 10, 3, '2006-08-16', '2006-09-13', '2006-08-23', 3, 84.81, N'Ship to 46-A', N'Carrera 0123 con Ave. Bolívar #65-98 Llano Largo', N'Баркисимето', N'Лара', 10227, N'Венесуэла'),
              (10289, 11, 7, '2006-08-26', '2006-09-23', '2006-08-28', 3, 22.77, N'Destination DLEUN', N'Fauntleroy Circus 4567', N'Лондон',  NULL, 10132, N'Великобритания'),
              (10303, 20, 7, '2006-09-11', '2006-10-09', '2006-09-18', 2, 107.83, N'Destination IIYDD', N'C/ Romero 5678', N'Sevilla', NULL, 10183, N'Испания'),
              (10308, 2, 7, '2006-09-18',' 2006-10-16',' 2006-09-24', 3, 1.61, N'Destination QMVCI', N'Avda. de la Constitución 2345', N'Мехико', NULL, 10180, N'Мексика'),
              (10319, 19, 7, '2006-10-02', '2006-10-30', '2006-10-11', 3, 64.5, N'Ship to 80-B', N'Avda. Azteca 4567', N'Мехико', NULL, 10333, N'Мексика'),
              (10393, 11, 1, '2006-12-25', '2007-01-22', '2007-01-03', 3, 126.56, N'Ship to 71-B', N'8901 Suffolk Ln.', N'Бойсе', 'ID', 10306, N'США'),
              (10394, 13, 1, '2006-12-25', '2007-01-22', '2007-01-03', 3, 30.34, N'Destination AWPJG', N'City Center Plaza 2345 Main St.', N'Элджин', 'OR', 10200, N'США'),
              (10556, 16, 2, '2007-06-03', '2007-07-15', '2007-06-13', 1, 9.8, N'Ship to 73-A', N'Vinbæltet 1234', N'Kobenhavn', NULL, 10310, N'Дания'),
              (10561, 5, 2, '2007-06-06', '2007-07-04', '2007-06-09', 2, 242.21, N'Destination YCMPK', N'Åkergatan 8901', N'Брацке', NULL, 10166, N'Швеция'),
              (10369, 2, 8, '2006-12-02', '2006-12-30', '2006-12-09', 2, 195.68, N'Ship to 75-C', N'P.O. Box 7890', N'Ландер', 'WY', 10316, N'США'),
              (10380, 8, 8, '2006-12-12', '2007-01-09', '2007-01-16', 3, 35.03, N'Destination KPVYJ', N'5678 Johnstown Road', N'Корк', N'Графство Корк', 10203, N'Ирландия'),
              (10383, 4, 8, '2006-12-16', '2007-01-13', '2006-12-18', 3, 34.24, N'Ship to 4-B', N'Brook Farm Stratford St. Mary 1234', N'Colchester', N'Essex', 10239, N'Великобритания');

--SELECT * FROM sales.orders;
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--INSERT sales.orderdetails;

INSERT INTO sales.orderdetails (orderid, productid, unitprice, qty, discount)
       VALUES (10248, 11, 14, 12, 0),
              (10248, 42, 9.8, 10, 0),
              (10248, 72, 34.8, 5, 0),
              (10249, 14, 18.6, 9, 0),
              (10249, 51, 42.4, 40, 0),
              (10250, 41, 7.7, 10, 0),
              (10250, 51, 42.4, 35, 0.15),
              (10250, 65, 16.8, 15, 0.15),
              (10251, 22, 16.8, 6, 0.05),
              (10251, 57, 15.6, 15, 0.05),
              (10251, 65, 16.8, 20, 0),
              (10252, 20, 64.8, 40, 0.05),
              (10252, 33, 2, 25, 0.05),
              (10252, 60, 27.2, 40, 0),
              (10253, 31, 10, 20, 0),
              (10253, 39, 14.4, 42, 0),
              (10253, 49, 16, 40, 0),
              (10254, 24, 3.6, 15, 0.15),
              (10254, 55, 19.2, 21, 0.15),
              (10254, 74, 8, 21, 0),
              (10255, 2, 15.2, 20, 0),
              (10255, 16, 13.9, 35, 0),
              (10255, 36, 15.2, 25, 0),
              (10255, 59, 44, 30, 0),
              (10256, 53, 26.2, 15, 0),
              (10256, 77, 10.4, 12, 0),
              (10257, 27, 35.1, 25, 0),
              (10257, 39, 14.4, 6, 0),
              (10257, 77, 10.4, 15, 0),
              (10258, 2, 15.2, 50, 0.2),
              (10258, 5, 17, 65, 0.2),
              (10258, 32, 25.6, 6, 0.2),
              (10259, 21, 8, 10, 0),
              (10259, 37, 20.8, 1, 0),
              (10260, 41, 7.7, 16, 0.25),
              (10260, 57, 15.6, 50, 0),
              (10260, 62, 39.4, 15, 0.25),
              (10260, 70, 12, 21, 0.25),
              (10261, 21, 8, 20, 0),
              (10261, 35, 14.4, 20, 0),
              (10262, 5, 7, 12, 0.2),
              (10262, 7, 4, 15, 0),
              (10262, 56, 30.4, 2, 0),
              (10263, 16, 13.9, 60, 0.25),
              (10263, 24, 3.6, 28, 0),
              (10263, 30, 20.7, 60, 0.25),
              (10263, 74, 8, 36, 0.25),
              (10264, 2, 15.2, 35, 0),
              (10264, 41, 7.7, 25, 0.15),
              (10265, 17, 31.2, 30, 0),
              (10265, 70, 12, 20, 0),
              (10266, 12, 30.4, 12, 0.05),
              (10283, 15, 12.4, 20, 0),
              (10283, 19, 7.3, 18, 0),
              (10283, 60, 27.2, 35, 0),
              (10283, 72, 27.8, 3, 0),
              (10289, 3, 8, 30, 0),
              (10289, 64, 26.6, 9, 0),
              (10303, 40, 14.7, 40, 0.1),
              (10303, 65, 16.8, 30, 0.1),
              (10303, 68, 10, 15, 0.1),
              (10308, 69, 28.8, 1, 0),
              (10308, 70, 12, 5, 0),
              (10319, 17, 31.2, 8, 0),
              (10319, 28, 36.4, 14, 0),
              (10319, 76, 14.4, 30, 0),
              (10369, 29, 99, 20, 0),
              (10369, 56, 30.4, 18, 0.25),
              (10380, 30, 20.7, 18, 0.1),
              (10380, 53, 26.2, 20, 0.1),
              (10380, 60, 27.2, 6, 0.1),
              (10380, 70, 12, 30, 0),
              (10383, 13, 4.8, 20, 0),
              (10383, 50, 13, 15, 0),
              (10383, 56, 30.4, 20, 0),
              (10393, 2, 15.2, 25, 0.25),
              (10393, 14, 18.6, 42, 0.25),
              (10393, 25, 11.2, 7, 0.25),
              (10393, 26, 24.9, 70, 0.25),
              (10393, 31, 10, 32, 0), 
              (10394, 13, 4.8, 10, 0), 
              (10394, 62, 39.4, 10, 0),
              (10556, 72, 34.8, 24, 0), 
              (10561, 44, 19.45, 10, 0),
              (10561, 51, 53, 50, 0);

GO
--SELECT * FROM sales.orderdetails;
-------------------------------------------------------------------------------------
-- Remove a procedure with such a name if it exists

DROP PROCEDURE IF EXISTS add_new_employee;
GO

--__________________________________The header of a procedure__________________________________

-- Create a procedure with such a name

CREATE PROCEDURE add_new_employee
    @empid               INT,                  -- employee ID
    @lastname            NVARCHAR(20),         -- last name of employee
    @firstname           NVARCHAR(20),         -- first name of employee
    @title               VARCHAR(25),          -- title of employee             
    @titleofcourtesy     VARCHAR(10),          -- title of courtesy of employee      
    @birthdate           DATETIME,             -- birthdate of employee           
    @hiredate            DATETIME,             -- hiredate of employee
    @empaddress          NVARCHAR(50),         -- employee's residential address      
    @city                NVARCHAR(10),         -- employee's residential city    
    @region              NVARCHAR(2),          -- region, employee`s from              
    @postalcode          INT,                  -- postal code    
    @country             NVARCHAR(20),         -- country, employee`s from       
    @phone               NVARCHAR(20),         -- employee`s phone number     
    @mgrid               INT                   -- employee`s position ID

AS
BEGIN
--_________________________________The body of a procedure_____________________________________

    SET NOCOUNT ON;

    WITH [src] (empid, lastname, firstname, title, titleofcourtesy, birthdate, hiredate, [address], city, region,
                postalcode,country, phone, mgrid) AS 
    (
     SELECT     @empid, @lastname, @firstname, @title, @titleofcourtesy,
                @birthdate, @hiredate, @empaddress, @city, @region,
                @postalcode, @country, @phone, @mgrid
    )
    MERGE hr.employees AS [merging] 
    USING [src] ON [merging].empid = [src].empid

    WHEN MATCHED THEN

        UPDATE SET [merging].empid=@empid,[merging].lastname = @lastname, [merging].firstname = @firstname, [merging].title = @title, [merging].titleofcourtesy = @titleofcourtesy,
                   [merging].birthdate = @birthdate, [merging].hiredate = @hiredate, [merging].[address] = @empaddress, [merging].city = @city, 
                   [merging].region = @region, [merging].postalcode = @postalcode,
                   [merging].country = @country, [merging].phone = @phone, [merging].mgrid = @mgrid, modifieddate = CURRENT_TIMESTAMP

    WHEN NOT MATCHED THEN

        INSERT     (empid, lastname, firstname, title, titleofcourtesy, birthdate, hiredate, [address], city, region, postalcode,
                    country, phone, mgrid) 
        VALUES     (@empid, @lastname, @firstname, @title, @titleofcourtesy,
                    @birthdate, @hiredate, @empaddress, @city, @region, @postalcode,
                    @country, @phone, @mgrid);
        END
GO

        EXEC add_new_employee      @empid= 10,@lastname=N'Пиллс', @firstname=N'Дэймон', @title='Sales Representative', @titleofcourtesy='мистер', @birthdate='1999-11-04', 
                                   @hiredate='2005-02-01', @empaddress=N'Luisenstr. 0123', @city=N'Сиэтл', @region='WA', @postalcode=10010, @country=N'США', @phone=N'(206) 555-0108', 
                                   @mgrid=3;

--SELECT * FROM hr.employees;
-------------------------------------------------------------------------------------

-- Remove a trigger with such a name if it exists
DROP TRIGGER IF EXISTS check_employees_number;
GO

--__________________________________The header of a trigger__________________________________

-- Create a trigger with such a name

CREATE TRIGGER check_employees_number ON hr.employees
 AFTER INSERT AS

--__________________________________The body of a trigger__________________________________
 BEGIN
  
  SET NOCOUNT ON;
  
  -- Determines if a employees number exceeds
  DECLARE @flag_if_exceed INT;

  -- Calculate if a employees number exceeds
  SELECT @flag_if_exceed = IIF(s.total_empid > 10, 1, 0)
  FROM (SELECT COUNT(d.empid) total_empid
        FROM hr.employees d) s

  -- Understanding the inserted and deleted tables
  -- inserted - technical table that exists within a trigger only
  -- deleted - technical table that exists within a trigger only

  -- Rollback the transaction if a employees number exceeds
  IF @flag_if_exceed = 1
  BEGIN

   RAISERROR('Trigger check_employees_number transaction failed', 0, 0) WITH NOWAIT;
   ROLLBACK TRANSACTION;
  
  END
 
 END;
GO

--Try to add more than 10 employees number
/*EXEC add_new_employee @empid= 11,@lastname=N'Пиллс', @firstname=N'Дэймон', @title='Sales Representative', @titleofcourtesy='мистер', @birthdate='1999-11-04', 
                        @hiredate='2005-02-01', @empaddress=N'Luisenstr. 0123', @city=N'Сиэтл', @region='WA', @postalcode=10010, @country=N'США', @phone=N'(206) 555-0108', 
                        @mgrid=3;*/

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Remove a view with such a name if it exists
DROP VIEW IF EXISTS vw_usa_employees_sales;
GO

--Create view for employees from USA
CREATE VIEW vw_usa_employees_sales
 AS
  SELECT a.empid,
               a.[firstname],
               a.[lastname],
               COUNT(b.orderid) AS total_orders,
               SUM((c.unitprice-(c.unitprice*c.discount))*c.qty) AS total_sales,
               SUM(c.qty) AS total_qty
FROM hr.employees a
LEFT JOIN sales.orders b ON b.empid=a.empid
LEFT JOIN sales.orderdetails c ON c.orderid=b.orderid
WHERE a.country = 'США'
GROUP BY a.empid, a.[firstname], a.[lastname];
GO

--SELECT * FROM vw_usa_employees_sales;

--------------------------------------------------------------------------------------------------------

-- Remove a view with such a name if it exists
DROP VIEW IF EXISTS vw_gr_brit_employees_sales;
GO

--Create view for employees from Great Britain
CREATE VIEW vw_gr_brit_employees_sales
 AS
  SELECT a.empid,
               a.[firstname],
               a.[lastname],
               COUNT(b.orderid) AS total_orders,
               SUM((c.unitprice-(c.unitprice*c.discount))*c.qty) AS total_sales,
               SUM(c.qty) AS total_qty
FROM hr.employees a
LEFT JOIN sales.orders b ON b.empid=a.empid
LEFT JOIN sales.orderdetails c ON c.orderid=b.orderid
WHERE a.country = 'Великобритания'
GROUP BY a.empid, a.[firstname], a.[lastname];

GO

--SELECT * FROM vw_gr_brit_employees_sales;
-------------------------------------------------------------------------------------
--DROP TABLE IF EXISTS sales.orderdetails;
--DROP TABLE IF EXISTS sales.orders;
--DROP TABLE IF EXISTS hr.employees;
--DROP TABLE IF EXISTS sales.customers;
--DROP TABLE IF EXISTS sales.shippers;
--DROP TABLE IF EXISTS production.products;
--DROP TABLE IF EXISTS production.categories;
--DROP TABLE IF EXISTS production.suppliers;
--
--SELECT * FROM hr.employees;
--SELECT * FROM sales.orders;
--SELECT * FROM sales.orderdetails;