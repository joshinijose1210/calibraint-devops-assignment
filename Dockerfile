FROM python:3.12.4-slim-bookworm AS builder

RUN apt-get update && \
    apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /build

COPY app/requirements.txt .

RUN pip install --no-cache-dir \
    --prefix=/install \
    -r requirements.txt

FROM python:3.12.4-slim-bookworm

RUN apt-get update && \
    apt-get upgrade -y && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -r appuser && \
    useradd -r -g appuser appuser

WORKDIR /app

COPY --from=builder /install /usr/local
COPY app/ .

USER appuser

EXPOSE 8080

CMD ["gunicorn","-w","2","-b","0.0.0.0:8080","main:app"]
