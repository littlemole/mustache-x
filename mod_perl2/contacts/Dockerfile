FROM ubuntu:22.04

ENV TZ=Etc/UTC
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential curl libapache-logformat-compiler-perl \
    libdbd-mysql-perl libmariadb-dev libapache2-mod-perl2  \
    libapache2-mod-perl2-dev libapache2-request-perl \
    libapache2-mod-apreq2 apache2-utils apache2
    

RUN curl -L https://cpanmin.us | perl - -- Template::Mustache
RUN curl -L https://cpanmin.us | perl - -- DBD::MariaDB
RUN curl -L https://cpanmin.us | perl - -- JSON

ADD docker/000-default.conf /etc/apache2/sites-available/000-default.conf
ADD docker/ports.conf /etc/apache2/ports.conf

RUN a2enmod lbmethod_byrequests

ADD . /opt/contacts

CMD /usr/sbin/apache2ctl -D FOREGROUND || cat /var/log/apache2/error.log
