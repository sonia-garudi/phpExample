FROM quay.io/snehakpersistent/multi-arch-travis:x86_64

RUN apt-get -y update \
    && apt-get install -y curl \
    && export DEBIAN_FRONTEND="noninteractive" \
    && apt-get -y install tzdata \
    && apt-get install -y apache2 \
    && apt-get install -y php  php-common php-fpm libapache2-mod-php

ADD index.php /var/www/html/

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf \
    && sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf \
    && sed -i 's/VirtualHost *:80/VirtualHost *:8080/' /etc/apache2/sites-enabled/000-default.conf \
    && mkdir /run/php-fpm \
    && chgrp -R 0 /var/log/apache2 /var/run/apache2 /run/php-fpm \
    && chmod -R g=u /var/log/apache2 /var/run/apache2 /run/php-fpm

EXPOSE 8080

RUN service apache2 start

USER 1001

RUN curl http://localhost:8080

CMD /usr/sbin/apachectl -D FOREGROUND
