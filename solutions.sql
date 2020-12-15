-- Practice joins

-- Helpful syntax:
-- SELECT [Column names] FROM [table] [abbv]
-- JOIN [table2] [abbv2] ON abbv.prop = abbv2.prop WHERE [Conditions];

-- SELECT a.name, b.name FROM some_table a JOIN another_table b ON a.some_id = b.some_id;
-- SELECT a.name, b.name FROM some_table a JOIN another_table b ON a.some_id = b.some_id WHERE b.email = 'e@mail.com';



-- Get all invoices where the unit_price on the invoice_line is greater than $0.99.
SELECT * FROM invoice
JOIN invoice_line ON invoice.invoice_id = invoice_line.invoice_id WHERE invoice_line.unit_price > .99;

-- Get the invoice_date, customer first_name and last_name, and total from all invoices.
SELECT i.invoice_date, c.first_name, c.last_name, i.total FROM invoice i
JOIN customer c ON i.customer_id = c.customer_id;

-- Get the customer first_name and last_name and the support rep's first_name and last_name from all customers.
SELECT c.first_name, c.last_name, e.last_name, e.first_name FROM invoice i
JOIN customer c ON i.customer_id = c.customer_id
JOIN employee e ON c.support_rep_id = e.employee_id;

-- Get the album title and the artist name from all albums.
SELECT a.title, artist.name FROM album a
JOIN artist ON a.artist_id = artist.artist_id;

-- Get all playlist_track track_ids where the playlist name is Music.
SELECT p.name, pt.track_id FROM playlist p
 JOIN playlist_track pt ON p.playlist_id = pt.playlist_id WHERE p.name LIKE 'Music';

-- Get all track names for playlist_id 5.
SELECT t.name FROM playlist_track pt
JOIN track t ON pt.track_id = t.track_id WHERE pt.playlist_id = 5;

-- Get all track names and the playlist name that they're on ( 2 joins ).
SELECT t.name, p.name FROM playlist p
JOIN playlist_track pt ON p.playlist_id = pt.playlist_id
JOIN track t ON pt.track_id = t.track_id;

-- Get all track names and album titles that are the genre Alternative & Punk ( 2 joins ).
SELECT t.name, a.title FROM track t
JOIN album a ON t.album_id = a.album_id
JOIN genre g ON t.genre_id = g.genre_id WHERE g.name LIKE 'Alternative & Punk%';


-- Black Diamond
-- Get all tracks on the playlist(s) called Music and show their name, genre name, album name, and artist name.
-- At least 5 joins.


-- Practice nested queries
-- Complete the instructions without using any joins. Only use nested queries to come up with the solution.
-- Get all invoices where the unit_price on the invoice_line is greater than $0.99.
SELECT * FROM invoice
WHERE invoice_id IN (
  SELECT invoice_id FROM invoice_line
  WHERE unit_price > .99
);
-- Get all playlist tracks where the playlist name is Music.
SELECT * FROM playlist_track pt
WHERE playlist_id IN (
  SELECT playlist_id FROM playlist
  WHERE name LIKE 'Music'
  );

-- Get all track names for playlist_id 5.
SELECT track.name FROM track
WHERE track_id IN (
  SELECT track_id FROM playlist_track
  WHERE playlist_id = 5
);

-- Get all tracks where the genre is Comedy.
SELECT track.name FROM track
WHERE genre_id IN (
  SELECT genre_id FROM genre
  WHERE genre.name = 'Comedy'
);

-- Get all tracks where the album is Fireball.
SELECT * FROM track
WHERE album_id IN (
  SELECT album_id FROM album
  WHERE album.title = 'Fireball'
);

-- Get all tracks for the artist Queen ( 2 nested subqueries ).
SELECT * FROM track
WHERE album_id IN (
  SELECT album_id FROM album
  WHERE artist_id IN (
    SELECT artist_id FROM artist
    WHERE name = 'Queen'
    )
  );

-- Practice updating Rows
-- Find all customers with fax numbers and set those numbers to null.
UPDATE customer 
SET fax = NULL
WHERE fax IS NOT NULL;

-- Find all customers with no company (null) and set their company to "Self".
UPDATE customer
SET company = 'Self'
WHERE company IS NULL;

-- Find the customer Julia Barnett and change her last name to Thompson.
UPDATE customer
SET last_name = 'Thompson'
WHERE last_name = 'Barnett' 
AND first_name = 'Julia';

-- Find the customer with this email luisrojas@yahoo.cl and change his support rep to 4.
UPDATE customer
SET support_rep_id = 4
WHERE email = 'luisrojas@yahoo.cl'
AND support_rep_id = 5;

-- Find all tracks that are the genre Metal and have no composer. Set the composer to "The darkness around us".
UPDATE track
SET composer = 'The darkness around us'
WHERE genre_id IN (
    SELECT genre_id FROM genre
    WHERE name = 'Metal'
)
AND composer IS NULL;

-- Group by
-- Find a count of how many tracks there are per genre. Display the genre name with the count.

SELECT COUNT(*), g.name
FROM track t  
JOIN genre g ON t.genre_id = g.genre_id
GROUP BY g.name;

/*
HOW TO SELECT ALL TRACK NAMES AND GENRES
SELECT t.name, g.name FROM track t
JOIN genre g ON t.genre_id = g.genre_id;

-another attempt
SELECT count(genre.name)
FROM genre
GROUP BY track.name, genre.name

-another attempt
SELECT genre_id FROM genre
WHERE genre_id IN (
    SELECT COUNT(genre_id)
)
*/

-- Find a count of how many tracks are the "Pop" genre and how many tracks are the "Rock" genre.
SELECT COUNT (*), g.name
FROM track t 
JOIN genre.g ON g.genre_id = t.genre_id
WHERE g.name = 'Pop' OR g.name = 'Rock'
GROUP BY g.name;

-- Find a list of all artists and how many albums they have.
SELECT ar.name, COUNT(*)
FROM album al 
JOIN artist ar ON ar.artist_id = al.artist_id
GROUP BY ar.name;


-- Use Distinct
-- From the track table find a unique list of all composers.
SELECT DISTINCT composer FROM track;
-- From the invoice table find a unique list of all billing_postal_codes.
SELECT DISTINCT billing_postal_code FROM invoice;
-- From the customer table find a unique list of all companys.
SELECT DISTINCT company FROM customer;

-- Delete Rows
-- Always do a select before a delete to make sure you get back exactly what you want and only what you want to delete! Since we cannot delete anything from the pre-defined tables ( foreign key restraints ), use the following SQL code to create a dummy table:

/*
CREATE TABLE practice_delete ( name TEXT, type TEXT, value INTEGER );
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'bronze', 50);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'bronze', 50);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'bronze', 50);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'silver', 100);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'silver', 100);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'gold', 150);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'gold', 150);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'gold', 150);
INSERT INTO practice_delete ( name, type, value ) VALUES ('delete', 'gold', 150);
SELECT * FROM practice_delete;
*/

-- Delete all 'bronze' entries from the table.
DELETE * FROM practice_delete
WHERE type = 'bronze';
-- Delete all 'silver' entries from the table.
DELETE * FROM practice_delete
WHERE type = 'silver';
-- Delete all entries whose value is equal to 150.
DELETE * FROM practice_delete
WHERE value = 150;


-- Create 3 tables following the criteria in the summary.
-- Add some data to fill up each table.
-- At least 3 users, 3 products, 3 orders.
CREATE TABLE table_1 (
    user VARCHAR(100) PRIMARY KEY,
    product TEXT,
    order INTEGER
)

INSERT INTO table_1 (user, product, order) VALUES ('Michael', 'thing', 1), ('Jorge', 'thingy', 2), ('Jeff', 'thingymabob', 3);



-- Run queries against your data.
-- Get all products for the first order.
SELECT product FROM table_1
WHERE order = 1;

-- Get all orders.
SELECT * FROM table_1

-- Get the total cost of an order ( sum the price of all products on an order ).
--I don't think I se this up right.

-- Add a foreign key reference from orders to users.
ALTER TABLE table_1
ALTER product
SET DATA TYPE VARCHAR(200) FOREIGN KEY; 

-- Update the orders table to link a user to each order.


-- Run queries against your data.
-- Get all orders for a user.
SELECT user, order FROM table_1

-- Get how many orders each user has.
SELECT user, order FROM table_1

-- Black Diamond
-- Get the total amount on all orders for each user.