FROM composer:2

# The default root user id in this image is 0
ARG UID=0

RUN mkdir -p /app/vendor \
    && chown -R $UID:$UID /app
