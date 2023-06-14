select * from olympics_history
select * from olympics_history_noc_regions

-- Q(1): How many olympics games have been held?

    select count(distinct games) as total_olympic_games
    from olympics_history;


--Q(2): List down all Olympics games held so far. (Data issue at 1956-"Summer"-"Stockholm")

    select distinct oh.year,oh.season,oh.city
    from olympics_history oh
    order by year;


--Q(3): Mention the total no of nations who participated in each olympics game?

    with all_countries as
        (select games, nr.region
        from olympics_history oh
        join olympics_history_noc_regions nr ON nr.noc = oh.noc
        group by games, nr.region)
    select games, count(*) as total_countries
    from all_countries
    group by games
    --order by total_countries;

	
--Q(4): Which year saw the highest and lowest no of countries participating in olympics

      with all_countries as
              (select games, nr.region
              from olympics_history oh
              join olympics_history_noc_regions nr ON nr.noc=oh.noc
              group by games, nr.region),
          tot_countries as
              (select games, count(1) as total_countries
              from all_countries
              group by games)
      select distinct
      concat(first_value(games) over(order by total_countries)
      , ' - '
      , first_value(total_countries) over(order by total_countries)) as Lowest_Countries,
      concat(first_value(games) over(order by total_countries desc)
      , ' - '
      , first_value(total_countries) over(order by total_countries desc)) as Highest_Countries
      from tot_countries
      order by 1;


--Q(5):  Which nation has participated in all of the olympic games

      with tot_games as
              (select count(distinct games) as total_games
              from olympics_history),
          countries as
              (select games, nr.region as country
              from olympics_history oh
              join olympics_history_noc_regions nr ON nr.noc=oh.noc
              group by games, nr.region),
          countries_participated as
              (select country, count(1) as total_participated_games
              from countries
              group by country)
      select cp.*
      from countries_participated cp
      join tot_games tg on tg.total_games = cp.total_participated_games
      order by 1;

--Q(6): Identify the sport which was played in all summer olympics.
     
	 with t1 as
          	(select count(distinct games) as total_games
          	from olympics_history where season = 'Summer'),
          t2 as
          	(select distinct games, sport
          	from olympics_history where season = 'Summer'),
          t3 as
          	(select sport, count(1) as no_of_games
          	from t2
          	group by sport)
      select *
      from t3
      join t1 on t1.total_games = t3.no_of_games;

--Q(7): Which Sports were just played only once in the olympics.
      
	  with t1 as
          	(select distinct games, sport
          	from olympics_history),
          t2 as
          	(select sport, count(1) as no_of_games
          	from t1
          	group by sport)
      select t2.*, t1.games
      from t2
      join t1 on t1.sport = t2.sport
      where t2.no_of_games = 1
      order by t1.sport;

--Q(8): Fetch the total no of sports played in each olympic games.
      
	  with t1 as
      	(select distinct games, sport
      	from olympics_history),
        t2 as
      	(select games, count(1) as no_of_sports
      	from t1
      	group by games)
      select * from t2
      order by no_of_sports desc;





--Q(10) Find the Ratio of male to female athletes participated in all olympic games.

SELECT 
    (CAST((SELECT COUNT(*) FROM olympics_history WHERE sex='M') AS FLOAT) / 
     CAST((SELECT COUNT(*) FROM olympics_history WHERE sex='F') AS FLOAT)) 
    AS M_to_F_Ratio;


--Q(11) Top 5 athletes who have won the most gold medals.
   
   with t1 as
            (select name, team, count(1) as total_gold_medals
            from olympics_history
            where medal = 'Gold'
            group by name, team),
            --order by total_gold_medals desc),
        t2 as
            (select *, dense_rank() over (order by total_gold_medals desc) as rnk
            from t1)
    select name, team, total_gold_medals
    from t2
    where rnk <= 5;

-----------------------------

with t1 as
(select name,team,count(*) as Total_Gold_Medal from OLYMPICS_HISTORY where medal='Gold'
group by name,Team ),
t2 as
(select * ,DENSE_RANK() over (order by Total_Gold_Medal desc) as M_Rank from t1)
select name,team,Total_Gold_Medal from t2 where M_Rank<=5

-------------------------------

--Q(12): Top 5 athletes who have won the most medals (gold/silver/bronze).
    
	with t1 as
            (select name, team, count(1) as total_medals
            from olympics_history
            where medal in ('Gold', 'Silver', 'Bronze')
            group by name, team),
            --order by total_medals desc),
        t2 as
            (select *, dense_rank() over (order by total_medals desc) as rnk
            from t1)
    select name, team, total_medals
    from t2
    where rnk <= 5;


--Q(13): Top 5 most successful countries in olympics. Success is defined by no of medals won.
    
	with t1 as
            (select nr.region, count(1) as total_medals
            from olympics_history oh
            join olympics_history_noc_regions nr on nr.noc = oh.noc
            where medal <> 'NA'
            group by nr.region),
            --order by total_medals desc),
        t2 as
            (select *, dense_rank() over(order by total_medals desc) as rnk
            from t1)
    select *
    from t2
    where rnk <= 5;

--Q(14): List down total gold, silver and broze medals won by each country.

select Distinct Region,
Sum (Case when Medal='Gold' then 1 else 0 end) as Gold,
Sum (Case when Medal='Silver' then 1 else 0 end) as Silver,
Sum (Case when Medal='Bronze' then 1 else 0 end) as Bronze
from OLYMPICS_HISTORY O1
Inner Join OLYMPICS_HISTORY_NOC_REGIONS O2 on O1.NOC=O2.NOC
group by region
Order by 2 desc

--Q(15):List down total gold, silver and broze medals won by each country corresponding to each olympic games.

--(solution-1)

select * from
(select games,region,medal from OLYMPICS_HISTORY o
join OLYMPICS_HISTORY_NOC_REGIONS oh on o.NOC=oh.NOC where medal <>'NA'
) t
pivot(count(medal) for Medal in([Gold],[Silver],[Bronze]))as Pivot_Table
order by 1,region

--(solution-2)

select distinct games,region,
sum(Case when Medal='Gold' then 1 else 0 end) as Gold,
Sum (Case when Medal='Silver' then 1 else 0 end) as Silver,
Sum (Case when Medal='Bronze' then 1 else 0 end) as Bronze
from OLYMPICS_HISTORY O1
Inner Join OLYMPICS_HISTORY_NOC_REGIONS O2 on O1.NOC=O2.NOC
where medal<>'NA'
group by games,region
order by 1, region


--Q(16): Identify which country won the most gold, most silver and most bronze medals in each olympic games.

with t as
(select games, region,
sum(case when Medal='Gold' then 1 else 0 end) as Gold,
sum(case when Medal= 'Silver' then 1 else 0 end) as Silver,
sum(case when Medal= 'Bronze' then 1 else 0 end) as Bronze
from OLYMPICS_HISTORY o join OLYMPICS_HISTORY_NOC_REGIONS oh on
o.NOC=oh.NOC
group by games,region)
select distinct games
, concat(first_value(region) over(partition by games order by gold desc)
, ' - '
, first_value(Gold) over(partition by games order by gold desc)) as Max_Gold
, concat(first_value(region) over(partition by games order by silver desc)
, ' - '
, first_value(Silver) over(partition by games order by silver desc)) as Max_Silver
, concat(first_value(region) over(partition by games order by bronze desc)
, ' - '
, first_value(Bronze) over(partition by games order by bronze desc)) as Max_Bronze
from t
order by games;

--Q(17):Identify which country won the most gold, most silver, most bronze medals and the most medals in each olympic games

with t as
(select games, region,
sum(case when Medal='Gold' then 1 else 0 end) as Gold,
sum(case when Medal= 'Silver' then 1 else 0 end) as Silver,
sum(case when Medal= 'Bronze' then 1 else 0 end) as Bronze,
sum(case when medal<>'NA'then 1 else 0 end)as Medals
from OLYMPICS_HISTORY o join OLYMPICS_HISTORY_NOC_REGIONS oh on
o.NOC=oh.NOC
group by games,region)
select distinct games
, concat(first_value(region) over(partition by games order by gold desc)
, ' - '
, first_value(Gold) over(partition by games order by gold desc)) as Max_Gold
, concat(first_value(region) over(partition by games order by silver desc)
, ' - '
, first_value(Silver) over(partition by games order by silver desc)) as Max_Silver
, concat(first_value(region) over(partition by games order by bronze desc)
, ' - '
, first_value(Bronze) over(partition by games order by bronze desc)) as Max_Bronze
, concat(first_value(region) over(partition by games order by medals desc)
, ' - '
, first_value(Medals) over(partition by games order by medals desc)) as Max_Medals
from t
order by games;



--Q(18): Which countries have never won gold medal but have won silver/bronze medals?

	with t1 as
(select Distinct Region,
Sum (Case when Medal='Gold' then 1 else 0 end) as Gold,
Sum (Case when Medal='Silver' then 1 else 0 end) as Silver,
Sum (Case when Medal='Bronze' then 1 else 0 end) as Bronze
from OLYMPICS_HISTORY O1
Inner Join OLYMPICS_HISTORY_NOC_REGIONS O2 on O1.NOC=O2.NOC
group by region),
T2 as
(select * from t1
where gold=0 and (silver > 0 or Bronze >0))

select * from t2 order by 1

--alternate solution 

select * from
(select region,medal from OLYMPICS_HISTORY o
join OLYMPICS_HISTORY_NOC_REGIONS oh on o.NOC=oh.NOC where medal <>'NA'
) t
pivot(count(medal) for Medal in([Gold],[Silver],[Bronze]))as Pivot_Table
where gold = 0 and (silver > 0 or bronze > 0)
order by region


--Q(19)In which Sport/event, India has won highest medals.

    with t1 as
        	(select sport, count(*) as total_medals
        	from olympics_history
        	where medal <> 'NA'
        	and team = 'India'
        	group by sport),
        	--order by total_medals desc),
        t2 as
        	(select *, rank() over(order by total_medals desc) as rnk
        	from t1)
    select sport, total_medals
    from t2
    where rnk = 1;


--Q(20): Break down all olympic games where india won medal for Hockey and how many medals in each olympic games

    select team, sport, games, count(1) as total_medals
    from olympics_history
    where medal <> 'NA'
    and team = 'India' and sport = 'Hockey'
    group by team, sport, games
    order by total_medals desc;

