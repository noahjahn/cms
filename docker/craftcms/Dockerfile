FROM craftcms/nginx:8.0

# The default www-data user id in this image is 82
ARG UID=82

ENV NGINX_PROXY_SEND_TIMEOUT=240s
ENV NGINX_PROXY_READ_TIMEOUT=240s
ENV NGINX_FASTCGI_SEND_TIMEOUT=240s
ENV NGINX_FASTCGI_READ_TIMEOUT=240s
ENV PHP_OPCACHE_ENABLE=0
ENV PHP_DATE_TIMEZONE=UTC
ENV PORT=80

USER root

RUN apk --no-cache add shadow \
    && find / -group www-data -exec chgrp -h $UID {} \; \
    && find / -user www-data -exec chown -h $UID {} \; \
    && usermod -u $UID www-data \
    && groupmod -g $UID www-data \
    && apk del shadow

RUN apk --no-cache add gettext postgresql-client

RUN mkdir -p /var/lib/nginx /etc/nginx/conf.d /app/storage \
    && chown -R www-data:www-data /var/lib/nginx /etc/nginx/conf.d /app/storage \
    && chmod -R 775 /var/lib/nginx /etc/nginx/conf.d /app/storage

RUN touch /var/lib/nginx/logs/error.log && chown www-data:www-data /var/lib/nginx/logs/error.log

ADD --chown=www-data:www-data docker/bin/start.sh /app/docker/bin/
ADD --chown=www-data:www-data docker/craftcms/nginx/templates/* /etc/nginx/templates/
ADD --chown=www-data:www-data docker/craftcms/nginx/nginx.conf /etc/nginx/
ADD --chown=www-data:www-data docker/craftcms/php/zzz-custom.ini /usr/local/etc/php/conf.d/
ADD --chown=www-data:www-data docker/craftcms/php-fpm/zzz-custom.conf /usr/local/etc/php-fpm.d/

USER www-data

ENTRYPOINT ["sh", "/app/docker/bin/start.sh"]
