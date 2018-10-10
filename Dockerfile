FROM centos/httpd-24-centos7:latest
LABEL maintainer="Gerald Schmidt <gerald1248@gmail.com>"
LABEL description="Continuous documentation"
COPY doc/output/index.html /var/www/html/
COPY doc/output/images /var/www/html/
