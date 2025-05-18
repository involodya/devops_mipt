FROM python:3.9-alpine

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app
COPY requirements.txt .

RUN apk add --no-cache postgresql-libs && \
    apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev && \
    pip install --no-cache-dir -r requirements.txt && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/* /root/.cache/pip/*

COPY app.py ./

RUN echo '#!/bin/sh' > /app/entrypoint.sh && \
    echo 'set -e' >> /app/entrypoint.sh && \
    echo 'python -c "from app import wait_for_db, initialize_database; wait_for_db() and initialize_database()"' >> /app/entrypoint.sh && \
    echo 'exec flask run --host=0.0.0.0' >> /app/entrypoint.sh && \
    chmod +x /app/entrypoint.sh && \
    chown -R appuser:appgroup /app

USER appuser

ENV FLASK_APP=app.py \
    FLASK_ENV=production \
    PORT=5000 \
    STATIC_FOLDER=/static

ENTRYPOINT ["/bin/sh", "/app/entrypoint.sh"]
