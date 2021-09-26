select
	country.name as country,
	league.name as league,
	home.name as home_team,
	away.name as away_team,
	f.elapsed,
	goals_home_team,
	goals_away_team,
	f.status_code,
	now() + (-5::decimal::numeric * interval '1 hour') as matches_from,
	f.starts_at_iso_date,
	now() + (15::decimal::numeric * interval '1 minute') as matches_to,
	f.*
from fixtures f
inner join teams home on home.id = f.home_team_id
inner join teams away on away.id = f.away_team_id
inner join leagues league on league.id = f.league_id
inner join countries country on country.id = league.country_id
where
	f.status_code not in ('FT', 'AET', 'PEN')
	and f.starts_at_iso_date < now()  + (15::decimal::numeric * interval '1 minute')
	and f.starts_at_iso_date > now() + (-5::decimal::numeric * interval '1 hour')
order by
	f.elapsed desc,
	f.updated_at desc;



