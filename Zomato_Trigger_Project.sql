CREATE TABLE zomato_orders (
    order_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    food_item VARCHAR(50),
    quantity INT,
    price DECIMAL(10,2)
);

CREATE TABLE restaurant_orders (
    rest_order_id INT,
    customer_name VARCHAR(50),
    food_item VARCHAR(50),
    quantity INT,
    price DECIMAL(10,2)
);


 DELIMITER 
CREATE FUNCTION add_to_restaurant(
    id INT,
    cname VARCHAR(50),
    food VARCHAR(50),
    qty INT,
    p DECIMAL(10,2)
)
RETURNS VARCHAR(50)
DETERMINISTIC
BEGIN
    INSERT INTO restaurant_orders VALUES (id, cname, food, qty, p);
    RETURN 'Order successfully added to restaurant';
END;

DELIMITER ;



INSERT INTO zomato_orders VALUES (1, 'Harshada', 'Pizza', 2, 400.00);
INSERT INTO zomato_orders VALUES (2, 'Amit', 'Burger', 1, 150.00);
INSERT INTO zomato_orders VALUES (3, 'pari', 'dosa', 2, 170.00);
INSERT INTO zomato_orders VALUES (4, 'shweta', 'Farmhouse Pizza', 2, 399.00);
INSERT INTO zomato_orders VALUES (5, 'janvi', 'chowmin', 1, 160.00);
INSERT INTO zomato_orders VALUES (6, 'vaishnvi', 'cold coffee', 4, 110.00);
INSERT INTO zomato_orders VALUES (7, 'lavanya', 'veg burger', 1, 298.00);
INSERT INTO zomato_orders VALUES (8, 'dipali', 'panner masala', 2, 299.00);


SELECT * FROM zomato_orders;
SELECT * FROM restaurant_orders;

CREATE OR REPLACE FUNCTION
add_to_restaurant(
    id INT,
    cname VARCHAR(50),
    food VARCHAR(50),
    qty INT,
    p DECIMAL(10,2)
)
RETURNS VARCHAR(50)
AS $$
BEGIN
    INSERT INTO restaurant_orders VALUES (id, cname, food, qty, p);
    RETURN 'Order successfully added to restaurant';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION after_zomato_insert_func()
RETURNS TRIGGER 
AS $$
BEGIN
    CALL add_to_restaurant(NEW.order_id, NEW.customer_name, NEW.food_item, NEW.quantity, NEW.price);
RETURN NEW;
END;
$$ LANGUAGE plpgsql;


create or replace function after_zomato_update_func()
return trigger
AS $$
BEGIN
CREATE FUNCTION update_restaurant_orders
SET
    id INT,
    new_food VARCHAR(50),
    new_qty INT,
    new_price DECIMAL(10,2)
	
CREATE OR REPLACE FUNCTION after_zomato_update_func()
RETURNS TRIGGER
AS $$
BEGIN
    UPDATE restaurant_orders
    SET 
	food_item = new_food,
        quantity = new_qty,
        price = new_price
    WHERE id= rest_order_id;

	RETURN NEW;
END;
$$ LANGUAGE plpgsql;


create or replace function delete_resturant_order(id INT)
RETURNS VARCHAR(50)
AS $$
BEGIN
    DELETE FROM restaurant_orders WHERE rest_order_id = id;
    RETURN 'Order deleted from restaurant successfully';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION after_zomato_delete_func()
RETURNS TRIGGER
AS $$
BEGIN
    DELETE FROM restaurant_orders WHERE rest_order_id = OLD.order_id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER after_zomato_delete
AFTER DELETE ON zomato_orders
FOR EACH ROW
EXECUTE FUNCTION after_zomato_delete_func();

DELETE FROM zomato_orders WHERE order_id = 2;

SELECT * FROM restaurant_orders;





