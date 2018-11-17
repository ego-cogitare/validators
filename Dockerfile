FROM postgres:latest

ENV POSTGRES_PASSWORD=mdm 
ENV POSTGRES_DB=monolith
ENV POSTGRES_USER=mdm

# DATABASE INITIAL DUMP
COPY bootstrap.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/bootstrap.sh
RUN ln -s usr/local/bin/bootstrap.sh /
COPY db/dump.sql /docker-entrypoint-initdb.d/

# INSTALL PHP 7.2
RUN apt update && \
    apt -y install wget \
                   apt-transport-https \
                   ca-certificates
RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN sh -c 'echo "deb https://packages.sury.org/php/ stretch main" > /etc/apt/sources.list.d/php.list'	

# INSTALL DEPENDENCIES
RUN apt update && \
    apt -y install curl \ 
		   git \ 
		   php-cli \
		   php-ast \
		   php-xml \
		   php-zip \ 
		   php-mbstring \ 
		   php-curl \ 
		   php-pgsql

# COMPOSER
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

ENTRYPOINT ["/bin/bash", "bootstrap.sh"]
CMD ["postgres"]
