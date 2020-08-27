FROM quay.io/snehakpersistent/multi-arch-travis:ppc64le

RUN apt-get -y update \
    && export DEBIAN_FRONTEND="noninteractive" \
    && apt-get -y install tzdata \
    && apt-get install -y apache2 \
    && apt-get install -y php libapache2-mod-php

ADD index.php /var/www/html/

RUN sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf && sed -i 's/VirtualHost *:80/VirtualHost *:8080/' /etc/apache2/sites-enabled/000-default.conf

EXPOSE 8080

RUN service apache2 start

USER 1001

RUN curl http://localhost:8080

CMD php-fpm & apachectl -D FOREGROUND

CMD sleep 2000s
