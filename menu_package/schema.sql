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
INSERT INTO type (name, notes) 
VALUES ("duck dishes", (SELECT coalesce(RealValue, IntegerValue, BlobValue, TextValue) FROM _Variables WHERE Name = 'extras' LIMIT 1));

DROP TABLE _Variables;
END;

/* adding dishes */
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

