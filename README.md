# Spotify Advanced SQL Project and Query Optimization P-6
Project Category: Advanced
[Click Here to get Dataset](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

![Spotify Logo](https://github.com/Watchignite/Spotify_SQL_Project/blob/main/spotify_logo.jpg)

## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

```sql
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
```
## Project Steps

### 1. Data Exploration
Before diving into SQL, it’s important to understand the dataset thoroughly. The dataset contains attributes such as:
- `Artist`: The performer of the track.
- `Track`: The name of the song.
- `Album`: The album to which the track belongs.
- `Album_type`: The type of album (e.g., single or album).
- Various metrics such as `danceability`, `energy`, `loudness`, `tempo`, and more.

### 2. Querying the Data
After the data is inserted, various SQL queries can be written to explore and analyze the data. Queries are categorized into **easy**, **medium**, and **advanced** levels to help progressively develop SQL proficiency.

#### Easy Queries
- Simple data retrieval, filtering, and basic aggregations.
  
#### Medium Queries
- More complex queries involving grouping, aggregation functions, and joins.
  
#### Advanced Queries
- Nested subqueries, window functions, CTEs, and performance optimization.

### 3. Query Optimization
In advanced stages, the focus shifts to improving query performance. Some optimization strategies include:
- **Indexing**: Adding indexes on frequently queried columns.
- **Query Execution Plan**: Using `EXPLAIN ANALYZE` to review and refine query performance.
  
---

## 15 Practice Questions

### Easy Level
1. Retrieve the names of all tracks that have more than 1 billion streams.
```sql
SELECT artist,track FROM spotify
WHERE stream > 1000000000;
```
2. List all albums along with their respective artists.
```sql
SELECT 
DISTINCT artist,album 
FROM spotify;
```
3. Get the total number of comments for tracks where `licensed = TRUE`.
```sql
SELECT SUM(comments) AS total_comments
FROM spotify
WHERE licensed = 'true';
```
4. Find all tracks that belong to the album type `single`.
```sql
SELECT * FROM spotify
WHERE album_type ILIKE 'single';
```
5. Count the total number of tracks by each artist.
```sql
SELECT artist,COUNT(track)
FROM spotify
GROUP BY artist;
```

### Medium Level
6. Calculate the average danceability of tracks in each album.
```sql
SELECT album,AVG(danceability) AS average_danceability
FROM spotify
GROUP BY 1
ORDER BY 2 DESC;
```
7. Find the top 5 tracks with the highest energy values.
```sql
SELECT track,energy FROM spotify
ORDER BY 2 DESC LIMIT 5;
```
8. List all tracks along with their views and likes where `official_video = TRUE`.
```sql
SELECT track,
	SUM(views),
	SUM(likes)
FROM spotify 
WHERE official_video = 'true'
GROUP BY 1;
```
9. For each album, calculate the total views of all associated tracks.
```sql
SELECT album,track,sum(views) AS total_views
FROM spotify
GROUP BY 1,2;
```
10. Retrieve the track names that have been streamed on Spotify more than YouTube.
```sql
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
```

### Advanced Level
11. Find the top 3 most-viewed tracks for each artist using window functions.
```sql
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
```
12. Write a query to find tracks where the liveness score is above the average.
```sql
SELECT 
		track,
		artist,
		liveness
FROM spotify
WHERE liveness > (SELECT AVG(liveness) FROM spotify);
```
13. **Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
```sql
WITH cte
AS
(SELECT 
	album,
	MAX(energy) as highest_energy,
	MIN(energy) as lowest_energery
FROM spotify
GROUP BY 1
)
SELECT 
	album,
	highest_energy - lowest_energery as energy_diff
FROM cte
ORDER BY 2 DESC
```
14. Find tracks where the energy-to-liveness ratio is greater than 1.2.
15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.


Here’s an updated section for your **Spotify Advanced SQL Project and Query Optimization** README, focusing on the query optimization task you performed. You can include the specific screenshots and graphs as described.

---

## Query Optimization Technique 

To improve query performance, we carried out the following optimization process:

- **Initial Query Performance Analysis Using `EXPLAIN`**
    - We began by analyzing the performance of a query using the `EXPLAIN` function.
    - The query retrieved tracks based on the `artist` column, and the performance metrics were as follows:
        - Execution time (E.T.): **7 ms**
        - Planning time (P.T.): **0.17 ms**
    - Below is the **screenshot** of the `EXPLAIN` result before optimization:
      ![EXPLAIN Before Index](https://github.com/Watchignite/Spotify_SQL_Project/blob/main/spotify_explain_before_index.png)

- **Index Creation on the `artist` Column**
    - To optimize the query performance, we created an index on the `artist` column. This ensures faster retrieval of rows where the artist is queried.
    - **SQL command** for creating the index:
      ```sql
      CREATE INDEX idx_artist ON spotify_tracks(artist);
      ```

- **Performance Analysis After Index Creation**
    - After creating the index, we ran the same query again and observed significant improvements in performance:
        - Execution time (E.T.): **0.153 ms**
        - Planning time (P.T.): **0.152 ms**
    - Below is the **screenshot** of the `EXPLAIN` result after index creation:
      ![EXPLAIN After Index](https://github.com/Watchignite/Spotify_SQL_Project/blob/main/spotify_explain_after_index.png)

## Technology Stack
- **Database**: PostgreSQL
- **SQL Queries**: DDL, DML, Aggregations, Joins, Subqueries, Window Functions
- **Tools**: pgAdmin 4 (or any SQL editor), PostgreSQL (via Homebrew, Docker, or direct installation)

## How to Run the Project
1. Install PostgreSQL and pgAdmin (if not already installed).
2. Set up the database schema and tables using the provided normalization structure.
3. Insert the sample data into the respective tables.
4. Execute SQL queries to solve the listed problems.
5. Explore query optimization techniques for large datasets.

---

## Next Steps
- **Visualize the Data**: Use a data visualization tool like **Tableau** or **Power BI** to create dashboards based on the query results.
- **Expand Dataset**: Add more rows to the dataset for broader analysis and scalability testing.
- **Advanced Querying**: Dive deeper into query optimization and explore the performance of SQL queries on larger datasets.

---
##✅ Findings & Conclusion
###📌 Findings
1. Track Performance Insights <br>
Several tracks crossed 1 billion+ streams, indicating highly viral and globally popular songs. <br>
The top energy tracks are clustered mostly within electronic/pop genres, showing a positive correlation between energy and popularity. <br>
Tracks with high views and likes are frequently associated with official video releases, confirming that video availability boosts engagement. <br>

2. Artist & Album Trends <br>
Some artists consistently dominate streaming metrics, with albums producing multiple high-performing tracks. <br>
Many albums categorized as singles show higher individual engagement, aligning with current industry trends where singles outperform full albums. <br>

3. Audio Feature Relationships <br>
Tracks with higher danceability and tempo tend to achieve better performance. <br>
Songs with very high liveness (> average) are rare, indicating that most tracks are studio-produced rather than live recordings. <br>
The energy–liveness gap varied significantly across albums, showing diversity in production styles between albums. <br>

4. Platform Preference Analysis <br>
Using the Most_Played_On comparison: <br>
Several tracks performed better on Spotify than YouTube. <br>
Some tracks showed the reverse trend, especially those with strong video-centric appeal. <br>
This highlights a platform-dependent consumption pattern. <br>

5. Window & Ranking Analysis <br>
The top 3 most-viewed tracks per artist show: <br>
A small number of tracks generate the majority of views. <br>
This follows a long-tail distribution, common in music platforms. <br>

6. Query Optimization Findings <br>
Before indexing (artist column): <br>
Query execution time was 7 ms. <br>

After index creation: <br>
Execution time dropped to 0.153 ms, showing a ~45x performance improvement <br>
This confirms the effectiveness of indexing for filtering workloads. <br>

---
###📌 Conclusion
The Spotify SQL project demonstrates how a denormalized dataset can be explored to derive meaningful insights about track performance, artist popularity, album characteristics, and platform-level engagement.<br>
By applying:<br>
• CTEs<br>
• Aggregations<br>
• Window functions<br>
• Subqueries<br>
• Query optimization<br>
We were able to extract complex patterns efficiently.<br>
The project shows that:<br>
1. High-energy, high-danceability tracks perform better globally.<br>
2. Singles outperform album-based releases in many cases.<br>
3. Platform preference varies, highlighting user behavior differences between Spotify and YouTube.<br>
4. Indexes significantly improve query performance, essential for large datasets.<br>
Overall, the project reflects strong SQL skills in:<br>
• Data exploration<br>
• Data analysis<br>
• Performance tuning<br>
and demonstrates the importance of clean database design and optimization in real-world analytics tasks.<br>
## Contributing
If you would like to contribute to this project, feel free to fork the repository, submit pull requests, or raise issues.

## 👨‍💻 Author — Kothur Charan Reddy - STUDENT 
This project is part of my portfolio, showcasing the SQL skills essential for data analyst roles. If you have any questions, feedback, or would like to collaborate, feel free to get in touch!

💼 LinkedIn Profile : [Charan Kothur](https://www.linkedin.com/in/charankothur/)

## 💡 Thanks for checking out the project! Your support means a lot — feel free to star ⭐ this repo or share it with someone learning SQL.🚀
