
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
  name: "Copa do Brasil",
  country_id: (Repo.get_by(Country, name: "Brazil")).id,
  season: 2022,
  active: true,
  third_parties_info: [ %ThirdPartyInfo { api: "api_football", league_id: 4111 } ]
}

Repo.insert % League {
  name: "Sudamericana",
  country_id: (Repo.get_by(Country, name: "World")).id,
  season: 2022,
  active: true,
  third_parties_info: [ %ThirdPartyInfo { api: "api_football", league_id: 4057 } ]
}

Repo.insert % League {
  name: "Nations League",
  country_id: (Repo.get_by(Country, name: "World")).id,
  season: 2022,
  active: true,
  third_parties_info: [ %ThirdPartyInfo { api: "api_football", league_id: 4260 } ]
}

Repo.insert % League {
  name: "World Cup",
  country_id: (Repo.get_by(Country, name: "World")).id,
  season: 2022,
  active: true,
  third_parties_info: [ %ThirdPartyInfo { api: "api_football", league_id: 4265 } ]
}

Repo.insert % League {
  name: "Primera Division",
  country_id: (Repo.get_by(Country, name: "Argentina")).id,
  season: 2022,
  active: true,
  third_parties_info: [ %ThirdPartyInfo { api: "api_football", league_id: 4134 } ]
}
