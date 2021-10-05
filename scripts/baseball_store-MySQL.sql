-- Als er reeds een database met de naam "baseball_store" bestaat
-- op je MySQL-server, dan zal dit script normaal gezien falen.
-- Dat is voor de veiligheid, zodat je niet per ongeluk
-- een bestaande databank wist.

-- Weet je zeker dat je de bestaande "baseball_store"-database wilt wissen
-- en vervangen door een nieuwe? Haal dan de "-- " weg in het begin van
-- de "DROP DATABASE"-lijn hieronder, en voer het script uit.
-- (De "-- " zorgt ervoor dat een commando niet uitgevoerd wordt.)

-- DROP DATABASE baseball_store;

CREATE DATABASE baseball_store;
USE baseball_store;

CREATE TABLE inventory_list (
    id      VARCHAR(11) NOT NULL,
    cost    DECIMAL(7,2) NOT NULL,
    units   DECIMAL(4) NOT NULL,
    CONSTRAINT inventory_list_pk PRIMARY KEY ( id )
);

CREATE TABLE items (
    itm_number    VARCHAR(10) NOT NULL,
    name          VARCHAR(20) NOT NULL,
    description   VARCHAR(50) NOT NULL,
    category      VARCHAR(25) NOT NULL,
    color         VARCHAR(15),
    itm_size      VARCHAR(1),
    ilt_id        VARCHAR(11) NOT NULL,
    CONSTRAINT item_pk PRIMARY KEY ( itm_number )
);

CREATE TABLE price_history (
    start_date   DATE NOT NULL,
    start_time   DATETIME NOT NULL,
    price        DECIMAL(7,2) NOT NULL,
    end_date     DATE,
    end_time     DATETIME,
    itm_number   VARCHAR(10) NOT NULL,
    CONSTRAINT price_history_pk PRIMARY KEY ( itm_number, start_date, start_time ),
    CONSTRAINT price_history_items_fk FOREIGN KEY ( itm_number ) REFERENCES items ( itm_number )
);

CREATE TABLE sales_representatives (
    id               VARCHAR(4) NOT NULL,
    email            VARCHAR(50) NOT NULL,
    first_name       VARCHAR(20) NOT NULL,
    last_name        VARCHAR(30) NOT NULL,
    phone_number     VARCHAR(11) NOT NULL,
    commission_rate  DECIMAL(2) NOT NULL,
    supervisor_id    VARCHAR(4) NOT NULL,
    CONSTRAINT sales_representative_pk PRIMARY KEY ( id ),
    CONSTRAINT sre_email_uk UNIQUE (email)
);

CREATE TABLE sales_rep_addresses (
    id               VARCHAR(4) NOT NULL,
    address_line_1   VARCHAR(30) NOT NULL,
    address_line_2   VARCHAR(30),
    city             VARCHAR(15) NOT NULL,
    zip_code         VARCHAR(7) NOT NULL,
    CONSTRAINT sales_rep_address_pk PRIMARY KEY ( id )
);

CREATE TABLE teams (
    id                  VARCHAR(4) NOT NULL,
    name                VARCHAR(20) NOT NULL,
    number_of_players   DECIMAL(2) NOT NULL,
    discount            DECIMAL(2),
    CONSTRAINT team_pk PRIMARY KEY ( id )
);

CREATE TABLE customers (
    ctr_number            VARCHAR(6) NOT NULL,
    email                 VARCHAR(50) NOT NULL,
    first_name            VARCHAR(20) NOT NULL,
    last_name             VARCHAR(30) NOT NULL,
    phone_number          VARCHAR(11) NOT NULL,
    current_balance       DECIMAL(6,2) NOT NULL,
    sre_id                VARCHAR(4),
    tem_id                VARCHAR(4),
    loyalty_card_number   VARCHAR(6),
    CONSTRAINT customer_pk PRIMARY KEY ( ctr_number ),
    CONSTRAINT ctr_email_uk UNIQUE (email),
    CONSTRAINT ctr_lcn_uk UNIQUE (loyalty_card_number)
);

CREATE TABLE customers_addresses (
    id               VARCHAR(8) NOT NULL,
    address_line_1   VARCHAR(30) NOT NULL,
    address_line_2   VARCHAR(30),
    city             VARCHAR(15) NOT NULL,
    zip_code         VARCHAR(7) NOT NULL,
    ctr_number       VARCHAR(6) NOT NULL,
    CONSTRAINT customer_address_pk PRIMARY KEY ( id )
);

CREATE TABLE orders (
    id                VARCHAR(9) NOT NULL,
    odr_date          DATE NOT NULL,
    odr_time          DATETIME NOT NULL,
    number_of_units   DECIMAL(2) NOT NULL,
    ctr_number        VARCHAR(6) NOT NULL,
    CONSTRAINT orders_pk PRIMARY KEY ( id )
);


CREATE TABLE ordered_items (
    quantity_ordered   DECIMAL(3) NOT NULL,
    quantity_shipped   DECIMAL(3) NOT NULL,
    itm_number         VARCHAR(10) NOT NULL,
    odr_id             VARCHAR(9) NOT NULL,
    CONSTRAINT ordered_item_pk PRIMARY KEY ( itm_number,odr_id )
);

ALTER TABLE customers_addresses ADD CONSTRAINT customer_address_customer_fk FOREIGN KEY ( ctr_number )
    REFERENCES customers ( ctr_number );

ALTER TABLE customers ADD CONSTRAINT customer_sales_rep_fk FOREIGN KEY ( sre_id )
    REFERENCES sales_representatives ( id );

ALTER TABLE customers ADD CONSTRAINT customer_team_fk FOREIGN KEY ( tem_id )
    REFERENCES teams ( id );

ALTER TABLE items ADD CONSTRAINT item_inventory_list_fk FOREIGN KEY ( ilt_id )
    REFERENCES inventory_list ( id );

ALTER TABLE orders ADD CONSTRAINT order_customer_fk FOREIGN KEY ( ctr_number )
    REFERENCES customers ( ctr_number );

ALTER TABLE ordered_items ADD CONSTRAINT ordered_item_item_fk FOREIGN KEY ( itm_number )
    REFERENCES items ( itm_number );

ALTER TABLE ordered_items ADD CONSTRAINT ordered_item_order_fk FOREIGN KEY ( odr_id )
    REFERENCES orders ( id );

ALTER TABLE sales_rep_addresses ADD CONSTRAINT sales_rep_add_sales_rep_fk FOREIGN KEY ( id )
    REFERENCES sales_representatives ( id );

ALTER TABLE sales_representatives ADD CONSTRAINT sales_rep_sales_rep_fk FOREIGN KEY ( supervisor_id ) REFERENCES sales_representatives ( id );

-- Oracle-version of the trigger
-- CREATE OR REPLACE TRIGGER fkntm_orders BEFORE
--     UPDATE OF ctr_number ON orders
-- BEGIN
--     raise_application_error(
--         -20225,
--         'Non Transferable FK constraint  on table orders is violated'
--     );
-- END;

-- MySQL-version of the trigger
delimiter //
CREATE TRIGGER fkntm_orders
BEFORE UPDATE ON orders FOR EACH ROW
IF OLD.ctr_number != NEW.ctr_number THEN
    SIGNAL SQLSTATE '99999' SET MESSAGE_TEXT = 'Non Transferable FK constraint on table orders is violated';
END IF;//
delimiter ;

USE baseball_store;

INSERT INTO inventory_list (id, cost, units)
VALUES('il010230124', 2.5, 100);

INSERT INTO inventory_list (id, cost, units)
VALUES('il010230125', 7.99, 250);

INSERT INTO inventory_list (id, cost, units)
VALUES('il010230126', 5.24, 87);

INSERT INTO inventory_list (id, cost, units)
VALUES('il010230127', 18.95, 65);

INSERT INTO inventory_list (id, cost, units)
VALUES('il010230128', 97.46, 8);


INSERT INTO items (itm_number, name, description, category, color, itm_size, ilt_id )
VALUES('im01101044', 'gloves', 'catcher mitt', 'clothing', 'brown', 'm', 'il010230124');

INSERT INTO items (itm_number, name, description, category, color, itm_size, ilt_id )
VALUES('im01101045', 'under shirt', 'top worn under the game top', 'clothing', 'white', 's', 'il010230125');

INSERT INTO items (itm_number, name, description, category, color, itm_size, ilt_id )
VALUES('im01101046', 'socks', 'team socks with emblem', 'clothing', 'range', 'l', 'il010230126');

INSERT INTO items (itm_number, name, description, category, color, itm_size, ilt_id )
VALUES('im01101047', 'game top', 'team shirt with emblem', 'clothing', 'range', 'm', 'il010230127');

INSERT INTO items (itm_number, name, description, category, ilt_id )
VALUES('im01101048', 'premium bat', 'high quaity basball bat', 'equipment', 'il010230128');

INSERT INTO price_history (start_date, start_time, price, itm_number)
VALUES(STR_TO_DATE('17-Jun-2017', '%e-%b-%Y'), STR_TO_DATE('17-Jun-2016 09:00:00', '%e-%b-%Y %H:%i:%s'), 4.99, 'im01101044');

INSERT INTO price_history (start_date, start_time, price, end_date, end_time, itm_number)
VALUES(STR_TO_DATE('25-Nov-2016', '%e-%b-%Y'), STR_TO_DATE('25-Nov-2016 09:00:00', '%e-%b-%Y %H:%i:%s'), 14.99, STR_TO_DATE('25-Jan-2017', '%e-%b-%Y'), STR_TO_DATE('25-Jan-2017 17:00:00', '%e-%b-%Y %H:%i:%s'),'im01101045');

INSERT INTO price_history (start_date, start_time, price, end_date, end_time, itm_number)
VALUES(STR_TO_DATE('25-Jan-2017', '%e-%b-%Y'), STR_TO_DATE('25-Jan-2017 17:01:00', '%e-%b-%Y %H:%i:%s'), 8.99, STR_TO_DATE('25-Jan-2017', '%e-%b-%Y'), STR_TO_DATE('25-Jan-2017 19:00:00', '%e-%b-%Y %H:%i:%s'),'im01101045');

INSERT INTO price_history (start_date, start_time, price, itm_number)
VALUES(STR_TO_DATE('26-Jan-2017', '%e-%b-%Y'), STR_TO_DATE('26-Jan-2017 09:00:00', '%e-%b-%Y %H:%i:%s'), 15.99, 'im01101045');

INSERT INTO price_history (start_date, start_time, price, itm_number)
VALUES(STR_TO_DATE('12-Feb-2017', '%e-%b-%Y'), STR_TO_DATE('12-Feb-2017 12:30:00', '%e-%b-%Y %H:%i:%s'), 7.99, 'im01101046');

INSERT INTO price_history (start_date, start_time, price, itm_number)
VALUES(STR_TO_DATE('25-Apr-2017', '%e-%b-%Y'), STR_TO_DATE('25-Apr-2017 10:10:10', '%e-%b-%Y %H:%i:%s'), 24.99, 'im01101047');

INSERT INTO price_history (start_date, start_time, price, itm_number)
VALUES(STR_TO_DATE('31-May-2017', '%e-%b-%Y'), STR_TO_DATE('31-May-2017 16:35:30', '%e-%b-%Y %H:%i:%s'), 149.00, 'im01101048');

INSERT INTO sales_representatives (id, email, first_name, last_name, phone_number, commission_rate, supervisor_id)
VALUES('sr01', 'chray@obl.com', 'Charles', 'Raymond', '0134598761', 10, 'sr01');

INSERT INTO sales_representatives (id, email, first_name, last_name, phone_number, commission_rate, supervisor_id)
VALUES('sr02', 'vwright@obl.com', 'Victoria', 'Wright',	'0134598762', 5, 'sr01');

INSERT INTO sales_representatives (id, email, first_name, last_name, phone_number, commission_rate, supervisor_id)
VALUES('sr03', 'bspeed@obl.com', 'Barry', 'Speed', '0134598763', 5, 'sr01');

INSERT INTO sales_rep_addresses (id, address_line_1, address_line_2, city, zip_code )
VALUES('sr01', '12 Cherry Lane', 'Denton', 'Detroit', 'DT48211');

INSERT INTO sales_rep_addresses (id, address_line_1, address_line_2, city, zip_code )
VALUES('sr02', '87 Blossom Hill', 'Uptown', 'Detroit', 'DT52314');

INSERT INTO sales_rep_addresses (id, address_line_1, address_line_2, city, zip_code )
VALUES('sr03', '12 Junction Row', 'Skinflats', 'Detroit', 'DT52564');

INSERT INTO teams (id, name, number_of_players, discount)
VALUES('t001', 'Rockets', 25, 10);

INSERT INTO teams (id, name, number_of_players, discount)
VALUES('t002', 'Celtics', 42, 20);

INSERT INTO teams (id, name, number_of_players, discount)
VALUES('t003', 'Rovers', 8, null);

INSERT INTO customers (ctr_number, email, first_name, last_name, phone_number,    current_balance, sre_id, tem_id, loyalty_card_number)
VALUES('c00001', 'bob.thornberry@heatmail.com', 'Robert', 'Thornberry', '01234567898', 150.00, 'sr01', 't001', null);

INSERT INTO customers (ctr_number, email, first_name, last_name, phone_number, current_balance, loyalty_card_number)
VALUES('c00012', 'Jjones@freemail.com', 'Jennifer', 'Jones', '01505214598', 0.00, 'lc1015');

INSERT INTO customers (ctr_number, email, first_name, last_name, phone_number, current_balance, sre_id, tem_id)
VALUES('c00101', 'unknown@here.com', 'John', 'Doe', '03216547808', 987.50, 'sr01', 't002');

INSERT INTO customers (ctr_number, email, first_name, last_name, phone_number, current_balance, loyalty_card_number)
VALUES('c00103', 'MurciaA@globaltech.com', 'Andrew', 'Murcia', '07715246890', 85.00, 'lc2341');

INSERT INTO customers (ctr_number, email, first_name, last_name, phone_number, current_balance, sre_id, tem_id)
VALUES('c01986', 'margal87@delphiview.com', 'Maria', 'Galant', '01442736589', 125.65
, 'sr03', 't003');

INSERT INTO customers_addresses (id, address_line_1, address_line_2, city, zip_code, ctr_number)
VALUES('ca0101', '83 Barrhill Drive', null, 'Liverpool', 'LP79HJK', 'c00001');

INSERT INTO customers_addresses (id, address_line_1, address_line_2, city, zip_code, ctr_number)
VALUES('ca0102', '17 Gartsquare Road', 'Starford', 'Liverpool', 'LP89JHK', 'c00001');

INSERT INTO customers_addresses (id, address_line_1, address_line_2, city, zip_code, ctr_number)
VALUES('ca0103', '54 Ropehill Crescent', 'Georgetown', 'Star', 'ST45AGV', 'c00101');

INSERT INTO customers_addresses (id, address_line_1, address_line_2, city, zip_code, ctr_number)
VALUES('ca0104', '36 Watercress Lane', null, 'Jump', 'JP23YTH', 'c01986');

INSERT INTO customers_addresses (id, address_line_1, address_line_2, city, zip_code, ctr_number)
VALUES('ca0105', '63 Acacia Drive', 'Skins', 'Liverpool', 'LP83JHR', 'c00001');

INSERT INTO orders (id, odr_date, odr_time, number_of_units, ctr_number)
VALUES('or0101250', STR_TO_DATE('17-Apr-2017', '%e-%b-%Y'), STR_TO_DATE('17-Apr-2017 08:32:30', '%e-%b-%Y %H:%i:%s'), 10, 'c00001');

INSERT INTO orders (id, odr_date, odr_time, number_of_units, ctr_number)
VALUES('or0101350', STR_TO_DATE('24-May-2017', '%e-%b-%Y'), STR_TO_DATE('24-May-2017 10:30:35', '%e-%b-%Y %H:%i:%s'), 5, 'c00001');

INSERT INTO orders (id, odr_date, odr_time, number_of_units, ctr_number)
VALUES('or0101425', STR_TO_DATE('28-May-2017', '%e-%b-%Y'), STR_TO_DATE('28-May-2017 12:30:00', '%e-%b-%Y %H:%i:%s'), 18, 'c00103');

INSERT INTO orders (id, odr_date, odr_time, number_of_units, ctr_number)
VALUES('or0101681', STR_TO_DATE('02-Jun-2017', '%e-%b-%Y'), STR_TO_DATE('02-Jun-2017 14:55:30', '%e-%b-%Y %H:%i:%s'), 10, 'c00001');

INSERT INTO orders (id, odr_date, odr_time, number_of_units, ctr_number)
VALUES('or0101750', STR_TO_DATE('18-Jun-2017', '%e-%b-%Y'), STR_TO_DATE('18-Jun-2017 09:05:00', '%e-%b-%Y %H:%i:%s'), 1, 'c01986');

INSERT INTO ordered_items (quantity_ordered, quantity_shipped, odr_id, itm_number)
VALUES(5, 5, 'or0101250', 'im01101044');

INSERT INTO ordered_items (quantity_ordered, quantity_shipped, odr_id, itm_number)
VALUES(5, 5, 'or0101250', 'im01101046');

INSERT INTO ordered_items (quantity_ordered, quantity_shipped, odr_id, itm_number)
VALUES(5, 5, 'or0101350', 'im01101044');

INSERT INTO ordered_items (quantity_ordered, quantity_shipped, odr_id, itm_number)
VALUES(18, 18, 'or0101425', 'im01101047');

INSERT INTO ordered_items (quantity_ordered, quantity_shipped, odr_id, itm_number)
VALUES(10, 10, 'or0101681', 'im01101047');

INSERT INTO ordered_items (quantity_ordered, quantity_shipped, odr_id, itm_number)
VALUES(1, 1, 'or0101750', 'im01101048');
