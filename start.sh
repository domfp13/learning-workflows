#!/bin/sh

# Adding commands that should be run when the container starts
prefect cloud login -k $PREFECT_API_KEY
prefect worker start --pool 'my-ec2-pool' --type docker

# Run our flow script when the container starts
# CMD ["/bin/sh", "-c", "pip install prefect-aws && prefect worker start --pool my-ec2-pool --type ec2"]
