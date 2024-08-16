ARG PYTHON_VERSION=3.11
FROM python:${PYTHON_VERSION}-bullseye
LABEL maintainer="Yash Pareek"

RUN pip install poetry && poetry config virtualenvs.create false
WORKDIR /app
COPY pyproject.toml poetry.lock ./
RUN poetry install --only main --no-root --no-interaction && \
    poetry cache clear pypi --all
COPY ./src /app/src
RUN poetry install --only-root

ENTRYPOINT ["python", "-OO", "-m", "house_prices"]
