# Using the specific version of Prefect with Python 3.10
FROM prefecthq/prefect:2-python3.10 as base
ENV APP_HOME=/opt/prefect

# Add our requirements.txt file to the image and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt --trusted-host pypi.python.org --no-cache-dir

FROM base as executable
# Copy the start.sh script to the image
COPY start.sh ${APP_HOME}/start.sh
# Make the start.sh script executable
RUN chmod +x ${APP_HOME}/start.sh

# Add our flow code to the image
COPY flows ${APP_HOME}/flows

WORKDIR ${APP_HOME}

# Run the start.sh script when the container starts
CMD ["/bin/bash", "./start.sh"]