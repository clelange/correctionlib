FROM python:3.11-slim as builder

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update && \
    apt-get install -y --no-install-recommends build-essential

RUN addgroup --system app && adduser --system --group app
USER app
WORKDIR /app

RUN python -m venv /app/.venv
ENV PATH="/app/.venv/bin:$PATH"

RUN pip install --no-cache-dir -U pip && \
    pip install correctionlib


FROM python:3.11-slim

RUN addgroup --system app && adduser --system --group app
USER app
WORKDIR /app

COPY --from=builder /app/.venv /app/.venv
COPY correctionlib-env /app/correctionlib-env

ENV PATH="/app/.venv/bin:$PATH"

CMD [ "/bin/bash" ]
