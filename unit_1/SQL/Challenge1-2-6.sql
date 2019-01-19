/*Once you have your database set up, run some queries to start understanding San Francisco's Airbnbs. 
Here are some questions you should try to answer:
What's the most expensive listing? What else can you tell me about the listing?
What neighborhoods seem to be the most popular?
What time of year is the cheapest time to go to San Francisco? What about the busiest?*/

SELECT *
FROM sfo_listings
ORDER BY price DESC 
LIMIT 1;

/* Description:	"Full House Victorian: 7500 SqFt, 4 Floors, Hot Tub"	Host: "Sarah"		Neigborhood: "Western Addition"		
Type: "Entire home/apt"	 Price: "10000"		Last Review: "2018-05-24"		Availability per year: "18" */

SELECT 
	neighbourhood,
	COUNT(id) listing_count,
	SUM(number_of_reviews) review_count,
	SUM(number_of_reviews) / COUNT(id) AS reviews_per_listing,
	AVG(reviews_per_month) avg_reviews
FROM sfo_listings
GROUP BY neighbourhood
ORDER BY listing_count DESC, review_count DESC, avg_reviews DESC;

/* Outer Sunset would be my choice for the most popular neighborhood as the number of listings is well above average,
and of the neighborhoods with an above average number of listings, Outer Sunset has the most reviews per listing 
and the highest average reviews per month, the former being almost +2𝝈 and the latter being greater than +2𝝈.
Mission  had the most listings, far and away, and an average number of reviews per listing and reviews per month.
Western Addition, Castro, Bernal Heights, and Noe Valley would complete the top of my list for most popular neighborhoods
by these criteria. If I had data on whether or not the room was occupied, I would look to see occupancy rate by neighborhood. 
It would also be worth investigating how many reviews were positive, negative, and neutral(like auto-generated cancellation responses).*/

SELECT 
	EXTRACT(MONTH from calender_date) list_month,
	AVG(REGEXP_REPLACE(price::TEXT, '[$,]', '', 'g')::NUMERIC) AS avg_price
FROM sfo_calendar
GROUP BY list_month
ORDER BY avg_price DESC;

/*Winter is the cheapest time of year to go. The cheapest three months are January, February, and December.*/

SELECT 
	EXTRACT(MONTH from review_date) list_month,
	COUNT(listing_id) review_count
FROM sfo_reviews
GROUP BY list_month
ORDER BY review_count DESC;

/*Late spring and summer are the busiest times to go. The most reviews come in August, July, May, June, and September. 
Again, I wish I had data based on occupancy, but I do not and so I had to rely on comments. Bias from this analysis could result from 
reviewers waiting until some month after their trip to write their review and some months correlating with a higher percentage of guests
writing reviews than in other months (e.g. the beautiful summer weather making people feel more like writing glowing reveiws than
the dismal winter weather). Also of note, September and October were the highest priced months though August and July received
the most reviews. This could be due to greater supply in the summer months driving down prices. Let's check with the following query*/

SELECT
	EXTRACT(MONTH from calender_date) list_month,
	COUNT(listing_id) listing_count
FROM sfo_calendar
WHERE available LIKE 't'
GROUP BY list_month
ORDER BY listing_count DESC;

-- September and October have the fewest available listings. Winter has the most.



