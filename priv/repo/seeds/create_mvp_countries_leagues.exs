
alias BolaoHubApi.Repo

alias BolaoHubApi.Leagues.League
alias BolaoHubApi.Leagues.ThirdPartyInfo
alias BolaoHubApi.Countries.Country

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
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 2771 },
  ]
}

Repo.insert % League {
  name: "UEFA Europa League",
  country_id: (Repo.get_by(Country, name: "World")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 2777 },
  ]
}

Repo.insert % League {
  name: "UEFA Euro",
  country_id: (Repo.get_by(Country, name: "World")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 403 },
  ]
}

Repo.insert % League {
  name: "UEFA Nations League",
  country_id: (Repo.get_by(Country, name: "World")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 1422 },
  ]
}

Repo.insert % League {
  name: "Premier League",
  country_id: (Repo.get_by(Country, name: "England")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 2790 },
  ]
}

Repo.insert % League {
  name: "FA Cup",
  country_id: (Repo.get_by(Country, name: "England")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 2791 },
  ]
}

Repo.insert % League {
  name: "EFL Cup",
  country_id: (Repo.get_by(Country, name: "England")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 2781 },
  ]
}

Repo.insert % League {
  name: "La Liga",
  country_id: (Repo.get_by(Country, name: "Spain")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 2833 },
  ]
}

Repo.insert % League {
  name: "Copa del Rey",
  country_id: (Repo.get_by(Country, name: "Spain")).id,
  season: 2020,
  active: true,
  third_parties_info: []
}

Repo.insert % League {
  name: "Bundesliga",
  country_id: (Repo.get_by(Country, name: "Germany")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 2755 },
  ]
}

Repo.insert % League {
  name: "DFB Pokal",
  country_id: (Repo.get_by(Country, name: "Germany")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 2677 },
  ]
}

Repo.insert % League {
  name: "Ligue 1",
  country_id: (Repo.get_by(Country, name: "France")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 2664 },
  ]
}

Repo.insert % League {
  name: "France Cup",
  country_id: (Repo.get_by(Country, name: "France")).id,
  season: 2020,
  active: true,
  third_parties_info: []
}

Repo.insert % League {
  name: "Serie A",
  country_id: (Repo.get_by(Country, name: "Italy")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 2857 },
  ]
}

Repo.insert % League {
  name: "Coppa Italia",
  country_id: (Repo.get_by(Country, name: "Italy")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 2941 },
  ]
}

Repo.insert % League {
  name: "Primeira Liga",
  country_id: (Repo.get_by(Country, name: "Portugal")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 2826 },
  ]
}

Repo.insert % League {
  name: "Taça de Portugal",
  country_id: (Repo.get_by(Country, name: "Portugal")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 2948 },
  ]
}

Repo.insert % League {
  name: "Eredivisie",
  country_id: (Repo.get_by(Country, name: "Netherlands")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 2673 },
  ]
}

Repo.insert % League {
  name: "Serie A",
  country_id: (Repo.get_by(Country, name: "Brazil")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 1396 },
  ]
}

Repo.insert % League {
  name: "Paulista",
  country_id: (Repo.get_by(Country, name: "Brazil")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 1345 },
  ]
}

Repo.insert % League {
  name: "Carioca",
  country_id: (Repo.get_by(Country, name: "Brazil")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 2269 },
  ]
}

Repo.insert % League {
  name: "Copa do Brasil",
  country_id: (Repo.get_by(Country, name: "Brazil")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 1333 },
  ]
}

Repo.insert % League {
  name: "Campeonato Argentino",
  country_id: (Repo.get_by(Country, name: "Argentina")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 3023 },
  ]
}

Repo.insert % League {
  name: "Copa Argentina",
  country_id: (Repo.get_by(Country, name: "Argentina")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 1291 },
  ]
}

Repo.insert % League {
  name: "Campeonato Mexicano",
  country_id: (Repo.get_by(Country, name: "Mexico")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 2656 },
  ]
}

Repo.insert % League {
  name: "Copa Por Mexico",
  country_id: (Repo.get_by(Country, name: "Mexico")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 2786 },
  ]
}

Repo.insert % League {
  name: "Copa Libertadores",
  country_id: (Repo.get_by(Country, name: "World")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 1251 },
  ]
}

Repo.insert % League {
  name: "Copa America",
  country_id: (Repo.get_by(Country, name: "World")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 1321 },
  ]
}

Repo.insert % League {
  name: "African Nations Championship",
  country_id: (Repo.get_by(Country, name: "World")).id,
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo { api: "api_football", league_id: 1030 },
  ]
}
