# use a major version of Python for security updates
# https://hub.docker.com/_/python/tags?name=-slim-
# make sure Python Ver. work with Package Ver. in requirements
FROM python:3.11-slim-bookworm
# # PIN python, chromium and driver version
# FROM superkeyor/python_chromium_driver:latest

# no writing .pyc cache files
ENV PYTHONDONTWRITEBYTECODE=1 
# stdout/stderr straight to terminal without buffering delays
ENV PYTHONUNBUFFERED=1

# Define env var built into an container image (less flexible than docker-compose.yml)
ENV FLASK_ENV=production
ENV TZ=US/Central

# Build-time flag to include cron support (default: off)
# Option 1 - Edit this file: change ARG ENABLE_CRON=false to ARG ENABLE_CRON=true
# Option 2 - Override at build time without editing: docker build --build-arg ENABLE_CRON=true .
ARG ENABLE_CRON=false
ENV ENABLE_CRON=$ENABLE_CRON

RUN apt-get update && \
    if [ "$ENABLE_CRON" = "true" ]; then \
        apt-get install -y tzdata cron; \
    else \
        apt-get install -y tzdata; \
    fi && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

# copy requirements first so pip layer is cached unless requirements.txt changes
COPY requirements.txt .
# --no-cache-dir reduces image size
RUN pip install --no-cache-dir -r requirements.txt

# copy remaining source files
COPY . .

# Install crontab from the project file (only when ENABLE_CRON=true)
RUN if [ "$ENABLE_CRON" = "true" ]; then crontab /app/crontab; fi

# Make port available to the world outside this container
# expose from container to host
EXPOSE 5000

# RUN occurs during building; CMD similar to ENTRYPOINT
CMD ["bash", "/app/start.sh"]
