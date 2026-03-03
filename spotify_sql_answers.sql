--Asvance SQL project Spotify Datasets
-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

SELECT * FROM spotify
LIMIT 10;

--EDA
SELECT COUNT(*) FROM spotify;
SELECT COUNT(DISTINCT artist) FROM spotify;
SELECT COUNT(DISTINCT album) FROM spotify;

SELECT DISTINCT album_type FROM spotify;
SELECT album,album_type FROM spotify
WHERE album_type = 'single';

DELETE FROM spotify
WHERE duration_min = 0;
SELECT * FROM spotify
WHERE duration_min = 0;

-- BUSINESS QUETIONS
--1.Retrieve the names of all tracks that have more than 1 billion streams.
SELECT artist,track FROM spotify
WHERE stream > 1000000000;

--2.List all albums along with their respective artists.
SELECT 
DISTINCT artist,album 
FROM spotify;

--3.Get the total number of comments for tracks where licensed = TRUE.
SELECT SUM(comments) AS total_comments
FROM spotify
WHERE licensed = 'true';

--4.Find all tracks that belong to the album type single.
SELECT * FROM spotify
WHERE album_type ILIKE 'single';

--5.Count the total number of tracks by each artist.
SELECT artist,COUNT(track)
FROM spotify
GROUP BY artist;

--6.Calculate the average danceability of tracks in each album.
SELECT album,AVG(danceability) AS average_danceability
FROM spotify
GROUP BY 1
ORDER BY 2 DESC;

--7.Find the top 5 tracks with the highest energy values.
SELECT track,energy FROM spotify
ORDER BY 2 DESC LIMIT 5;

--8.List all tracks along with their views and likes where official_video = TRUE.
SELECT track,
	SUM(views),
	SUM(likes)
FROM spotify 
WHERE official_video = 'true'
GROUP BY 1;

--9.For each album, calculate the total views of all associated tracks.
SELECT album,track,sum(views) AS total_views
FROM spotify
GROUP BY 1,2;

--10.Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT * FROM
(SELECT  track,
	    COALESCE(SUM(CASE WHEN most_played_on = 'youtube' THEN stream END),0) AS streamed_on_youtube,
		COALESCE(SUM(CASE WHEN most_played_on = 'spotify' THEN stream END),0) AS streamed_on_spotify 
FROM spotify
GROUP BY 1
) AS t1
WHERE 
	streamed_on_spotify > streamed_on_youtube
	AND 
	streamed_on_youtube <> 0;

--11.Find the top 3 most-viewed tracks for each artist using window functions.
WITH ranking_artist
AS
(SELECT
		artist,
		track,
		SUM(views) AS total_views,
		DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
FROM spotify
GROUP BY 1,2
ORDER BY 1,3 DESC
)
SELECT * FROM ranking_artist
WHERE RANK <= 3;

--12.Write a query to find tracks where the liveness score is above the average.
SELECT 
		track,
		artist,
		liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);

--13.Use a WITH clause to calculate the difference 
--between the highest and lowest energy values for tracks in each album.
WITH cte
AS
(SELECT 
		album,
		MAX(energy) AS maximun_energy,
		MIN(energy) AS minimum_energy
FROM spotify
GROUP BY 1
)
SELECT
		album,
		maximun_energy - minimum_energy AS energy_difference
FROM cte
ORDER BY 2;

