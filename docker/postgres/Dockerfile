FROM postgres:13

# The default postgres user id in this image is 999
ARG UID=999

RUN chown ${UID}:${UID} /var/lib/postgresql/data
