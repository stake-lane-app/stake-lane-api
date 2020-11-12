defmodule StakeLaneApiWeb.Router do
  use StakeLaneApiWeb, :router
  use Pow.Phoenix.Router
  use PowAssent.Phoenix.Router

  pipeline :api do
    plug :accepts, ["json"]
    plug StakeLaneApiWeb.APIAuthPlug, otp_app: :stake_lane_api
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: StakeLaneApiWeb.APIAuthErrorHandler
  end

  scope "/api/v1", StakeLaneApiWeb.V1, as: :api_v1 do
    pipe_through :api

    resources "/registration", RegistrationController, singleton: true, only: [:create]
    resources "/session", SessionController, singleton: true, only: [:create, :delete]
    post "/session/renew", SessionController, :renew

    get "/auth/:provider/new", AuthorizationController, :new
    post "/auth/:provider/callback", AuthorizationController, :callback
  end

  scope "/api/v1", StakeLaneApiWeb.V1, as: :api_v1 do
    pipe_through [:api, :protected]

    resources "/leagues", League.LeaguesController, only: [:index]
    resources "/leagues/my", League.MyLeaguesController, only: [:create, :index]
    resources "/leagues/my/fixtures", League.MyLeaguesFixturesController, only: [:index]

    resources "/fixtures/my", League.MyFixturesController, only: [:index]
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]
      live_dashboard "/dashboard", metrics: StakeLaneApiWeb.Telemetry
    end
  end
end
