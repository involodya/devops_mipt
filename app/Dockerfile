FROM python:3.9-alpine

RUN addgroup -S appgroup && adduser -S appuser -G appgroup

WORKDIR /app
COPY requirements.txt .

RUN apk add --no-cache postgresql-libs && \
    apk add --no-cache --virtual .build-deps gcc musl-dev postgresql-dev && \
    pip install --no-cache-dir -r requirements.txt && \
    apk del .build-deps && \
    rm -rf /var/cache/apk/* /root/.cache/pip/*

COPY . .

RUN chmod +x entrypoint.sh && \
    chown -R appuser:appgroup /app

USER appuser

ENV FLASK_APP=app.py \
    FLASK_ENV=production \
    PORT=5000 \
    STATIC_FOLDER=/static

ENTRYPOINT ["./entrypoint.sh"]
