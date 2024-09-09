
select * from [dbo].[athlete_events]
--1.hoe many olympic games have een held--

select count( distinct games) from [dbo].[athlete_events] 

--2.list down all olympic games held so for--

select  distinct year,season,city
from [dbo].[athlete_events]
order by year asc                   

--3.mention the total no of nations who participated in each olympic game

select  games,count( distinct team) as countries
from [dbo].[athlete_events]
group by games
order by games asc            

--4.which year saw highest and lowest no of countries participating in olympics

select games, count(distinct team) 
from [dbo].[athlete_events]
group by Games
order by 2 desc

--5. which nation has participated in all of the olmpic games

select team,count( distinct Games) as total_particepated_games
from [dbo].[athlete_events]
group by Team
order by 2 desc

--6.identify th sport which was played in all summer olympic games

select  distinct season,Sport
from [dbo].[athlete_events]
where Season='summer'


--7.which sports were just played once in the olympics

with cte as
(select sport,count(distinct games) as 'total_game'
from [dbo].[athlete_events]
group by sport
having count(distinct games)=1),
cte2 as 
(select games,sport,count(distinct games) as 'total_game'
from [dbo].[athlete_events]
group by sport,games
having count(distinct games)=1)
select c.sport,d.total_game,d.games from cte c
join cte2 d
on c.sport=d.sport

--8.fetch the total no of sports played in each olympic games

select  Games,count( distinct sport) 
from [dbo].[athlete_events]
group by Games 
order by Games desc

--9. fetch details of the oldest athelete to win a gold medal



select * from [dbo].[athlete_events]
where medal='gold' and age=( select max(age) from [dbo].[athlete_events] where medal='gold') 


--10.find the ratio of male and female atheletes participated in all olympic games

with cte as
( select games,count(sex) as male
from [dbo].[athlete_events]
where sex = 'm'
group by games
),
cte2 as
(select games, count(sex) as female
from [dbo].[athlete_events]
where sex = 'f'
group by games
)
select c.games,c.male,n.female from cte c
join cte2 n 
on c.games=n.games

--11.fetch top 5 athelete who have won the most gold medals

select top 5 name,count(medal) as most_medals from [dbo].[athlete_events]
where medal='gold'
group by name
order by 2 desc

--12.fetch top 5 athelete who have won most medals(gold/silver/bronze)

select top 5 name,count(medal) from [dbo].[athlete_events]
where medal in ('Gold','Silver','Bronze')
group by name
order by 2 desc

--13.fetch the top 5 most successful countries in olympics .success is defined by no of medals won

select top 5 Team,count(medal) from [dbo].[athlete_events]
where medal in ('Gold','Silver','Bronze')
group by Team
order by 2 desc

--14.list down total gold,silver and brozen won each country
with cte as
(select team,count(medal) as gold from [dbo].[athlete_events]
where medal='gold'
group by team),
cte2 as
(select team,count(medal)  as silver from [dbo].[athlete_events]
where medal='silver'
group by team),
cte3 as
(select team,count(medal) as bronze from [dbo].[athlete_events]
where medal='bronze'
group by team)

select a.team,a.gold,b.silver,c.bronze from cte a
join cte2 b
on a.team=b.team
join cte3 c
on a.team=c.team
order by a.gold desc,b.silver desc,c.bronze desc

--15.list down total gold,silver and bronzen won by each country corresponding to olympics

with cte as
(select  games,team,count(medal) as gold from [dbo].[athlete_events]
where medal='gold'
group by team,games),
cte2 as
(select distinct games,team,count(medal) as silver from [dbo].[athlete_events]
where medal='silver'
group by games,team),
cte3 as
(select distinct games,team,count(medal) as bronze from [dbo].[athlete_events]
where medal='bronze'
group by games,Team)
select distinct a.games,b.team,a.gold,b.silver,c.bronze from cte a
join cte2 b
on a.Games=b.Games
join cte3 c
on a.games=c.games


--16.identify which country won the most gold,most silver, most bronzen medals in each olympic games
with cte as
(select games,team ,count(medal) as total_gold from [dbo].[athlete_events]
where medal='gold'
group by games,team),
cte2 as
(select games,team,count(medal) as total_silver from [dbo].[athlete_events]
where medal='silver'
group by games,team),
cte3 as
(select games,team,count(medal) as total_bronze from [dbo].[athlete_events]
where medal='bronze'
group by games,team),
x as
(select g.games,g.team,concat(g.team,'-',g.total_gold) as 'gold',
dense_rank() over(partition by g.games order by g.total_gold desc) as 'rank'  from cte g),

y as
(select s.games,s.team,concat(s.team,'-',s.total_silver) as 'silver',
dense_rank() over(partition by s.games order by s.total_silver desc) as 'rank' from cte2 s),

z as
(select b.games,b.team,concat(b.team,'-',b.total_bronze) as 'bronze',
dense_rank() over(partition by b.games order by b.total_bronze desc) as 'rank' from cte3 b)

select x.games,x.gold,y.silver,z.bronze from x
join  y
on x.games=y.games and x.rank=1 and y.rank=1
join z
on x.games=z.games and x.rank=1 and z.rank=1

--17.identify which country won the most gold,most silver,most bronze medals and the most medals in each olymoic games

with cte as
(select games,team,count(medal)as total_gold from [dbo].[athlete_events]
where medal='gold'
group by games,team),
cte2 as
(select games,team,count(medal) as total_silver from [dbo].[athlete_events]
where medal='silver'
group by games,team),
cte3 as
(select games,team,count(medal) as total_bronze from [dbo].[athlete_events]
where medal='bronze'
group by games,team),
cte4 as
(select games,team,count(medal) as 'high'  from [dbo].[athlete_events]
where medal in('gold','silver','bronze')
group by games,team),

x as
(select g.games,g.team,concat(g.team,'-',g.total_gold) as 'gold',
dense_rank() over(partition by g.games order by g.total_gold desc) as 'rank' from cte g),

y as 
(select s.games,s.team,concat(s.team,'-',s.total_silver )as 'silver',
dense_rank() over(partition by s.games order by s.total_silver desc )as 'rank' from cte2 s),

z as
(select b.games,b.team,concat(b.team,'-',b.total_bronze)as 'bronze',
dense_rank() over (partition by b.games order by b.total_bronze desc) as 'rank' from cte3 b),

h as
(select h.games,h.team,concat(h.team,'-',h.high) as highest,
dense_rank() over( partition by h.games order by h.high desc) as 'rank' from cte4 h)

select x.games,x.gold,y.silver,z.bronze from x
join y
on x.games=y.games and x.rank=1 and y.rank=1
join z
on x.games=z.games and x.rank=1 and z.rank=1
join  h 
on x.games=h.games and x.rank=1 and h.rank=1

--18.which country has not won gold but won silver/bronze medals

with cte as
(select games,team, count(medal) from [dbo].[athlete_events]
where Medal='gold'
group by Games,Team),
cte2 as
(select games,team,count(medal) from [dbo].[athlete_events]
where medal='silver'
group by games,team),
cte3 as
(select games,team,count(medal) from [dbo].[athlete_events]
where medal='bronze'
group by games,team)

select g.games,g.team,g.gold,s.silver,b.bronze from cte g
join cte2 s
on g.games=s.games and g.gold=0
join cte3 b
on g.games=b.Games and g.gold=0

--19.in which sport/event india has won highest medals
select top 1 games,sport,event,count(medal) from [dbo].[athlete_events]
where team = 'india'
group by games,sport,event
order by 4 desc

--20.break down all olympic games where india won medals for hockey and how mny medals in each olympic games
select games,sport,event, count(medal) as medals from [dbo].[athlete_events]
where sport='hockey'
group by games,Sport,event























