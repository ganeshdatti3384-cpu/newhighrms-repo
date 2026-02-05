# ---------- Builder ----------
FROM python:3.10-slim-bullseye AS builder

ENV PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    libcairo2-dev \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY requirements.txt .
RUN pip install --prefix=/install -r requirements.txt


# ---------- Runtime ----------
FROM python:3.10-slim-bullseye

ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1

RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq5 \
    libcairo2 \
    bash \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /install /usr/local
COPY . .

RUN chmod +x /app/entrypoint.sh

EXPOSE 8000

CMD ["/bin/bash", "/app/entrypoint.sh"]


# FROM python:3.10-slim-bullseye AS builder

# ENV PYTHONUNBUFFERED=1

# RUN apt-get update && apt-get install -y --no-install-recommends libcairo2-dev gcc && rm -rf /var/lib/apt/lists/*

# WORKDIR /app/

# COPY requirements.txt .
# RUN pip install --no-cache-dir --prefix=/install -r requirements.txt

# FROM python:3.10-slim-bullseye AS runtime

# ENV PYTHONUNBUFFERED=1

# WORKDIR /app/

# COPY --from=builder /install /usr/local

# COPY . .

# RUN chmod +x /app/entrypoint.sh

# EXPOSE 8000

# CMD ["python3", "manage.py", "runserver"]
