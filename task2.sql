-- Check the Code length
SELECT MAX(LENGTH(Code)) from infectious_cases WHERE LENGTH(Code) > 5;

-- Create entities table
CREATE TABLE IF NOT EXISTS entities (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(150) NOT NULL UNIQUE,
	code VARCHAR(15)
);

-- Set values from infectious_cases tables
INSERT INTO entities (name, code) SELECT DISTINCT Entity, Code from infectious_cases;

SELECT * from entities;

-- Create deseases table
CREATE TABLE IF NOT EXISTS deseases (
	id INT AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(255) NOT NULL
);

-- Set deseases values (names taken from infectious_cases table desease columns)
INSERT INTO deseases (name) VALUES ("yaws"), ("polio"), ("guinea worm"), ("rabies"), ("malaria"), ("hiv"), ("tuberculosis"), ("smallpox"), ("cholera");

SELECT * from deseases;

-- Create desease_statistics table
CREATE TABLE desease_statistics (
	id INT AUTO_INCREMENT PRIMARY KEY,
	entity_id INT NOT NULL,
	desease_id INT,
	year YEAR NOT NULL,
	cases_number DOUBLE,
	FOREIGN KEY (entity_id) REFERENCES entities(id),
	FOREIGN KEY (desease_id) REFERENCES deseases(id)
);

-- Set values for each desease
INSERT INTO desease_statistics (entity_id, desease_id, year, cases_number) 
 SELECT e.id, 1, ic.Year, NULLIF(ic.Number_yaws, '') from entities e JOIN infectious_cases ic ON e.name = ic.Entity
UNION ALL
 SELECT e.id, 2, ic.Year, NULLIF(ic.polio_cases, '') from entities e JOIN infectious_cases ic ON e.name = ic.Entity
UNION ALL
 SELECT e.id, 3, ic.Year, NULLIF(ic.cases_guinea_worm, '') from entities e JOIN infectious_cases ic ON e.name = ic.Entity
UNION ALL
 SELECT e.id, 4, ic.Year, NULLIF(ic.Number_rabies, '') from entities e JOIN infectious_cases ic ON e.name = ic.Entity
UNION ALL
 SELECT e.id, 5, ic.Year, NULLIF(ic.Number_malaria, '') from entities e JOIN infectious_cases ic ON e.name = ic.Entity
UNION ALL
 SELECT e.id, 6, ic.Year, NULLIF(ic.Number_hiv, '') from entities e JOIN infectious_cases ic ON e.name = ic.Entity
UNION ALL
 SELECT e.id, 7, ic.Year, NULLIF(ic.Number_tuberculosis, '') from entities e JOIN infectious_cases ic ON e.name = ic.Entity
UNION ALL
 SELECT e.id, 8, ic.Year, NULLIF(ic.Number_smallpox, '') from entities e JOIN infectious_cases ic ON e.name = ic.Entity
UNION ALL
 SELECT e.id, 9, ic.Year, NULLIF(ic.Number_cholera_cases, '') from entities e JOIN infectious_cases ic ON e.name = ic.Entity;

-- Check count (desease_statistics normalized table should have more rows in 9 times than infectious_cases)
SELECT COUNT(*) AS old_rows FROM infectious_cases;
SELECT COUNT(*) AS new_rows FROM desease_statistics;