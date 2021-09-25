
alias StakeLaneApi.Repo

alias StakeLaneApi.Football.League
alias StakeLaneApi.Football.League.ThirdPartyInfo
alias StakeLaneApi.Countries.Country

Repo.insert % Country { name: "World", code: "World" }
Repo.insert % Country { name: "England", code: "GB" }
Repo.insert % Country { name: "Spain", code: "ES" }
Repo.insert % Country { name: "Germany", code: "DE" }
Repo.insert % Country { name: "France", code: "FR" }
Repo.insert % Country { name: "Italy", code: "IT" }
Repo.insert % Country { name: "Portugal", code: "PT" }
Repo.insert % Country { name: "Netherlands", code: "NL" }
Repo.insert % Country { name: "Brazil", code: "BR" }
Repo.insert % Country { name: "Argentina", code: "AR" }
Repo.insert % Country { name: "Mexico", code: "MX" }

Repo.insert % League {
  name: "UEFA Champions League",
  country_id: (Repo.get_by(Country, name: "World")).id,
  season: 2021,
  active: true,
  third_parties_info: [ %ThirdPartyInfo { api: "api_football", league_id: 3431 } ]
}

Repo.insert % League {
  name: "Premier League",
  country_id: (Repo.get_by(Country, name: "England")).id,
  season: 2021,
  active: true,
  third_parties_info: [ %ThirdPartyInfo { api: "api_football", league_id: 3456 } ]
}

Repo.insert % League {
  name: "La Liga",
  country_id: (Repo.get_by(Country, name: "Spain")).id,
  season: 2021,
  active: true,
  third_parties_info: [ %ThirdPartyInfo { api: "api_football", league_id: 3513 } ]
}

Repo.insert % League {
  name: "Bundesliga",
  country_id: (Repo.get_by(Country, name: "Germany")).id,
  season: 2021,
  active: true,
  third_parties_info: [ %ThirdPartyInfo { api: "api_football", league_id: 3510 } ]
}

Repo.insert % League {
  name: "Ligue 1",
  country_id: (Repo.get_by(Country, name: "France")).id,
  season: 2021,
  active: true,
  third_parties_info: [ %ThirdPartyInfo { api: "api_football", league_id: 3506 } ]
}

Repo.insert % League {
  name: "Serie A",
  country_id: (Repo.get_by(Country, name: "Italy")).id,
  season: 2021,
  active: true,
  third_parties_info: [ %ThirdPartyInfo { api: "api_football", league_id: 3576 } ]
}

Repo.insert % League {
  name: "Primeira Liga",
  country_id: (Repo.get_by(Country, name: "Portugal")).id,
  season: 2021,
  active: true,
  third_parties_info: [ %ThirdPartyInfo { api: "api_football", league_id: 3575 } ]
}

Repo.insert % League {
  name: "Eredivisie",
  country_id: (Repo.get_by(Country, name: "Netherlands")).id,
  season: 2021,
  active: true,
  third_parties_info: [ %ThirdPartyInfo { api: "api_football", league_id: 3437 } ]
}

Repo.insert % League {
  name: "Serie A",
  country_id: (Repo.get_by(Country, name: "Brazil")).id,
  season: 2021,
  active: true,
  third_parties_info: [ %ThirdPartyInfo { api: "api_football", league_id: 3364 } ]
}

Repo.insert % League {
  name: "Paulista",
  country_id: (Repo.get_by(Country, name: "Brazil")).id,
  season: 2021,
  active: true,
  third_parties_info: [ %ThirdPartyInfo { api: "api_football", league_id: 3097 } ]
}

Repo.insert % League {
  name: "Campeonato Argentino",
  country_id: (Repo.get_by(Country, name: "Argentina")).id,
  season: 2021,
  active: true,
  third_parties_info: [ %ThirdPartyInfo { api: "api_football", league_id: 3265 } ]
}

Repo.insert % League {
  name: "Campeonato Mexicano",
  country_id: (Repo.get_by(Country, name: "Mexico")).id,
  season: 2021,
  active: true,
  third_parties_info: [ %ThirdPartyInfo { api: "api_football", league_id: 3517 } ]
}

Repo.insert % League {
  name: "Copa Libertadores",
  country_id: (Repo.get_by(Country, name: "World")).id,
  season: 2021,
  active: true,
  third_parties_info: [ %ThirdPartyInfo { api: "api_football", league_id: 3273 } ]
}
