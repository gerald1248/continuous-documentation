FROM centos/httpd-24-centos7:latest
LABEL maintainer="Gerald Schmidt <gerald1248@gmail.com>"
LABEL description="Continuous documentation"
ADD output/index.html /var/www/html/
ADD output/images /var/www/html/images
ADD output/*.pdf /var/www/html/
