/*What are the three longest trips on rainy days?
Which station is full most often?
Return a list of stations with a count of number of trips starting at that station but ordered by dock count.
(Challenge) What's the length of the longest trip for each day it rains anywhere?*/

SELECT 
	DISTINCT trips.trip_id, 
	trips.duration, 
	trips.start_date 
FROM trips 
JOIN weather 
ON DATE(trips.start_date) = DATE(weather.date) 
WHERE weather.events = 'Rain' 
ORDER BY 2 DESC 
LIMIT 3;

SELECT 
	station_id,
	COUNT(*)
FROM
	status
WHERE docks_available = 0
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 1;

WITH
	docks
AS (
	SELECT
		trips.start_terminal,
		(CASE WHEN trips.start_terminal = stations.station_id THEN stations.dockcount END) dock_count
	FROM 
		trips
	LEFT JOIN
		stations
	ON trips.start_terminal = stations.station_id
)
SELECT
	trips.start_terminal,
	docks.dock_count,
	COUNT(trips.trip_id)
FROM 
	trips
JOIN
	docks
ON trips.start_terminal = docks.start_terminal
GROUP BY trips.start_terminal, docks.dock_count
ORDER BY docks.dock_count DESC;

SELECT DISTINCT trips.trip_id, trips.duration, trips.start_date
FROM trips
LEFT JOIN weather
ON DATE(trips.start_date) = DATE(weather.date)
WHERE weather.events LIKE 'Rain'
ORDER BY trips.duration DESC
LIMIT 3;
