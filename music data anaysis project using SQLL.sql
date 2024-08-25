-- Q1: Who is the senior most employee based on job title?

SELECT 
    *
FROM
    employee
ORDER BY levels DESC
LIMIT 1;

-- Q2: Which countries have the most Invoices? 

SELECT 
    COUNT(*) AS c, billing_country
FROM
    invoice
GROUP BY billing_country
ORDER BY c DESC;

--  Q3: What are top 3 values of total invoice? 

SELECT 
    total
FROM
    invoice
ORDER BY total DESC
LIMIT 3;

--  * Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city
--  we made the most money. 
-- Write a query that returns one city that has the highest sum of invoice totals. 
-- Return both the city name & sum of all invoice totals.

SELECT 
    SUM(total) AS invoice_total, billing_city
FROM
    invoice
GROUP BY billing_city
ORDER BY invoice_total DESC

-- Q5: Who is the best customer? The customer who has spent the most money will be declared the best customer. 
-- Write a query that returns the person who has spent the most money.

SELECT 
    customer.customer_id,
    customer.first_name,
    customer.last_name,
    SUM(invoice.total) AS total
FROM
    customer
        JOIN
    invoice ON customer.customer_id = invoice.customer_id
GROUP BY customer.customer_id
ORDER BY total DESC
LIMIT 1;

 -- Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
-- Return your list ordered alphabetically by email starting with A.


SELECT DISTINCT
    email, first_name, last_name, genre.name
FROM
    customer
        JOIN
    invoice ON invoice.customer_id = customer.customer_id
        JOIN
    invoiceline ON invoiceline.invoice_id = invoice.invoice_id
        JOIN
    track ON track.track_id = invoiceline.track_id
        JOIN
    genre ON genre.genre_id = track.genre_id
WHERE
    genre.name LIKE 'Rock'
ORDER BY email;


-- Return all the track names that have a song length longer than the average song length. 
-- Return the Name and Milliseconds for each track.
--  Order by the song length with the longest songs listed first. 

SELECT 
    name, milliseconds
FROM
    track
WHERE
    milliseconds > (SELECT 
            AVG(milliseconds) AS avg_track_length
        FROM
            track)
ORDER BY milliseconds DESC;


-- We want to find out the most popular music Genre for each country.
--  We determine the most popular genre as the genre 
-- with the highest amount of purchases. Write a query that returns each country along with the top Genre.
--  For countries where the maximum number of purchases is shared return all Genres.

with popular_genre as
(
    select COUNT(invoice_line.quantity) as purchases, customer.country, genre.name, genre.genre_id, 
	row_number() over(partition by customer.country order by COUNT(invoice_line.quantity) desc) as RowNo 
    from invoice_line 
	join invoice on invoice.invoice_id = invoice_line.invoice_id
	join customer on customer.customer_id = invoice.customer_id
	join track on track.track_id = invoice_line.track_id
	join genre on genre.genre_id = track.genre_id
	group by  2,3,4
	order by 2 asc, 1 desc
)
select * from popular_genre where RowNo <= 1


-- Q3: Write a query that determines the customer that has spent the most on music for each country. 
-- Write a query that returns the country along with the top customer and how much they spent. 
-- For countries where the top amount spent is shared, provide all customers who spent this amount.

with Customter_with_country as (
		select customer.customer_id,first_name,last_name,billing_country,SUM(total) as total_spending,
	    row_number() over(partition by billing_country order by SUM(total) desc) as RowNo 
		from invoice
		join customer on customer.customer_id = invoice.customer_id
		group by 1,2,3,4
		order by 4 asc,5 desc)
select * from Customter_with_country where RowNo <= 1 


                  



