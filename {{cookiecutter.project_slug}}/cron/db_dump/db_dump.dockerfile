FROM postgres:12

WORKDIR /root
COPY ./postgresqlbackup.sh /postgresqlbackup.sh
ARG POSTGRES_SERVER=db
ARG POSTGRES_USER=postgres
ARG POSTGRES_PASSWORD
RUN echo "$POSTGRES_SERVER:*:*:$POSTGRES_USER:$POSTGRES_PASSWORD" > .pgpass && chmod 400 .pgpass

CMD ["bash", "/postgresqlbackup.sh"]