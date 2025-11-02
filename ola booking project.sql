CREATE TABLE ola_bookings (
    booking_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(100),
    pickup_location VARCHAR(100),
    drop_location VARCHAR(100),
    booking_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE driver_bookings (
    driver_id SERIAL PRIMARY KEY,
    booking_id INT,
    customer_name VARCHAR(100),
    pickup_location VARCHAR(100),
    drop_location VARCHAR(100),
    FOREIGN KEY (booking_id) REFERENCES ola_bookings(booking_id)
);

CREATE OR REPLACE FUNCTION insert_driver_booking()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO driver_bookings(booking_id, customer_name, pickup_location, drop_location)
    VALUES (NEW.booking_id, NEW.customer_name, NEW.pickup_location, NEW.drop_location);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_booking_insert
AFTER INSERT ON ola_bookings
FOR EACH ROW
EXECUTE FUNCTION insert_driver_booking();

INSERT INTO ola_bookings (customer_name, pickup_location, drop_location)
VALUES ('Rahul Sharma', 'Nagpur', 'Wardha');

CREATE OR REPLACE FUNCTION update_driver_location()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE driver_bookings
    SET pickup_location = NEW.pickup_location,
        drop_location = NEW.drop_location
    WHERE booking_id = NEW.booking_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_booking_update
AFTER UPDATE ON ola_bookings
FOR EACH ROW
EXECUTE FUNCTION update_driver_location();


UPDATE ola_bookings
SET drop_location = 'Amravati'
WHERE booking_id = 1;

CREATE OR REPLACE FUNCTION delete_driver_booking()
RETURNS TRIGGER AS $$
BEGIN
    DELETE FROM driver_bookings WHERE booking_id = OLD.booking_id;
    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER after_booking_delete
AFTER DELETE ON ola_bookings
FOR EACH ROW
EXECUTE FUNCTION delete_driver_booking();


DELETE FROM ola_bookings WHERE booking_id = 1;







