# Using the specific version of Prefect with Python 3.10
FROM prefecthq/prefect:2-python3.10
ENV APP_HOME=/opt/prefect/flows

# Add our requirements.txt file to the image and install dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt --trusted-host pypi.python.org --no-cache-dir

# Copy the start.sh script to the image
COPY start.sh /start.sh
# Make the start.sh script executable
RUN chmod +x /start.sh

# Run the start.sh script when the container starts
CMD ["/bin/bash", "/start.sh"]

# Add our flow code to the image
COPY flows /opt/prefect/flows

WORKDIR ${APP_HOME}
