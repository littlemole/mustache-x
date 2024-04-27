FROM ubuntu:22.04

ENV TZ=Etc/UTC
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y python3-flask python3-mysql.connector python3-pip

RUN pip install chevron

ADD . /opt/contacts

CMD cd /opt/contacts/ && python3 app.py