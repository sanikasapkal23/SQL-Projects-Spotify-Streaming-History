create database spotify ;
use spotify ;
select * from `spotify dataset` ;
SELECT track_name, artist_name,
SUM(ms_played)/60000 AS total_minutes_played
FROM `spotify dataset`
GROUP BY track_name, artist_name
ORDER BY total_minutes_played DESC
LIMIT 10;

SELECT skipped,COUNT(*) AS play_count
FROM `spotify dataset`
GROUP BY skipped;
    
SELECT album_name, SUM(ms_played)/60000 AS total_minutes
FROM `spotify dataset`
GROUP BY album_name
ORDER BY total_minutes DESC
LIMIT 5;

SELECT reason_end,
COUNT(*) AS end_reason_count
FROM `spotify dataset`
GROUP BY reason_end
ORDER BY end_reason_count DESC;

select count(*) from `spotify dataset`;
delete from `spotify dataset` 
where ms_played is null ;
    
# which artists were most listened to this year?
select artist_name, round(sum(ms_played) / 36000 ,2) as hours_played from `spotify dataset`
where year(str_to_date(ts, '%m/%d/%Y %H:%i')) = 2025
group by artist_name order by hours_played desc limit 10;
    
    describe `spotify dataset`;
    
ALTER TABLE `spotify dataset`
MODIFY ts DATETIME;

ALTER TABLE `spotify dataset` ADD COLUMN ts_converted DATETIME;
UPDATE `spotify dataset`
SET ts_converted = STR_TO_DATE(ts, '%m/%d/%Y %H:%i');
ALTER TABLE `spotify dataset` DROP COLUMN ts;
ALTER TABLE `spotify dataset` CHANGE ts_converted ts1 DATETIME;
describe `spotify dataset`;

# which artists were most listened to this year?
SELECT artist_name, count(*) AS play_count
FROM `spotify dataset`
WHERE YEAR(ts1) = 2024 GROUP BY artist_name
ORDER BY play_count DESC
LIMIT 10;

#how does that compare to last year?
SELECT artist_name, 
SUM(CASE WHEN YEAR(ts1) = 2023 THEN ms_played ELSE 0 END) / 1000 / 60 / 60 AS hours_2023,
SUM(CASE WHEN YEAR(ts1) = 2024 THEN ms_played ELSE 0 END) / 1000 / 60 / 60 AS hours_2024
FROM `spotify dataset` WHERE YEAR(ts1) IN (2023, 2024)
GROUP BY artist_name
HAVING hours_2023 > 0 OR hours_2024 > 0
ORDER BY hours_2024 DESC LIMIT 10;

#what are the most-played songs overall?
SELECT track_name,artist_name,count(*) AS play_count
FROM `spotify dataset`
GROUP BY track_name, artist_name
ORDER BY play_count DESC
LIMIT 10;
 
# which artists are most frequently skipped?
SELECT track_name, artist_name, COUNT(*) AS skip_count FROM `spotify dataset`
WHERE skipped = 'TRUE' GROUP BY track_name, artist_name
ORDER BY skip_count DESC LIMIT 10;

# What are the most common times of day or days of the week for music streaming?
SELECT HOUR(ts1) AS hour_of_day,COUNT(*) AS total_plays
FROM `spotify dataset` GROUP BY hour_of_day
ORDER BY total_plays DESC;

SELECT DAYNAME(ts1) AS day_of_week,COUNT(*) AS total_plays
FROM `spotify dataset` GROUP BY day_of_week
ORDER BY total_plays DESC;

# What are the top 5 artists by total listening time?
SELECT artist_name, SUM(ts1)/60000 AS total_minutes_listened
FROM `spotify dataset`
GROUP BY artist_name
ORDER BY total_minutes_listened DESC LIMIT 5;

# What days of the week are most active for listening?
SELECT DAYNAME(ts1) AS weekday,COUNT(*) AS total_plays
FROM `spotify dataset`
GROUP BY weekday
ORDER BY FIELD(weekday, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');

# Songs played on a specific date
SELECT track_name, artist_name, ts1
FROM `spotify dataset`
WHERE DATE(ts1) = '2024-07-25';

#  What are the top 5 artists by total listening time?
SELECT artist_name, SUM(ts1)/60000 AS total_minutes_listened
FROM `spotify dataset`
GROUP BY artist_name
ORDER BY total_minutes_listened DESC LIMIT 5;

#Which songs were played the most?
SELECT track_name, artist_name, COUNT(*) AS play_count
FROM `spotify dataset`
GROUP BY track_name, artist_name
ORDER BY play_count DESC
LIMIT 10;

# What is the most active listening time (hour of day)?
SELECT HOUR(ts1) AS hour_of_day,COUNT(*) AS play_count
FROM `spotify dataset`
GROUP BY hour_of_day
ORDER BY play_count DESC;

# Tracks played more than 5 times
SELECT track_name, artist_name, COUNT(*) AS play_count
FROM `spotify dataset`
GROUP BY track_name, artist_name
HAVING play_count > 5;

# Days when more than 10 songs were listened
select DATE(ts1) AS date, track_name ,COUNT(*) AS song_count
from `spotify dataset`
GROUP BY DATE(ts1), track_name
HAVING song_count > 10;





