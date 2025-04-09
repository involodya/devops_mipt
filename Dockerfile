FROM alpine:3.18

RUN apk add --no-cache nginx && \
    addgroup -S appgroup && \
    adduser -S app_user -G appgroup && \
    mkdir -p /home/app_user/nginx/logs \
             /home/app_user/nginx/run \
             /home/app_user/nginx/cache/client_body \
             /home/app_user/nginx/cache/proxy \
             /home/app_user/nginx/cache/fastcgi \
             /home/app_user/nginx/cache/uwsgi \
             /home/app_user/nginx/cache/scgi \
             /home/app_user/html && \
    mkdir -p /var/lib/nginx/logs && \
    ln -sf /dev/stdout /var/lib/nginx/logs/access.log && \
    ln -sf /dev/stderr /var/lib/nginx/logs/error.log && \
    chown -R app_user:appgroup /home/app_user && \
    chown -R app_user:appgroup /var/lib/nginx

EXPOSE 8080

USER app_user

CMD ["nginx", "-g", "daemon off;"]
