FROM quay.io/snehakpersistent/multi-arch-travis:ppc64le

RUN apt-get -y update \
    && apt-get install -y apache2 php libapache2-mod-php

ADD index.php /var/www/html/

EXPOSE 8080

USER 1001

CMD php-fpm & apachectl -D FOREGROUND

CMD sleep 2000s
