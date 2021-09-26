select
	u.user_name as user_name,
	league.name as league,
	CONCAT (home.name , ' x ', away.name) AS "Teams",
	CONCAT (prediction.home_team , 'x', prediction.away_team) AS "Prediction",
	CONCAT (fixture.goals_home_team , 'x', fixture.goals_away_team) AS "Scoreboard",
	prediction.score,
	prediction.finished,
	fixture.starts_at_iso_date
from predictions prediction
inner join fixtures fixture on fixture.id = prediction.fixture_id
inner join leagues league on league.id = fixture.league_id
inner join teams home on home.id = fixture.home_team_id
inner join teams away on away.id = fixture.away_team_id
inner join users u on u.id = prediction.user_id
order by
	fixture.starts_at_iso_date asc;
