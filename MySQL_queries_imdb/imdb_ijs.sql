use imdb_ijs;
---------------------------------------------------------------------------------------------------
# 1 The big picture
---------------------------------------------------------------------------------------------------
-- 1.1 How many actors are there in theactors table?
select count(*) from actors;
# 817718
-- 1.2 How many directors are there in the directors table?
select count(*) from directors;
# 86880
-- 1.3 How many movies are there in the movies table?
select count(*) from movies;
# 388269
---------------------------------------------------------------------------------------------------
# 2 Exploring the movies
---------------------------------------------------------------------------------------------------
-- 2.1 From what year are the oldest and the newest movies? What are the names of those movies?
SELECT name, year
FROM movies 
WHERE year = (SELECT MIN(year) FROM movies) 
OR year = (SELECT MAX(year) FROM movies); 
# 'Roundhay Garden Scene','1888', 'Traffic Crossing Leeds Bridge','1888', 'Harry Potter and the Half-Blood Prince','2008'
-- 2.2 What movies have the highest and the lowest ranks?
SELECT movies.name, movies.rank
FROM movies
WHERE movies.rank = (SELECT MIN(movies.rank) AS "lowest ranks" FROM movies); 
# lowest rank: 146 x 1
SELECT movies.name, movies.rank
FROM movies
WHERE movies.rank = (SELECT MAX(movies.rank) AS "highest ranks" FROM movies); 
# highest rank: 40 x 9.9
-- 2.3 What is the most common movie title?
SELECT movies.name, COUNT(*) AS magnitude 
FROM movies 
GROUP BY movies.name 
ORDER BY magnitude DESC
LIMIT 1; 
# 'Eurovision Song Contest, The','49'
---------------------------------------------------------------------------------------------------
# 3 Understanding the database
---------------------------------------------------------------------------------------------------
-- 3.1 Are there movies with multiple directors?
SELECT movie_id, COUNT(*) AS dir_count 
FROM movies_directors 
GROUP BY movie_id 
HAVING COUNT(*) > 1 
ORDER BY dir_count DESC; 
# 87 directors for the movie with the id 382052
SELECT movies.name
FROM movies, movies_directors
WHERE movie_id = '382052' AND id = '382052'
GROUP BY movies.name; 
# movie_id = '382052' AND id = '382052' have the title "The Bill"
-- 3.2 What is the movie with the most directors? Why do you think it has so many?
SELECT * FROM movies WHERE movies.id LIKE '382052'; 
# It has so many changing directors, since it is a TV Show from 1984, which was produced over almost 25 years.
-- 3.3 On average, how many actors are listed by movie?
SELECT ROUND(avg(tmp.res)) as avg_cast_no
FROM ( 
	SELECT count(*) as res 
	FROM roles
	GROUP BY movie_id
) 
as tmp
; 
# 11
-- 3.4 Are there movies with more than one “genre”?
select count(*) from movies_genres; 
# 395119 movies in total
SELECT count(*)
FROM movies_genres
WHERE movie_id IN 
(
    SELECT movie_id
    FROM movies_genres
    GROUP BY movie_id
    HAVING COUNT(distinct genre) > 1
)
; 
# 252217 movies with more then 1 genre 
SELECT 252217 / 395119;
# 64% of all movies have more then one genre
---------------------------------------------------------------------------------------------------
# 4 Looking for specific movies
---------------------------------------------------------------------------------------------------
-- 4.1 Can you find the movie called “Pulp Fiction”?
select * from movies where movies.name = 'pulp fiction'; 
# yes, with movies.id = '267038'
	-- 4.1.1 Who directed it?
SELECT first_name, last_name
FROM directors, movies
WHERE movies.id = '267038' AND directors.last_name LIKE 'Tar%' AND directors.first_name LIKE 'Que%';
# 'Quentin','Tarantino'
	-- 4.1.2 Which actors where casted on it?
SELECT DISTINCT actors.first_name,  actors.last_name
FROM actors, movies, roles
WHERE movies.id = '267038'
AND actors.id = roles.actor_id
AND roles.role != '';
-- 4.2 Can you find the movie called “La Dolce Vita”?
SELECT * FROM movies WHERE movies.name LIKE '%Dolce%' AND movies.name LIKE '%La%';
# movies.id = '89572'
	-- 4.2.1 Who directed it?
SELECT * FROM directors d, movies WHERE movies.id = '89572' AND d.last_name = 'Fellini' AND d.first_name LIKE 'Fe%';
	-- 4.2.2 Which actors where casted on it?
SELECT *
FROM actors, movies, roles
WHERE movies.id = '89572'
AND actors.id = roles.actor_id
AND roles.role != '';

select FLOOR(MOD(movies.year,100) / 10)*10 as decade, genre, COUNT(movie_id) as num_movies
from movies
JOIN movies_genres ON movies.id = movies_genres.movie_id
WHERE year >= 1900 AND year <2000
GROUP BY decade, genre
ORDER BY decade, num_movies desc;

-- 4.3 When was the movie “Titanic” by James Cameron released?
	-- 4.3.1 Hint: there are many movies named “Titanic”. We want the one directed by James Cameron.
SELECT * FROM directors d, movies WHERE movies.name = 'Titanic' AND d.last_name = 'Cameron' AND d.first_name LIKE 'Jam%';
# movie.id = '333856'
	-- 4.3.2 Hint 2: the name “James Cameron” is stored with a weird character on it.
SELECT * FROM directors d, movies m WHERE m.name = 'Titanic' AND m.id = '333856' AND d.last_name = 'Cameron' AND d.first_name LIKE 'Jam%';
# 1997
---------------------------------------------------------------------------------------------------
# 5 Actors and directors
---------------------------------------------------------------------------------------------------
-- Who is the actor that acted more times as “Himself”?
-- What is the most common name for actors? And for directors?
---------------------------------------------------------------------------------------------------
# 6 Analysing genders
---------------------------------------------------------------------------------------------------
-- How many actors are male and how many are female?
-- Answer the questions above both in absolute and relative terms.
---------------------------------------------------------------------------------------------------
# 7 Movies across time
---------------------------------------------------------------------------------------------------
-- How many of the movies were released after the year 2000?
-- How many of the movies where released between the years 1990 and 2000?
-- Which are the 3 years with the most movies? How many movies were produced on those years?
-- What are the top 5 movie genres?
-- What are the top 5 movie genres before 1920?
-- What is the evolution of the top movie genres across all the decades of the 20th century?
---------------------------------------------------------------------------------------------------
# 8 Putting it all together: names, genders and time
---------------------------------------------------------------------------------------------------
-- Has the most common name for actors changed over time?
-- Get the most common actor name for each decade in the XX century.
-- Re-do the analysis on most common names, splitted for males and females.
-- Is the proportion of female directors greater after 1968, compared to before 1968?
-- What is the movie genre where there are the most female directors? Answer the question both in absolute and relative terms.
-- How many movies had a majority of females among their cast? Answer the question both in absolute and relative terms.