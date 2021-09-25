elixir_version = 1.11.4-otp-23
erlang_version = 23.0

set-elixir-version:
	asdf global elixir $(elixir_version)

set-erlang-version:
	asdf global erlang $(erlang_version)

set-versions: set-erlang-version set-elixir-version

local-api:
	mix phx.server

local-infra:
	docker-compose up -d

local: set-elixir-version set-erlang-version local-infra local-api

test:
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
