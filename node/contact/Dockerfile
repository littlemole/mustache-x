FROM ubuntu:22.04

ENV TZ=Etc/UTC
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
    build-essential curl libmariadb-dev

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

RUN . ~/.nvm/nvm.sh && nvm install 20

RUN . ~/.nvm/nvm.sh && node -v # should print `v20.12.0`

RUN . ~/.nvm/nvm.sh && npm -v # should print `10.5.0`

ADD . /opt/contacts

RUN . ~/.nvm/nvm.sh && cd /opt/contacts && npm install

CMD . ~/.nvm/nvm.sh && cd /opt/contacts/ && node server.js