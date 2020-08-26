FROM quay.io/snehakpersistent/multi-arch-travis:ppc64le

RUN apt-get -y update \
    && apt-get install -y php php-fpm

ADD index.php /var/www/html

EXPOSE 8080

USER 1001

CMD php-fpm & httpd -D FOREGROUND

CMD sleep 2000s
