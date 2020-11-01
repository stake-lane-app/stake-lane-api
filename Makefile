
local-api:
	mix phx.server

local-infra:
	docker-compose up -d

deploy-dev:
	gcloud app deploy --quiet

# TO DO: Add deploy-prod and app.yaml by env