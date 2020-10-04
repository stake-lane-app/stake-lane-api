# BolaoHubApi

To start your Phoenix server:

  * Setup the project with `mix setup`
  * Start Phoenix endpoint with `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

  * Pow only api: https://hexdocs.pm/pow/api.html


## Translations

* How to get the info from the code to the template .pot:
  `mix gettext.extract`
* How to get the info from the template .pot to the files .po:
  `mix gettext.merge priv/gettext`
* Compile it:
  `mix compile.gettext `

## How to Migrate/Seed remote environment
1. At instances tab on App Engine dashboard, clik on the SSH option and the the gcloud command to visit the current version
(Example: `gcloud app instances ssh "aef-default-0--1--5-jkhw" --service "default" --version "0-1-5" --project "bolao-hub"`)

2. Run the command to entry on the container
(Example: `docker exec -it gaeapp bash`)

3. Fire the Migration/Seed command [Distillery Tutorial](https://hexdocs.pm/distillery/guides/running_migrations.html)
(Example: `bin/bolao_hub_api migrate`)


## How to Connect on Cloud SQL Locally
1. After donwload the CLI `cloud_sql_proxy`
2. Fire the command: `./cloud_sql_proxy -instances={{CONNECTION_NAME}}=tcp:5432`
<!-- ./cloud_sql_proxy -instances=bolao-hub:europe-west1:bolao-hub-dev=tcp:5432 -->
