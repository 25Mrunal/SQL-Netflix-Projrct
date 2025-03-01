# Netflix Data Analysis using SQL

![Netflix-logo](https://github.com/25Mrunal/SQL-Netflix-Projrct/blob/main/netflix-logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset
The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
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
```

## 20 Business Problrms & Solutions

### 1. Count the number of Movies vs TV Shows

```sql
SELECT 
  type, COUNT(*) AS count_number 
  FROM netflix 
  GROUP BY type;
```
### 2. Find the most common rating for movies and TV shows
```sql
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
  ```
  
### 3. List all movies released in a specific year (e.g., 2020)

```sql
SELECT
  title 
  FROM netflix 
  WHERE type='Movie' AND release_year=2020;
```
### 4. Find the top 5 countries with the most content on Netflix

```sql
SELECT
  UNNEST(STRING_TO_ARRAY(country, ',')) AS new_country,
  COUNT(show_id) AS total_content
  FROM netflix
  GROUP BY 1
  ORDER BY 2 DESC
  LIMIT 5;
```

### 5. Identify the longest movie

```sql
SELECT title 
  FROM netflix 
  WHERE 
  TYPE='Movie' AND duration = (SELECT MAX(duration) FROM netflix);
```
  
### 6. Find content added in the last 5 years

```sql
SELECT  *
  FROM netflix 
  WHERE
  TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

### 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

```sql
SELECT * 
  FROM netflix 
  WHERE director 
  ILIKE '%Rajiv Chilaka%';
```
  
###  8. List all TV shows with more than 5 seasons

```sql
SELECT 
  * 
  FROM netflix 
  WHERE type = 'TV Show' 
  AND
  SPLIT_PART(duration, ' ' ,1)::numeric > 5 ;
```

### 9. Count the number of content items in each genre

```sql
SELECT
  UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
  COUNT(show_id) as total_content
FROM netflix
GROUP BY 1;
```

### 10.Find each year and the average numbers of content release in India on netflix. return top 5 year with highest avg content release!

```sql
SELECT 
  EXTRACT(YEAR FROM TO_DATE(date_added, '	Month DD, YYYY')) AS date,
  COUNT(*) AS yearly_content,
  Round(
  COUNT(*)::numeric/(SELECT COUNT(*) FROM netflix WHERE country = 'India') * 100 
  ,2) AS avg_content
FROM netflix 
WHERE country='India'
GROUP BY 1;
```

### 11. List all movies that are documentaries

```sql
SELECT * FROM netflix
WHERE
listed_in ILIKE '%documentaries%';
```

### 12. Find all content without a director

```sql
SELECT * 
  FROM netflix 
  =WHERE director IS NULL;
```
  
### 13. Find how many movies actor 'Salman Khan' appeared inlast 10 years!

```sql
SELECT * FROM netflix
  WHERE
  casts ILIKE '%Salman Khan%'
  AND
  release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

### 14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

```sql
SELECT 
UNNEST(string_to_array(casts, ',')) AS actors,
COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;
```

### 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

```sql
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
  GROUP BY 1;
```

### 16.List the top 5 directors with the highest number of content items on Netflix.

```sql
SELECT director, COUNT(*) AS content_count
FROM netflix
WHERE director IS NOT NULL
GROUP BY director
ORDER BY content_count DESC
LIMIT 5;
```

### 17. List all Horrar Movies released in India

```sql
SELECT title, country, release_year
FROM netflix
WHERE listed_in ILIKE '%Horror%' AND country = 'India' AND release_year > 2015;
```

### 18. Identitfy the oldest Movie and TV Show

```sql
SELECT type, title, release_year
FROM netflix
ORDER BY release_year ASC
LIMIT 2;
```

### 19 Find the number of content items with missing descriptions.

```sql
SELECT COUNT(*)
FROM netflix
WHERE description IS NULL OR description = '';
```

### 20. Find how many movies were released each year by the USA.

```sql
SELECT  release_year, COUNT(*) AS movie_count
FROM netflix
WHERE type = 'Movie' AND country = 'United States'
GROUP BY release_year
ORDER BY release_year;
```
