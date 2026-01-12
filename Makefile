elixir_version = 1.13.4-otp-23
erlang_version = 23.0

set-elixir-version:
	asdf global elixir $(elixir_version)

set-erlang-version:
	asdf global erlang $(erlang_version)

set-versions: set-erlang-version set-elixir-version

local-api:
	mix phx.server

console:
	iex -S mix phx.server

local-infra:
	docker-compose up -d

local: set-versions local-infra local-api

interactive-session:
	iex -S mix phx.server

test: set-versions local-infra
	mix test

deploy-dev:
	gcloud app deploy --quiet

test-coverage:
	MIX_ENV=test mix coveralls.html

translations:
	mix gettext.extract
	mix gettext.merge priv/gettext
	mix compile.gettext

# TO DO: Add deploy-prod and app.yaml by env

asdf-setup:
	asdf plugin add elixir
	asdf install elixir $(elixir_version)
	asdf plugin add erlang
	asdf install erlang $(erlang_version)