FROM ubuntu:latest
MAINTAINER pgoyal0512@gmail.com
RUN apt-get update && ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && apt-get install -y tzdata && dpkg-reconfigure --frontend noninteractive tzdata && apt-get install -y nginx && apt-get install -y systemctl && apt-get install -y php-fpm && apt-get install -y php-mysql 
RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/8.1/fpm/php.ini && sed -i 's/;listen.mode = 0660/listen.mode = 0666/' /etc/php/8.1/fpm/pool.d/www.conf
RUN sed -i 's/index index\.html index\.htm index\.nginx-debian\.html;/index index\.php index\.html index\.htm index\.nginx-debian\.html;/' /etc/nginx/sites-available/default && sed -i 's/#location ~ \\\.php\$ {/location ~ \\\.php\$ {/' /etc/nginx/sites-available/default && sed -i 's/#\tinclude snippets\/fastcgi-php.conf;/\tinclude snippets\/fastcgi-php.conf;/' /etc/nginx/sites-available/default && sed -i 's/#\tfastcgi_pass unix:\/run\/php\/php7.4-fpm.sock;/\tfastcgi_pass unix:\/run\/php\/php8.1-fpm.sock;\n\t}/' /etc/nginx/sites-available/default




RUN echo "<?php phpinfo();?>" > /var/www/html/index.php

CMD ["/bin/bash", "-c", "systemctl start nginx && systemctl start php8.1-fpm && systemctl status nginx && systemctl status php8.1-fpm && nginx -g 'daemon off;'"]

ENTRYPOINT service php8.1-fpm start && nginx -g "daemon off;"


EXPOSE 80
