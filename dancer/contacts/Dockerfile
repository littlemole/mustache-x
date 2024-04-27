FROM ubuntu:22.04

ENV TZ=Etc/UTC
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential curl libapache-logformat-compiler-perl \
    libdbd-mysql-perl libmariadb-dev

RUN curl -L https://cpanmin.us | perl - -- Dancer2
RUN curl -L https://cpanmin.us | perl - -- Template::Mustache
RUN curl -L https://cpanmin.us | perl - -- DBD::MariaDB

ADD . /opt/contacts

CMD cd /opt/contacts/ && perl app.pl