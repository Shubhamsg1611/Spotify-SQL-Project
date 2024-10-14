# Spotify-SQL-Project

![Spotify Logo](https://open.spotifycdn.com/cdn/images/og-image.548bc4b7.png)

## Overview: 
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using SQL. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

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

## Questions: 

### Easy-Level Questions
1. Retrieve the names of all tracks that have more than 1 billion streams.
 ```sql
Select Track From public.spotify
Where stream<1000000000 
```
2. List all albums along with their respective artists.
```sql
Select Distinct Album, Artist From public.spotify
order by 1
```
3. Get the total number of comments for tracks where `licensed = TRUE`.
```sql
Select Count(Comments) From public.spotify
Where licensed = True
```
4. Find all tracks that belong to the album type `single`.
```sql
Select Track From public.spotify
Where Album_type = 'single'
```

5. Count the total number of tracks by each artist.
```sql
Select artist, Count(*) As Total_Track  From spotify
Group by artist
Order by 2 desc
```

### Medium-Level Question 
1. Calculate the average danceability of tracks in each album.
```sql
Select Album, Avg(danceability) as Avg_danceability From spotify
Group by 1
Order by 2 desc
```

2. Find the top 5 tracks with the highest energy values.
```sql
Select Track, Avg(energy) From Spotify
Group by 1
Order by 2 desc
limit 5
```

3. List all tracks along with their views and likes where `official_video = TRUE`.
```sql
Select track, 
sum(views) as Total_Views , 
sum(likes) as Total_Likes From Spotify 
Where official_video = True
Group by 1
Order by 2 desc
```

4. For each album, calculate the total views of all associated tracks.
```sql
Select album, track, sum(views) as Total_Likes From spotify
Group by 1,2
Order by 3 Desc
```

5. Retrieve the track names that have been streamed on Spotify more than YouTube.
```sql
Select * From 
(Select 
       Track,
	   Coalesce(Sum(case when most_played_on='Youtube' then stream end ),0) as Youtube_Streamed,
	   Coalesce(Sum(case when most_played_on='Spotify' then stream end ),0) as Spotify_Streamed
	   From spotify 
	   Group by 1) as Stream
Where Youtube_Streamed < Spotify_Streamed and 
      Youtube_Streamed<> 0
```

### Advanced-Level Question
1. Find the top 3 most-viewed tracks for each artist using window functions.
```sql
With Ranked_Artist
as (select Artist, Track, sum(views) as Total_Views,
Dense_rank() Over(Partition by Artist
                   Order by sum(views) Desc) as Rank 
From Spotify 
Group by 1,2
Order by 1,3 Desc)

Select * From Ranked_Artist
Where rank<=3
```

2. Write a query to find tracks where the liveness score is above the average.
```sql
Select Track, Artist, Liveness From spotify
Where liveness > (Select Avg(liveness) From Spotify)
```

3. **Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
```sql
WITH Energy_Difference
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
FROM Energy_Difference
ORDER BY 2 DESC
```
4. Find tracks where the energy-to-liveness ratio is greater than 1.2.
```sql
Select Track, Album, Artist, Energy_liveness  From Spotify
Where Energy_liveness > 1.2
Order by 4 desc
```

5. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
```sql
Select Track, Views,
sum(Likes) over (Order by Views Desc) as cumulative_likes
From spotify
Order by Views Desc
```

6. Find Top 3 Tracks with album, artist, views, likes.
```sql
Select Track, Artist, Sum(Views) as Total_Views, Sum(Likes) as Total_Likes
From Spotify 
Group by Track, Artist
Order by Sum(Views)Desc, Sum(Likes) Desc
Limit 3
```

7. List the top 3 artist who makes more album.
```sql
WITH Top_Artist AS (
    SELECT 
        Artist, 
        COUNT(DISTINCT Album) AS Total_Album, 
		COUNT(Track) AS Total_Track, 
        SUM(Views) AS Total_Views, 
        SUM(Likes) AS Total_Likes
    FROM spotify
    GROUP BY Artist
)
SELECT * 
FROM Top_Artist
ORDER BY Total_Album DESC
LIMIT 3
```

## Technology Stack
- Database: PostgreSQL
- SQL Queries: DDL, DML, Aggregations, Joins, Subqueries, Window Functions
- Tools: pgAdmin 4 (or any SQL editor), PostgreSQL (via Homebrew, Docker, or direct installation)

## How to Run the Project
1. Install PostgreSQL and pgAdmin (if not already installed).
2. Set up the database schema and tables using the provided normalization structure.
3. Insert the sample data into the respective tables.
4. Execute SQL queries to solve the listed problems.
5. Explore query optimization techniques for large datasets.

## Next Steps
- Visualize the Data: Use a data visualization tool like Tableau or Power BI to create dashboards based on the query results.
- Expand Dataset: Add more rows to the dataset for broader analysis and scalability testing.
- Advanced Querying: Dive deeper into query optimization and explore the performance of SQL queries on larger datasets.


