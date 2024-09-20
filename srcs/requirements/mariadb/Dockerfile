FROM debian:11

RUN apt-get update && apt-get upgrade -y && apt-get install -y mariadb-server

COPY ./tools/script.sh .

ENTRYPOINT ["./script.sh"]
