FROM alpine:latest

RUN apk add --no-cache nginx

RUN addgroup -S app_group && adduser -S app_user -G app_group

RUN mkdir -p /home/app_user/html && \
    chown -R app_user:app_group /home/app_user

RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

RUN mkdir -p /var/lib/nginx/tmp && \
    chown -R app_user:app_group /var/lib/nginx

EXPOSE 8080

USER app_user

CMD ["nginx", "-g", "daemon off;"]
