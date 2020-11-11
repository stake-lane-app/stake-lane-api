#!/bin/sh

release_ctl eval --mfa "StakeLaneApi.Helpers.ReleaseTasks.migrate/1" --argv -- "$@"
