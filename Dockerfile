FROM quay.io/snehakpersistent/multi-arch-travis:ppc64le

RUN apt-get -y update \
    && apt-get install -y curl \
    && export DEBIAN_FRONTEND="noninteractive" \
    && apt-get -y install tzdata \
    && apt-get install -y apache2 
#    && apt-get install -y php  php-common php-fpm libapache2-mod-php

ADD index.php /var/www/html/

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf \
    && sed -i 's/Listen 80/Listen 9090/' /etc/apache2/ports.conf \
    && sed -i 's/VirtualHost *:80/VirtualHost *:9090/' /etc/apache2/sites-enabled/000-default.conf \
    && chgrp -R 0 /var/log/apache2 \
    && chmod -R g=u /var/log/apache2
 #   && mkdir /run/php-fpm \
 #   && chgrp -R 0 /var/log/apache2 /var/run/apache2 /run/php-fpm \
  #  && chmod -R g=u /var/log/apache2 /var/run/apache2 /run/php-fpm

EXPOSE 9090

RUN a2enmod lbmethod_byrequests

RUN service apache2 start

RUN curl http://localhost:9090

CMD /usr/sbin/apachectl -D FOREGROUND

USER 1001
