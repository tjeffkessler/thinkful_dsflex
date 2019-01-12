/*Let's confirm some of this new knowledge with a few basic exercises. Write SQL queries to return:
1) The IDs and durations for all trips of duration greater than 500, ordered by duration.
2) Every column of the stations table for station id 84.
3) The min temperatures of all the occurrences of rain in zip 94301.
Save your SQL queries in a gist or a GitHub repository and submit a link below. */

SELECT
  trip_id,
  duration
FROM
  trips
WHERE
  duration > 500
ORDER BY duration DESC;

SELECT * FROM  stations
WHERE station_id = 84;

SELECT
  MinTemperatureF
FROM
  weather
WHERE
  Events LIKE 'rain' AND
  ZIP = 94301;
