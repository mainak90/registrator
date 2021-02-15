FROM 049736579808.dkr.ecr.eu-west-1.amazonaws.com/registrator:v7.1

COPY docker-entrypoint.sh /bin/docker-entrypoint.sh

RUN chmod 777 /bin/docker-entrypoint.sh

ENV STOP_TIMEOUT 1200000

STOPSIGNAL SIGQUIT

ENTRYPOINT ["/bin/docker-entrypoint.sh"]

CMD ["-cleanup=true", "-ttl=1800", "-ttl-refresh=600", "consul://127.0.0.1:8500"]