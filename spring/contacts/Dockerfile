FROM ubuntu

ENV TZ=Etc/UTC
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
	openjdk-17-jdk maven dnsutils mariadb-client
	

ADD . /opt/contacts

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/

#CMD sleep infinity

RUN cd /opt/contacts && ./mvnw clean && ./mvnw package -DskipTests

#RUN nslookup mariadb

CMD cd /opt/contacts/ && java -jar target/contacts-0.0.1-SNAPSHOT.jar
