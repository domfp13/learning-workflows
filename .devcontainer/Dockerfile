# This is the base image, which has miniconda installed.
# You could use the 'anaconda' base image too; however the docker image 
# size will be large feel free to change it to your needs.
#
# There are 2 versions of the FROM statement.
# - The '--platform=linux/amd64' allows us to work locally, If you have a ARM-based system (e.g. Apple M1 M2...).
#       However, this version has issues when running a streamlit app either in the
#       local(docker) environment and also in a Github Codespace.
#
# - The one without the 'platform' allows you to run streamlit in a Github Codespace,
#       However, this means that streamlit app cannot be developed via the local(docker)
#       environment. 

# This is the base image for the local environment
#FROM --platform=amd64 continuumio/miniconda3:main AS base
FROM continuumio/miniconda3:main AS base
LABEL maintainer="Enrique Plata"
ENV APP_HOME /workspaces/learning-workflows
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Create the application directory
FROM base AS installer
USER root
RUN apt-get update && \
	echo "running in codespace" > /tmp/.is_codespace_env.txt

# Create a non-root user and set the user home directory and makes the user the owner of the application directory
RUN groupadd -r workflow
RUN useradd -m -g workflow -s /bin/bash workflow
RUN mkdir -p $APP_HOME
RUN	chown -R workflow:workflow $APP_HOME

# Switch to the non-root user
USER workflow

# Setting a new Conda environment
FROM installer AS prefect-core
COPY environment.yml /tmp/installation-scripts/
RUN conda create -n workflow-environment python=3.11 -y
SHELL [ "conda", "run", "-n", "workflow-environment", "/bin/bash", "-c" ]
RUN pip install --upgrade pip
RUN pip install -U prefect

# Setting conda init so when logging in the container the conda environment is activated
RUN /opt/conda/bin/conda init bash
FROM prefect-core
USER workflow
# Setting the conda environment based on the environment.yml file
#RUN /opt/conda/bin/conda env update -f /tmp/installation-scripts/environment.yml
