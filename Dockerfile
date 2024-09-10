# Use an official Python runtime as a parent image
ARG PYTHON_VERSION=3.11
FROM python:${PYTHON_VERSION}-bullseye

# Set the maintainer label
LABEL maintainer="Yash Pareek"

# Install Poetry and configure it to not use virtual environments
RUN pip install poetry && poetry config virtualenvs.create false

# Set the working directory inside the container
WORKDIR /app

# Copy dependency management files to the container
COPY pyproject.toml poetry.lock ./

# Install only the main dependencies specified in pyproject.toml
RUN poetry install --only main --no-root --no-interaction && \
    poetry cache clear pypi --all

# Copy the source code to the container
COPY ./src /app/src

# Install the root package (this step assumes your root package is needed for the module to run)
RUN poetry install --only-root

# Expose port 80 to allow external connections (if your application serves web traffic)
EXPOSE 80

# Define the entry point for the container
ENTRYPOINT ["python", "-OO", "-m", "house_prices"]

# CMD can be used to override default behavior, but since you already set ENTRYPOINT, 
# there's no need to define CMD unless you have additional runtime commands.
