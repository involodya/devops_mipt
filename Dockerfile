FROM alpine:3.18

RUN apk add --no-cache nginx && \
    addgroup -S app_group && \
    adduser -S app_user -G app_group && \
    mkdir -p /home/app_user/html && \
    chown -R app_user:app_group /home/app_user && \
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    mkdir -p /var/lib/nginx/tmp && \
    chown -R app_user:app_group /var/lib/nginx

EXPOSE 8080

USER app_user

CMD ["nginx", "-g", "daemon off;"]
