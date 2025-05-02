FROM python:3.12.10-alpine3.20

ENV PYTHONUNBUFFERED=1

LABEL maintainer="hassanali.tech25@gmail.com"

WORKDIR /app
COPY ./app .
COPY requirements.txt /tmp/requirements.txt
COPY requirements.dev.txt /tmp/requirements-dev.txt
EXPOSE 8000

ARG DEV=false

RUN apk add --no-cache --virtual .build-deps \
        postgresql-dev \
        gcc \
        musl-dev \
        python3-dev \
        openblas-dev \
        lapack-dev && \
    apk add --no-cache openblas && \
    python -m venv /env && \
    . /env/bin/activate && \
    pip install --upgrade pip && \
    pip install -r /tmp/requirements.txt && \
    if [ "$DEV" = true ]; then \
        pip install -r /tmp/requirements-dev.txt; \
    fi && \
    rm -rf /root/.cache && \
    rm -rf /tmp/requirements.txt && \
    apk del .build-deps && \
    adduser \
        --disabled-password \
        --no-create-home \
        django-user

ENV PATH="/env/bin:$PATH"

USER django-user