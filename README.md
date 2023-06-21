
# OLYMPIC HISTORY DATA EXPLORATION USING SQL

I have downloaded the Olympics history dataset from Kaggle. I have explored the data by writing the SQL queries for the following problem statements 
using Microsoft SQL server Management Studio (SSMS).

* How many Olympics games have been held?
* List down all Olympics games held so far.
*	Mention the total no of nations who participated in each olympics game?
*	Which year saw the highest and lowest no of countries participating in olympics?
*	Which nation has participated in all the olympic games?
*	Identify the sport which was played in all summer olympics.
*	Which Sports were just played only once in the olympics?
*	Fetch the total no of sports played in each olympic games.
*	Fetch details of the oldest athletes to win a gold medal.
*	Find the Ratio of male and female athletes participated in all olympic games.
*	Fetch the top 5 athletes who have won the most gold medals.
*	Fetch the top 5 athletes who have won the most medals (gold/silver/bronze).
*	Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.
*	List down total gold, silver and bronze medals won by each country.
*	List down total gold, silver and bronze medals won by each country corresponding to each olympic games.
*	Identify which country won the most gold, most silver and most bronze medals in each olympic games.
*	Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games.
*	Which countries have never won gold medal but have won silver/bronze medals?
*	In which Sport/event, India has won highest medals.
*	Break down all olympic games where India won medal for Hockey and how many medals in each olympic games.


The file olympics_history.csv contains 271116 rows and 15 columns. Each row corresponds to an individual athlete competing in an
individual Olympic event (olympics_history). The columns are:

1.	ID - Unique number for each athlete
2.	Name - Athlete's name
3.	Sex - M or F
4.	Age - Integer
5.	Height - In centimetre’s
6.	Weight - In kilograms
7.	Team - Team name
8.	NOC - National Olympic Committee 3-letter code
9.	Games - Year and season
10.	Year - Integer
11.	Season - Summer or Winter
12.	City - Host city
13.	Sport - Sport
14.	Event - Event
15.	Medal - Gold, Silver, Bronze, or NA


The file olympics_history_noc_regions contains 230 rows and 3 columns. The columns are:

1.	NOC (National Olympic Committee 3 letter code)
2.	Country name (matches with regions in map data("world"))
3.	Notes


