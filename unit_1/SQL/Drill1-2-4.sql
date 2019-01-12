/*
What was the hottest day in our data set? Where was that?
How many trips started at each station?
What's the shortest trip that happened?
What is the average trip duration, by end station? */

SELECT 
  Date,
  ZIP
FROM
  weather
ORDER BY MaxTemperatureF DESC
LIMIT 1;

SELECT
  start_station,
  COUNT(start_station)
FROM
  trips
GROUP BY start_station;

SELECT
  trip_id
FROM
  trips
ORDER BY duration ASC
LIMIT 1;
-- There are actually 22 trips of duration 60, so I can also set min duration as min_dur and perform
-- WHERE duration = min_dur if I want to get all those tied for the shortest trip

SELECT 
  end_station,
  AVG(duration)
FROM
  trips
GROUP BY end_station;
