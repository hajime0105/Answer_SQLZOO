/*
1. Bigger than Russia
    List each country name where the population is larger than that of 'Russia'.
      world(name, continent, area, population, gdp)
*/
select name 
from world
where population > (
    select population 
    from world
    where name = 'Russia'
  )
;

/*
2. Richer than UK
    Show the countries in Europe with a per capita GDP greater than 'United 
    Kingdom'.
    - Per Capita GDP
      The per capita GDP is the gdp/population
*/
select name
from world 
where continent = 'Europe'
  and (gdp/population) > (
    select gdp/population
    from world 
    where name = 'United Kingdom'
  )
;

/*
3. Neighbours of Argentina and Australia
    List the name and continent of countries in the continents containing 
    either Argentina or Australia. Order by name of the country.
*/
select name, continent
from world
where continent in (
    select continent 
    from world 
    where name in ('Argentina', 'Australia')
  )
order by name;

/*
4. Between Canada and Poland
    Which country has a population that is more than Canada but less than 
    Poland? Show the name and the population.
*/
select name, population
from world
where population > (
    select population
    from world
    where name = 'Canada'
  ) 
  and population < (
    select population
    from world
    where name = 'Poland'
  )
;

/*
5. Percentages of Germany
    Germany (population 80 million) has the largest population of the countries 
    in Europe. Austria (population 8.5 million) has 11% of the population of 
    Germany.

    Show the name and the population of each country in Europe. Show the 
    population as a percentage of the population of Germany.
*/
select name, concat(
    cast( 
      round(
        population / (
          select population 
          from world 
          where name = 'Germany'
        ) * 100, 0
      ) as numeric
    ), '%'
  ) as percentage
from world
where continent = 'Europe'
order by name;

/* 
6. Bigger than every country in Europe
    Which countries have a GDP greater than every country in Europe? [Give the 
    name only.] (Some countries may have NULL gdp values)
*/
select name
from world
where gdp is not NULL
  and gdp > (
    select max(gdp)
    from world
    where continent = 'Europe'
  )
;

/*
7. Largest in each continent
    Find the largest country (by area) in each continent, show the continent, 
    the name and the area:
*/
select continent, name, area 
from world x
where area >= ALL
  (
    SELECT area 
    FROM world y
    WHERE y.continent=x.continent
      AND area > 0
  )
order by name;

/* 
8. First country of each continent (alphabetically)
    List each continent and the name of the country that comes first 
    alphabetically.
*/
select continent, name 
from world x
where name <= all(
    select name
    from world y
    where y.continent = x.continent
  )
;

/*
9. Difficult Questions That Utilize Techniques Not Covered In Prior Sections
    Find the continents where all countries have a population <= 25000000. Then 
    find the names of the countries associated with these continents. Show 
    name, continent and population.
*/
select name, continent, population
from world x
where 25000000 > all(
    select population
    from world y
    where y.continent = x.continent 
      and y.population > 0
  )
order by name;

/* 
10. 
    Some countries have populations more than three times that of any of their 
    neighbours (in the same continent). Give the countries and continents.
*/
select name, continent
from world x
where population > all(
  select population*3 
  from world y 
  where y.continent = x.continent 
    and y.population > 0  
    and y.name != x.name
 ​ )
;
