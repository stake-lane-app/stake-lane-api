
alias BolaoHubApi.Repo

alias BolaoHubApi.Leagues.League
alias BolaoHubApi.Leagues.ThirdPartyInfo

Repo.insert % League {
  name: "UEFA Champions League",
  country: "World",
  country_code: "World",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 2771,
    },
  ]
}

Repo.insert % League {
  name: "UEFA Europa League",
  country: "World",
  country_code: "World",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 2777,
    },
  ]
}

Repo.insert % League {
  name: "UEFA Euro",
  country: "World",
  country_code: "World",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 403,
    },
  ]
}

Repo.insert % League {
  name: "UEFA Nations League",
  country: "World",
  country_code: "World",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 1422,
    },
  ]
}

Repo.insert % League {
  name: "Premier League",
  country: "England",
  country_code: "GB",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 2790,
    },
  ]
}

Repo.insert % League {
  name: "FA Cup",
  country: "England",
  country_code: "GB",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 2791,
    },
  ]
}

Repo.insert % League {
  name: "EFL Cup",
  country: "England",
  country_code: "GB",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 2781,
    },
  ]
}

Repo.insert % League {
  name: "La Liga",
  country: "Spain",
  country_code: "ES",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 2833,
    },
  ]
}

Repo.insert % League {
  name: "Copa del Rey",
  country: "Spain",
  country_code: "ES",
  season: 2020,
  active: true,
  third_parties_info: []
}

Repo.insert % League {
  name: "Bundesliga",
  country: "Germany",
  country_code: "DE",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 2755,
    },
  ]
}

Repo.insert % League {
  name: "DFB Pokal",
  country: "Germany",
  country_code: "DE",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 2677,
    },
  ]
}

Repo.insert % League {
  name: "Ligue 1",
  country: "France",
  country_code: "FR",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 2664,
    },
  ]
}

Repo.insert % League {
  name: "France Cup",
  country: "France",
  country_code: "FR",
  season: 2020,
  active: true,
  third_parties_info: []
}

Repo.insert % League {
  name: "Serie A",
  country: "Italy",
  country_code: "IT",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 2857,
    },
  ]
}

Repo.insert % League {
  name: "Coppa Italia",
  country: "Italy",
  country_code: "IT",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 2941,
    },
  ]
}

Repo.insert % League {
  name: "Primeira Liga",
  country: "Portugal",
  country_code: "PT",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 2826,
    },
  ]
}

Repo.insert % League {
  name: "Taça de Portugal",
  country: "Portugal",
  country_code: "PT",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 2948,
    },
  ]
}

Repo.insert % League {
  name: "Eredivisie",
  country: "Netherlands",
  country_code: "NL",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 2673,
    },
  ]
}

Repo.insert % League {
  name: "Serie A",
  country: "Brazil",
  country_code: "BR",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 1396,
    },
  ]
}

Repo.insert % League {
  name: "Paulista",
  country: "Brazil",
  country_code: "BR",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 1345,
    },
  ]
}

Repo.insert % League {
  name: "Carioca",
  country: "Brazil",
  country_code: "BR",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 2269,
    },
  ]
}

Repo.insert % League {
  name: "Copa do Brasil",
  country: "Brazil",
  country_code: "BR",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 1333,
    },
  ]
}

Repo.insert % League {
  name: "Campeonato Argentino",
  country: "Argentina",
  country_code: "AR",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 3023,
    },
  ]
}

Repo.insert % League {
  name: "Copa Argentina",
  country: "Argentina",
  country_code: "AR",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 1291,
    },
  ]
}

Repo.insert % League {
  name: "Campeonato Mexicano",
  country: "Mexico",
  country_code: "MX",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 2656,
    },
  ]
}

Repo.insert % League {
  name: "Copa Por Mexico",
  country: "Mexico",
  country_code: "MX",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 2786,
    },
  ]
}

Repo.insert % League {
  name: "Copa Libertadores",
  country: "World",
  country_code: "World",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 1251,
    },
  ]
}

Repo.insert % League {
  name: "Copa America",
  country: "World",
  country_code: "World",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 1321,
    },
  ]
}

Repo.insert % League {
  name: "African Nations Championship",
  country: "World",
  country_code: "World",
  season: 2020,
  active: true,
  third_parties_info: [
    %ThirdPartyInfo {
      api: "api_football",
      league_id: 1030,
    },
  ]
}

