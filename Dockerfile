FROM centos/httpd-24-centos7:latest
LABEL maintainer="Gerald Schmidt <gerald1248@gmail.com>"
LABEL description="Continuous documentation"
ADD doc/output/index.html /var/www/html/
ADD doc/output/images /var/www/html/images
ADD doc/output/*.pdf /var/www/html/
