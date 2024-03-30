FROM ubuntu

ENV TZ=Etc/UTC
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
	php8.1 php8.1-ctype php8.1-iconv php-composer-pcre \
	php8.1-simplexml php8.1-tokenizer composer curl
	
RUN DEBIAN_FRONTEND=noninteractive curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.deb.sh' | bash
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
	php-symfony-doctrine-bridge php8.1-pdo-mysql
	
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
	symfony-cli #=5.8.12 # newer 5.8.13 had problems, solved in 5.8.14

ADD . /opt/contacts

RUN cd /opt/contacts/contacts && composer install

CMD cd /opt/contacts/contacts && symfony server:start