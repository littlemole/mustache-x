FROM ubuntu

ENV TZ=Etc/UTC
RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
	php8.1 php8.1-ctype php8.1-iconv php-composer-pcre \
	php8.1-simplexml php8.1-tokenizer  php8.1-pdo-mysql \
	php8.1-curl composer curl
	
ADD . /opt/contacts

RUN cd /opt/contacts/ && composer install

CMD cd /opt/contacts/ && php artisan serve --host=0.0.0.0 --port=8000