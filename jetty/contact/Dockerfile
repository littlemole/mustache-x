FROM ubuntu:22.04

ENV TZ=Etc/UTC

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
	openjdk-17-jdk maven dnsutils mariadb-client locales
	
RUN sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=en_US.UTF-8

ENV LANG en_US.UTF-8 

ADD . /opt/contacts

ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64/
ENV JDBC_URL="jdbc:mariadb://mariadb/contacts?user=contacts&password=contact&useUnicode=true&amp;characterEncoding=UTF-8"

RUN cd /opt/contacts && mvn clean && mvn package -DskipTests

CMD cd /opt/contacts/ && java -DJDBC_URL=$JDBC_URL -jar target/contactsJetty-0.0.1-SNAPSHOT.jar 

