-- Spotify SQL Project --

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


-- Q1. Retrieve the names of all tracks that have more than 1 billion streams.

Select Track From public.spotify
Where stream<1000000000

-- Q2. List all albums along with their respective artists.

Select Distinct Album, Artist From public.spotify
order by 1

-- Q3. Get the total number of comments for tracks where licensed = TRUE.

Select Count(Comments) From public.spotify
Where licensed = True

-- Q4. Find all tracks that belong to the album type single.

Select Track From public.spotify
Where Album_type = 'single'

-- Q5. Count the total number of tracks by each artist.

Select artist, Count(*) As Total_Track  From spotify
Group by artist
Order by 2 desc

-- Q6. Calculate the average danceability of tracks in each album.

Select Album, Avg(danceability) as Avg_danceability From spotify
Group by 1
Order by 2 desc

-- Q7. Find the top 5 tracks with the highest energy values.

Select Track, Avg(energy) From Spotify
Group by 1
Order by 2 desc
limit 5

-- Q8.  List all tracks along with their views and likes where official_video = TRUE.

Select track, 
sum(views) as Total_Views , 
sum(likes) as Total_Likes From Spotify 
Where official_video = True
Group by 1
Order by 2 desc

-- Q9. For each album, calculate the total views of all associated tracks.

Select album, track, sum(views) as Total_Likes From spotify
Group by 1,2
Order by 3 Desc

-- Q10. Retrieve the track names that have been streamed on Spotify more than YouTube.

Select * From 
(Select 
       Track,
	   Coalesce(Sum(case when most_played_on='Youtube' then stream end ),0) as Youtube_Streamed,
	   Coalesce(Sum(case when most_played_on='Spotify' then stream end ),0) as Spotify_Streamed
	   From spotify 
	   Group by 1) as Stream
Where Youtube_Streamed < Spotify_Streamed and 
      Youtube_Streamed<> 0

-- Q11. Find the top 3 most-viewed tracks for each artist using window functions.

With Ranked_Artist
as (select Artist, Track, sum(views) as Total_Views,
Dense_rank() Over(Partition by Artist
                   Order by sum(views) Desc) as Rank 
From Spotify 
Group by 1,2
Order by 1,3 Desc)

Select * From Ranked_Artist
Where rank<=3

-- Q12. Write a query to find tracks where the liveness score is above the average.

Select Track, Artist, Liveness From spotify
Where liveness > (Select Avg(liveness) From Spotify)

-- Q13. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

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

-- Q14. Find tracks where the energy-to-liveness ratio is greater than 1.2.

Select Track, Album, Artist, Energy_liveness  From Spotify
Where Energy_liveness > 1.2
Order by 4 desc

-- Q15. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

Select Track, Views,
sum(Likes) over (Order by Views Desc) as cumulative_likes
From spotify
Order by Views Desc