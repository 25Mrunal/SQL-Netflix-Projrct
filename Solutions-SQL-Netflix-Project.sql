CREATE TABLE netflix(
show_id	varchar(5),
type varchar(10),
title varchar(150),
director varchar(210),	
casts varchar(1000),
country	varchar(150),
date_added	varchar(50),
release_year int,	
rating	varchar(10),
duration varchar(15),	
listed_in varchar(100),	
description varchar(250)
);

SELECT * FROM netflix;


-- 20 Business Problrms
-- 1. Count the number of Movies vs TV Shows

SELECT 
  type, COUNT(*) AS count_number 
  FROM netflix 
  GROUP BY type;

-- 2. Find the most common rating for movies and TV shows

SELECT 
  type,
  rating
  FROM 
  (
SELECT 
  type,
  rating,
  COUNT(*),
  RANK() OVER(PARTITION BY TYPE ORDER BY COUNT(*) DESC) AS ranking
  FROM netflix
  GROUP BY 1,2) AS t1
  WHERE ranking =1;
  
  
-- 3. List all movies released in a specific year (e.g., 2020)

SELECT
  title 
  FROM netflix 
  WHERE type='Movie' AND release_year=2020;
  
-- 4. Find the top 5 countries with the most content on Netflix

SELECT
  UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
  COUNT(show_id) AS total_content
  FROM netflix
  GROUP BY 1
  ORDER BY 2 DESC
  LIMIT 5

-- 5. Identify the longest movie
SELECT title 
  FROM netflix 
  WHERE 
  TYPE='Movie' AND duration = (SELECT MAX(duration) FROM netflix)
  
-- 6. Find content added in the last 5 years
SELECT  *
  FROM netflix 
  WHERE
  TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'


-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT * 
  FROM netflix 
  WHERE director 
  ILIKE '%Rajiv Chilaka%'
  
--  8. List all TV shows with more than 5 seasons

SELECT 
  * 
  FROM netflix 
  WHERE type = 'TV Show' 
  AND
  SPLIT_PART(duration, ' ' ,1)::numeric > 5 
  
-- 9. Count the number of content items in each genre

SELECT
  UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
  COUNT(show_id) as total_content
FROM netflix
GROUP BY 1

-- 10.Find each year and the average numbers of content release in India on netflix. 
--return top 5 year with highest avg content release!

SELECT 
  EXTRACT(YEAR FROM TO_DATE(date_added, '	Month DD, YYYY')) AS date,
  COUNT(*) AS yearly_content,
  Round(
  COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India') * 100 
  ,2) AS avg_content
FROM netflix 
WHERE country='India'
GROUP BY 1

--11. List all movies that are documentaries

SELECT * FROM netflix
WHERE
listed_in ILIKE '%documentaries%'

-- 12. Find all content without a director

SELECT * 
  FROM netflix 
  =WHERE director IS NULL
  
-- 13. Find how many movies actor 'Salman Khan' appeared inlast 10 years!

SELECT * FROM netflix
  WHERE
  casts ILIKE '%Salman Khan%'
  AND
  release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

-- 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT 
UNNEST(string_to_array(casts, ',')) AS actors,
COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
WITH new_table
AS
(
SELECT *,
  CASE
  WHEN
  description ILIKE '%kill%' OR
  description ILIKE '%violence%' THEN 'Bad_Content'
  ELSE 'Good_Content'
  END category
  FROM netflix
)
SELECT
  category,
  COUNT(*) as total_content
  FROM new_table
  GROUP BY 1

-- 16.List the top 5 directors with the highest number of content items on Netflix.

SELECT director, COUNT(*) AS content_count
FROM netflix
WHERE director IS NOT NULL
GROUP BY director
ORDER BY content_count DESC
LIMIT 5;

-- 17. List all Horrar Movies released in India

SELECT title, country, release_year
FROM netflix
WHERE listed_in ILIKE '%Horror%' AND country = 'India' AND release_year > 2015;

-- 18. Identitfy the oldest Movie and TV Show
SELECT type, title, release_year
FROM netflix
ORDER BY release_year ASC
LIMIT 2;

-- 19 Find the number of content items with missing descriptions.

SELECT COUNT(*)
FROM netflix
WHERE description IS NULL OR description = '';

--20. Find how many movies were released each year by the USA.
SELECT  release_year, COUNT(*) AS movie_count
FROM netflix
WHERE type = 'Movie' AND country = 'United States'
GROUP BY release_year
ORDER BY release_year;
