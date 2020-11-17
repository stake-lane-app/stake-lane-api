defmodule StakeLaneApi.Factory do
  # with Ecto
  use ExMachina.Ecto, repo: StakeLaneApi.Repo
  alias StakeLaneApi.Football

  def user_factory do
    %StakeLaneApi.Users.User{
      first_name: "Sir",
      last_name: "Test",
      user_name: sequence(:user_name, &"user-#{&1}"),
      email: sequence(:email, &"email-#{&1}@test.com"),
      role: "user",
    }
  end

  def country_factory do
    %StakeLaneApi.Countries.Country{
      name: sequence(:name, &"country-#{&1}"),
      code: "TL",
    }
  end

  def league_factory do
    %Football.League{
      name: sequence(:name, &"league-#{&1}"),
      season: 2020,
      season_start: ~D[2020-07-01],
      season_end: ~D[2021-04-01],
      active: true,
      country: build(:country),
      third_parties_info: [
        %Football.League.ThirdPartyInfo{
          api: "test_third_api",
          league_id: 1,
          respectness: 0,
        }
      ]
    }
  end

  def team_factory do
    %Football.Team{
      name: sequence(:name, &"team-#{&1}"),
      full_name: "Full Name Football Club",
      logo: "",
      is_national: false,
      founded: 1882,
      country: build(:country),
      venue: %Football.Team.Venue{
        name: "Stadium Name",
        surface: "grass",
        address: "North Test, TL",
        city: "Testcity",
        capacity: 150000,
      },
      third_parties_info: [
        %Football.Team.ThirdPartyInfo{
          api: "test_third_api",
          team_id: 1,
          respectness: 0,
        }
      ],
    }
  end

  def fixture_factory do
    now = Timex.now("UTC")
    %Football.Fixture{
      goals_home_team: nil,
      goals_away_team: nil,
      starts_at_iso_date: now,
      event_timestamp: now |> Timex.to_unix(),
      status_code: Football.Fixture.Status.fixtures_status()[:not_started][:code],
      elapsed: nil,
      venue: nil,
      referee: nil,

      league: build(:league),
      home_team: build(:team),
      away_team: build(:team),
      score: %Football.Fixture.Score{},

      third_parties_info: [
        %Football.Fixture.ThirdPartyInfo{
          api: "test_third_api",
          fixture_id: 1,
          league_id: 1,
          respectness: 0,
        }
      ],
    }
  end

  def past_fixture_factory do
    yesterday = Timex.now("UTC") |> Timex.shift(days: -1)
    %Football.Fixture{
      goals_home_team: 2,
      goals_away_team: 1,
      starts_at_iso_date: yesterday,
      event_timestamp: yesterday |> Timex.to_unix(),
      status_code: Football.Fixture.Status.fixtures_status()[:finished][:code],
      elapsed: 90,
      venue: "Some Venue",
      referee: "Some Referee",
      league: build(:league),
      home_team: build(:team),
      away_team: build(:team),
      score: %Football.Fixture.Score{
        halftime: "0-1",
        fulltime: "2-1",
        extratime: nil,
        penalty: nil
      },

      third_parties_info: [
        %Football.Fixture.ThirdPartyInfo{
          api: "test_third_api",
          fixture_id: 1,
          league_id: 1,
          respectness: 0,
        }
      ],
    }
  end

  def user_league_factory do
    %StakeLaneApi.Links.UserLeague{
      blocked: false,
      league: build(:league),
      user: build(:user),
    }
  end

end
