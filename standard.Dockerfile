FROM python:3.9-slim-buster
RUN apt-get update && apt-get install -y gcc libcurl4-openssl-dev libssl-dev && rm -rf /var/lib/apt/lists/*
RUN pip install --no-cache-dir --upgrade pip
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
COPY config/settings/* .
CMD ["celery", "-A", "config.tasks", "worker", "-B", "-n", "pc11-SD-API", "--pool=prefork", "--loglevel=info", "--concurrency=10", "-E"]

