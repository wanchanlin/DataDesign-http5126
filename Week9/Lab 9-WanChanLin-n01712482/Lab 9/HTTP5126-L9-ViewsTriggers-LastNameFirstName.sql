--  LAB 9 Views & Triggers
--  Put your answers on the lines after each letter. E.g. your query for question 1A should go on line 5; your query for question 1B should go on line 7...
--  1 
-- A 
CREATE VIEW stock_items_under_twenty AS
SELECT category, item, inventory FROM stock_items WHERE inventory <=20;
-- B 
SELECT * FROM stock_items_under_twenty;
-- C 
SELECT * FROM stock_items_under_twenty WHERE inventory = 0;

--  2 
-- A 
CREATE VIEW sales_total_by_employee AS
SELECT first_name, last_name, SUM(price) AS 'Total Sales ($)'
FROM employees
JOIN sales ON employees.id=sales.employee
JOIN stock_items ON sales.item=stock_items.id
GROUP BY employees.id 
ORDER BY SUM(price) DESC;
-- B 
SELECT * FROM sales_total_by_employee;
-- C 
SELECT * FROM sales_total_by_employee WHERE 1000< `Total Sales ($)` ;

--  3 
-- A 
CREATE TRIGGER stock_items
AFTER INSERT ON sales 
FOR EACH ROW

UPDATE stock_items 
    SET inventory = inventory - 1
    WHERE id = 1015;
-- B 
INSERT INTO sales (date, item, employee)
VALUES ('2021-06-20',1015,114);
-- C 

INSERT INTO sales (date, item, employee)
VALUES ('2021-06-21',1005,116);
--  4 
-- A 
DELIMITER //
CREATE OR REPLACE TRIGGER stock_items_log
AFTER INSERT ON stock_items
FOR EACH ROW
BEGIN
    INSERT INTO stock_items_log (action, item_id, old_item, old_price, old_inventory, old_category, timestamp)
    VALUES ('Insert',  NEW.id, 'New Item', 15, 12, 'Piscine', NOW());
END//
DELIMITER ;

-- B 
DELIMITER //
CREATE OR REPLACE TRIGGER stock_items_log
BEFORE UPDATE ON stock_items
FOR EACH ROW
BEGIN
    INSERT INTO stock_items_log (action, item_id, old_item, old_price, old_inventory, old_category, timestamp)
    VALUES ('Update', OLD.id, OLD.item,OLD.price, OLD.inventory, OLD.category,  NOW());
END//
DELIMITER ;

-- C 
DELIMITER //
CREATE OR REPLACE TRIGGER stock_items_log
BEFORE DELETE ON stock_items
FOR EACH ROW
BEGIN
    INSERT INTO stock_items_log (action, item_id, old_item, old_price, old_inventory, old_category, timestamp)
    VALUES ('Delete', OLD.id, OLD.item,OLD.price, OLD.inventory, OLD.category,  NOW());
END//
DELIMITER ;



--  5
-- Run the queries in part A below before completing part 5B. 
-- Place your part 5 query below these queries where part B is indicated. 
-- Ensure these queries are included in your submission.
--
-- A
INSERT INTO stock_items (item, price, inventory, category) 
  VALUES ('Bad dog bed', '95', 2, 'Canine');
DELETE FROM stock_items 
  WHERE item = 'Bad dog bed';
INSERT INTO stock_items (item, price, inventory, category) 
  VALUES('Tiny size chew toy', 5, 5, 'Canine'),
  ('Huge water dish', 99, 18, 'Feline'),
  ('Fish bowl expert kit', 88, 11, 'Piscine'),
  ('Luxury cat collar', 150, 10, 'Feline');
UPDATE stock_items
  SET inventory = 0
  WHERE item = 'Luxury cat collar';
DELETE FROM stock_items
  WHERE inventory = 0;
UPDATE stock_items
  SET category = 'Cat'
  WHERE category = 'Feline';
INSERT INTO sales (`date`, item, employee)
  VALUES (NOW(), 1008, 114);
INSERT INTO sales (`date`, item, employee)
  VALUES (NOW(), 1005, 111);

ANSWER:
  INSERT INTO `stock_items_log` (`id`, `action`, `item_id`, `old_item`, `old_price`, `old_inventory`, `old_category`, `timestamp`) VALUES
(1,	'Delete',	1021,	'Bad dog bed',	95,	2,	'Canine',	'2024-11-07 22:27:04'),
(2,	'Delete',	1005,	'Luxury cat bed',	89,	0,	'Feline',	'2024-11-07 22:27:04'),
(3,	'Delete',	1025,	'Luxury cat collar',	150,	0,	'Feline',	'2024-11-07 22:27:04');
-- B
SELECT *
FROM stock_items_log
WHERE item_id = 1025;
