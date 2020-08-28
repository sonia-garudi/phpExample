FROM quay.io/snehakpersistent/multi-arch-travis:ppc64le

RUN apt-get -y update \
  && apt-get install -y curl

RUN export DEBIAN_FRONTEND="noninteractive" \
    && apt-get install -y apache2

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf \
    && sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf \
    && sed -i 's/VirtualHost *:80/VirtualHost *:8080/' /etc/apache2/sites-enabled/000-default.conf \
    && mkdir -p /var/run/apache2 \
    && chgrp -R 0 /var/log/apache2 /var/run/apache2 \
    && chmod -R g=u /var/log/apache2 /var/run/apache2

EXPOSE 8080

RUN service apache2 start

RUN apt-get install -y php  php-common php-fpm libapache2-mod-php

ADD index.php /var/www/html

RUN mkdir /run/php-fpm \
    && chgrp -R 0 /var/run/apache2 /run/php-fpm \
    && chmod -R g=u /var/run/apache2 /run/php-fpm

RUN php -v

RUN service apache2 restart

RUN curl http://localhost:8080/index.php

CMD /usr/sbin/apache2ctl -DFOREGROUND

USER 1001
