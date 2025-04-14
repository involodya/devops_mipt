FROM golang:1.16-alpine AS builder

RUN apk --no-cache add git && \
    rm -rf /var/cache/apk/*

WORKDIR /app

COPY go.mod ./

RUN go mod download

COPY main.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -ldflags="-s -w" -o /app/dockerapp

FROM alpine:3.15

RUN apk --no-cache add ca-certificates && \
    rm -rf /var/cache/apk/*

RUN adduser -D appuser

WORKDIR /app

COPY --from=builder /app/dockerapp .

RUN chown -R appuser:appuser /app

USER appuser

ENV PORT=8080
ENV MESSAGE="Привет из Docker! Многоэтапная сборка работает!"

EXPOSE $PORT

CMD ["./dockerapp"]
