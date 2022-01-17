use imdb_ijs;

# 1 The big picture
-- 1.1 How many actors are there in theactors table?
select count(*) from actors;
# 817718
-- 1.2 How many directors are there in the directors table?
select count(*) from directors;
# 86880
-- 1.3 How many movies are there in the movies table?
select count(*) from movies;
# 388269

# 2 Exploring the movies
-- 2.1 From what year are the oldest and the newest movies? What are the names of those movies?
SELECT name, year
FROM movies 
WHERE year = (SELECT MIN(year) FROM movies); # 'Roundhay Garden Scene','1888', 'Traffic Crossing Leeds Bridge','1888'
SELECT name, year
FROM movies 
WHERE year = (SELECT MAX(year) FROM movies); # 'Harry Potter and the Half-Blood Prince','2008'
-- 2.2 What movies have the highest and the lowest ranks?
# lowest rank
SELECT movies.name, movies.rank
FROM movies
WHERE movies.rank = (SELECT MIN(movies.rank) AS "lowest ranks" FROM movies); # 146 x 1
# highest rank
SELECT movies.name, movies.rank
FROM movies
WHERE movies.rank = (SELECT MAX(movies.rank) AS "highest ranks" FROM movies); # 40 x 9.9
-- 2.3 What is the most common movie title?
SELECT movies.name, COUNT(*) AS magnitude 
FROM movies 
GROUP BY movies.name 
ORDER BY magnitude DESC
LIMIT 1; # 'Eurovision Song Contest, The','49'

# 3 Understanding the database
-- 3.1 Are there movies with multiple directors?
SELECT movie_id, COUNT(*) AS dir_count 
FROM movies_directors 
GROUP BY movie_id 
HAVING COUNT(*) > 1 
ORDER BY dir_count DESC;
#
SELECT movies.name 
FROM movies
382052
-- 3.2 What is the movie with the most directors? Why do you think it has so many?
-- 3.3 On average, how many actors are listed by movie?
-- 3.4 Are there movies with more than one “genre”?

# 4 Looking for specific movies

-- 4.1 Can you find the movie called “Pulp Fiction”?
	-- 4.1.1 Who directed it?
	-- 4.1.2 Which actors where casted on it?
-- 4.2 Can you find the movie called “La Dolce Vita”?
	-- 4.2.1 Who directed it?
	-- 4.2.2 Which actors where casted on it?
-- 4.3 When was the movie “Titanic” by James Cameron released?
	-- 4.3.1 Hint: there are many movies named “Titanic”. We want the one directed by James Cameron.
	-- 4.3.2 Hint 2: the name “James Cameron” is stored with a weird character on it.

# 5 Actors and directors

-- Who is the actor that acted more times as “Himself”?
-- What is the most common name for actors? And for directors?

# 6 Analysing genders

-- How many actors are male and how many are female?
-- Answer the questions above both in absolute and relative terms.

# 7 Movies across time

-- How many of the movies were released after the year 2000?
-- How many of the movies where released between the years 1990 and 2000?
-- Which are the 3 years with the most movies? How many movies were produced on those years?
-- What are the top 5 movie genres?
-- What are the top 5 movie genres before 1920?
-- What is the evolution of the top movie genres across all the decades of the 20th century?

# 8 Putting it all together: names, genders and time

-- Has the most common name for actors changed over time?
-- Get the most common actor name for each decade in the XX century.
-- Re-do the analysis on most common names, splitted for males and females.
-- Is the proportion of female directors greater after 1968, compared to before 1968?
-- What is the movie genre where there are the most female directors? Answer the question both in absolute and relative terms.
-- How many movies had a majority of females among their cast? Answer the question both in absolute and relative terms.