#!/bin/sh

# Adding commands that should be run when the container starts
prefect cloud login -k $PREFECT_API_KEY

# Creates a new work-pool, if the pool already exists it will skip this command
prefect work-pool create --type docker my-docker-pool

# Starts a new worker with the specified pool
prefect worker start --pool my-docker-pool
