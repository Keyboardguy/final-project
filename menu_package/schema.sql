DROP TABLE IF EXISTS dishes;
DROP TABLE IF EXISTS type;

CREATE TABLE dishes (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  price REAL NOT NULL,
  menu_number INTEGER NOT NULL,
  type_id INTEGER NOT NULL,
  notes TEXT,
  FOREIGN KEY (type_id) REFERENCES type(id)
);

CREATE TABLE type (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT UNIQUE NOT NULL,
  notes TEXT
);

-- https://stackoverflow.com/questions/7739444/declare-variable-in-sqlite-and-use-it

/* Create in-memory temp table for variables */
BEGIN;

PRAGMA temp_store = 2; /* 2 means use in-memory */
CREATE TEMP TABLE _Variables(Name TEXT PRIMARY KEY, RealValue REAL, IntegerValue INTEGER, BlobValue BLOB, TextValue TEXT);

/* Declaring a variable */
INSERT INTO _Variables (Name) VALUES ('extras');

/* Assigning a variable (pick the right storage class) */
UPDATE _Variables SET TextValue = "Boiled Rice +20p, Chips +20p, Fried Rice +50p, Noodles +£1.50" WHERE Name = 'extras';

/* adding types */
INSERT INTO type (name) 
VALUES ("soup & appetisers");

INSERT INTO type (name, notes) 
VALUES ("duck dishes", (SELECT coalesce(RealValue, IntegerValue, BlobValue, TextValue) FROM _Variables WHERE Name = 'extras' LIMIT 1));

DROP TABLE _Variables;
END;

/* adding dishes */
INSERT INTO dishes (name, price, menu_number, notes, type_id)
VALUES ("Aromatic Crispy Duck (Whole)", 32.50, 1, "Served with pancake, spring onion, cucumber & honey bean sauce",
        (SELECT id FROM type WHERE name = 'soup & appetisers' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, notes, type_id)
VALUES ("Aromatic Crispy Duck (Half)", 18.00, 1, "Served with pancake, spring onion, cucumber & honey bean sauce",
        (SELECT id FROM type WHERE name = 'soup & appetisers' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, notes, type_id)
VALUES ("Aromatic Crispy Duck (Qtr)", 10.20, 1, "Served with pancake, spring onion, cucumber & honey bean sauce",
        (SELECT id FROM type WHERE name = 'soup & appetisers' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, notes, type_id)
VALUES ("Mixed Platter", 7.60, 2, "Prawn on toast, BBQ spare ribs, mini pancake rolls, deep fried wan tan",
        (SELECT id FROM type WHERE name = 'soup & appetisers' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, type_id)
VALUES ("BBQ Spare Ribs (No Sauce)", 6.20, 3, (SELECT id FROM type WHERE name = 'soup & appetisers' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, type_id)
VALUES ("Deep Fried Spare Ribs in Peking Sauce", 6.50, 4, (SELECT id FROM type WHERE name = 'soup & appetisers' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, notes, type_id)
VALUES ("Deep Fried Spare Ribs Salt & Chili", 6.50, 5, "spicy", (SELECT id FROM type WHERE name = 'soup & appetisers' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, notes, type_id)
VALUES ("Deep Fried Chicken Wings Salt & Chili", 5.30, 6, "spicy", (SELECT id FROM type WHERE name = 'soup & appetisers' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, type_id)
VALUES ("Seaweed (Crispy fried veg with dry fish powder)", 5.40, 7, (SELECT id FROM type WHERE name = 'soup & appetisers' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, type_id)
VALUES ("Prawn on Toast with Sesame Seeds", 4.60, 8, (SELECT id FROM type WHERE name = 'soup & appetisers' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, type_id)
VALUES ("Rice Paper Prawns", 4.80, 9, (SELECT id FROM type WHERE name = 'soup & appetisers' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, type_id)
VALUES ("Rice Paper Chicken", 4.50, 10, (SELECT id FROM type WHERE name = 'soup & appetisers' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, type_id)
VALUES ("Wan Tan Soup", 3.90, 11, (SELECT id FROM type WHERE name = 'soup & appetisers' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, notes, type_id)
VALUES ("Hot & Sour Soup", 3.50, 12, "spicy", (SELECT id FROM type WHERE name = 'soup & appetisers' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, type_id)
VALUES ("Chicken Sweetcorn Soup", 3.50, 13, (SELECT id FROM type WHERE name = 'soup & appetisers' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, type_id)
VALUES ("Three Delicacies Soup", 3.50, 14, (SELECT id FROM type WHERE name = 'soup & appetisers' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, type_id)
VALUES ("Chicken Noodle Soup", 3.30, 15, (SELECT id FROM type WHERE name = 'soup & appetisers' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, type_id)
VALUES ("Chicken Mushroom Soup", 3.30, 16, (SELECT id FROM type WHERE name = 'soup & appetisers' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, type_id)
VALUES ("Beaten Egg Tomato Soup", 3.30, 17, (SELECT id FROM type WHERE name = 'soup & appetisers' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, type_id)
VALUES ("Crispy Pancake Roll", 3.30, 18, (SELECT id FROM type WHERE name = 'soup & appetisers' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, type_id)
VALUES ("Vegetarian Pancake Roll", 3.50, 19, (SELECT id FROM type WHERE name = 'soup & appetisers' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, type_id)
VALUES ("Mini Vegetable Pancake Rolls (10)", 3.50, 19, (SELECT id FROM type WHERE name = 'soup & appetisers' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, type_id)
VALUES ("Duck with Pineapple & Ginger", 9.30, 79, (SELECT id FROM type WHERE name = 'duck dishes' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, type_id)
VALUES ("Duck with Chinese Mushroom & Bamboo Shoots", 9.30, 80, (SELECT id FROM type WHERE name = 'duck dishes' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, type_id)
VALUES ("Duck with Orange Sauce", 9.30, 81, (SELECT id FROM type WHERE name = 'duck dishes' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, type_id)
VALUES ("Duck with Lemon Sauce", 9.30, 82, (SELECT id FROM type WHERE name = 'duck dishes' LIMIT 1));

INSERT INTO dishes (name, price, menu_number, type_id)
VALUES ("Duck with Plum Sauce", 9.30, 83, (SELECT id FROM type WHERE name = 'duck dishes' LIMIT 1));
