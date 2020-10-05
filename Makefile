
run-local:
	MIX_ENV=local mix phx.server

deploy-dev:
	gcloud app deploy --quiet

# TO DO: Add deploy-prod and app.yaml by env