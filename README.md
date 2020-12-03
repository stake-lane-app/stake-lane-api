# StakeLaneApi

To start your Phoenix server:
  * Setup the project with `mix setup`
  * Start Phoenix endpoint with `mix phx.server`


## Translations

![Badge](https://img.shields.io/poeditor/progress/392205/en?style=for-the-badge&token=2a41a13d502e1ad13f7499ac1b21d842)

![Badge](https://img.shields.io/poeditor/progress/392205/pt-br?style=for-the-badge&token=2a41a13d502e1ad13f7499ac1b21d842)

![Badge](https://img.shields.io/poeditor/progress/392205/es?style=for-the-badge&token=2a41a13d502e1ad13f7499ac1b21d842)

* How to get the info from the code to the template .pot:
  `mix gettext.extract`
* How to get the info from the template .pot to the files .po:
  `mix gettext.merge priv/gettext`
* Compile it:
  `mix compile.gettext`

## How to Migrate/Seed remote environment
1. At instances tab on App Engine dashboard, clik on the SSH option and the the gcloud command to visit the current version
(Example: `gcloud app instances ssh "aef-default-0--1--5-jkhw" --service "default" --version "0-1-5" --project "bolao-hub"`)

2. Run the command to entry on the container
(Example: `docker exec -it gaeapp bash`)

3. Fire the Migration/Seed command [Distillery Tutorial](https://hexdocs.pm/distillery/guides/running_migrations.html)
(Example: `bin/stake_lane_api migrate`)


## How to Connect on Cloud SQL Locally
1. After donwload the CLI `cloud_sql_proxy`
2. Fire the command: `./cloud_sql_proxy -instances={{CONNECTION_NAME}}=tcp:5432`
<!-- ./cloud_sql_proxy -instances=bolao-hub:europe-west1:bolaohub-dev=tcp:5432 -->


<!--
  curl --location --request GET 'https://v2.api-football.com/status' --header 'X-RapidAPI-Key: 686819f61ee767103c876669418c2156'
-->
