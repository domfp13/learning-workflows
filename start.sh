#!/bin/sh

# TODO: Research how to pull passwords from AWS Secrets Manager so when the container starts it can login to Prefect Cloud
# Adding commands that should be run when the container starts
prefect cloud login -k $PREFECT_API_KEY

# Creates a new work-pool, if the pool already exists it will skip this command
prefect work-pool create --type docker docker-pool

# Starts a new worker with the specified pool
prefect worker start --pool docker-pool
